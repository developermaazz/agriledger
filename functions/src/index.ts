import * as crypto from "crypto";
import * as admin from "firebase-admin";
import { HttpsError, onCall, CallableRequest } from "firebase-functions/v2/https";
import { setGlobalOptions } from "firebase-functions/v2/options";
import { logger } from "firebase-functions";

setGlobalOptions({ region: "us-central1", maxInstances: 10 });

admin.initializeApp();
const db = admin.firestore();

function requireEnv(name: string): string {
  const v = process.env[name];
  if (!v || v.trim().length === 0) {
    logger.error(`${name} is not set`);
    throw new HttpsError(
      "failed-precondition",
      "Authentication service is not configured."
    );
  }
  return v;
}

const OTP_LEN = 6;
const OTP_TTL_MS = 10 * 60 * 1000;
const OTP_RESEND_COOLDOWN_MS = 60 * 1000;
const MAX_OTP_ATTEMPTS = 5;
const MAX_LOGIN_ATTEMPTS_WINDOW = 15;
const LOGIN_WINDOW_MS = 15 * 60 * 1000;
const LOCKOUT_MS = 15 * 60 * 1000;

function normalizeEmail(email: string): string {
  return email.trim().toLowerCase();
}

function emailRegistryDocId(email: string): string {
  return crypto.createHash("sha256").update(normalizeEmail(email)).digest("hex");
}

function isE164(phone: string): boolean {
  return /^\+[1-9]\d{6,14}$/.test(phone.trim());
}

function hashOtp(otp: string, secret: string): string {
  return crypto.createHmac("sha256", secret).update(otp).digest("hex");
}

function randomDigits(len: number): string {
  const buf = crypto.randomBytes(len);
  let s = "";
  for (let i = 0; i < len; i++) {
    s += (buf[i] % 10).toString();
  }
  return s.padStart(len, "0").slice(-len);
}

async function checkRateLimit(
  bucketKey: string,
  maxPerWindow: number,
  windowMs: number
): Promise<void> {
  const ref = db.collection("auth_rate_limits").doc(bucketKey);
  await db.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    const now = Date.now();
    const data = snap.data() as { windowStart?: number; count?: number } | undefined;
    let windowStart = data?.windowStart ?? now;
    let count = data?.count ?? 0;
    if (now - windowStart > windowMs) {
      windowStart = now;
      count = 0;
    }
    if (count >= maxPerWindow) {
      throw new HttpsError(
        "resource-exhausted",
        "Too many attempts. Try again later."
      );
    }
    tx.set(ref, {
      windowStart,
      count: count + 1,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  });
}

function getClientIp(request: CallableRequest): string {
  const fwd = request.rawRequest?.headers?.["x-forwarded-for"];
  if (typeof fwd === "string" && fwd.length > 0) {
    return fwd.split(",")[0].trim();
  }
  return request.rawRequest?.socket?.remoteAddress ?? "unknown";
}

async function identityToolkitSignIn(
  email: string,
  password: string
): Promise<string> {
  const key = requireEnv("WEB_API_KEY");
  const url =
    "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" +
    key;
  const res = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      email,
      password,
      returnSecureToken: true,
    }),
  });
  const json = (await res.json()) as {
    localId?: string;
    error?: { message: string };
  };
  if (!res.ok || !json.localId) {
    const code = json.error?.message ?? "INVALID_PASSWORD";
    if (
      code.includes("INVALID_PASSWORD") ||
      code.includes("EMAIL_NOT_FOUND")
    ) {
      throw new HttpsError("not-found", "Invalid phone or password.");
    }
    throw new HttpsError("internal", "Sign-in failed.");
  }
  return json.localId;
}

async function sendOtpEmail(to: string, otp: string): Promise<void> {
  const apiKey = process.env.SENDGRID_API_KEY;
  if (!apiKey) {
    if (process.env.FUNCTIONS_EMULATOR === "true") {
      logger.info(`[emulator] OTP for ${to}: ${otp}`);
    } else {
      logger.warn("SENDGRID_API_KEY not set; OTP email not sent.");
    }
    return;
  }
  const res = await fetch("https://api.sendgrid.com/v3/mail/send", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      personalizations: [{ to: [{ email: to }] }],
      from: { email: process.env.OTP_FROM_EMAIL ?? "noreply@example.com" },
      subject: "Your Agri Ledger verification code",
      content: [
        {
          type: "text/plain",
          value: `Your verification code is: ${otp}\nIt expires in 10 minutes.`,
        },
      ],
    }),
  });
  if (!res.ok) {
    const t = await res.text();
    logger.error("SendGrid error", t);
    throw new HttpsError("internal", "Could not send verification email.");
  }
}

/** After email/password signup: register name, phone, uniqueness indexes. */
export const finalizeProfile = onCall(async (request) => {
  if (!request.auth?.uid) {
    throw new HttpsError("unauthenticated", "Sign in required.");
  }
  const uid = request.auth.uid;
  const email = request.auth.token.email;
  if (!email) {
    throw new HttpsError("failed-precondition", "Email not available on account.");
  }

  const fullName = String(request.data?.fullName ?? "").trim();
  const phoneE164 = String(request.data?.phoneE164 ?? "").trim();
  if (fullName.length < 2 || fullName.length > 120) {
    throw new HttpsError("invalid-argument", "Enter your full name.");
  }
  if (!isE164(phoneE164)) {
    throw new HttpsError("invalid-argument", "Enter a valid phone number with country code.");
  }

  const regEmail = emailRegistryDocId(email);
  const normEmail = normalizeEmail(email);
  const userRecord = await admin.auth().getUser(uid);

  await db.runTransaction(async (tx) => {
    const emailRef = db.collection("registry_emails").doc(regEmail);
    const phoneRef = db.collection("registry_phones").doc(phoneE164);
    const userRef = db.collection("users").doc(uid);
    const emailSnap = await tx.get(emailRef);
    const phoneSnap = await tx.get(phoneRef);
    const userSnap = await tx.get(userRef);

    if (emailSnap.exists) {
      const d = emailSnap.data() as { uid?: string };
      if (d.uid !== uid) {
        throw new HttpsError("already-exists", "This email is already registered.");
      }
    }
    if (phoneSnap.exists) {
      const d = phoneSnap.data() as { uid?: string };
      if (d.uid !== uid) {
        throw new HttpsError("already-exists", "This phone number is already registered.");
      }
    }

    tx.set(emailRef, {
      uid,
      email: normEmail,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    tx.set(phoneRef, {
      uid,
      phoneE164,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    tx.set(
      db.collection("phone_login_index").doc(phoneE164),
      {
        uid,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      }
    );

    const profile: Record<string, unknown> = {
      name: fullName,
      email: normEmail,
      phoneE164,
      isVerified: userRecord.emailVerified ?? false,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };
    if (!userSnap.exists) {
      profile.createdAt = admin.firestore.FieldValue.serverTimestamp();
    }
    tx.set(userRef, profile, { merge: true });
  });

  return { ok: true };
});

/** Sign in with E.164 phone + password (maps to email credentials server-side). */
export const signInWithPhonePassword = onCall(
  { secrets: ["WEB_API_KEY"] },
  async (request) => {
  const phoneE164 = String(request.data?.phoneE164 ?? "").trim();
  const password = String(request.data?.password ?? "");
  if (!isE164(phoneE164) || password.length < 6) {
    throw new HttpsError("invalid-argument", "Invalid phone or password.");
  }

  const ip = getClientIp(request);
  await checkRateLimit(
    `login_${phoneE164}_${ip}`,
    MAX_LOGIN_ATTEMPTS_WINDOW,
    LOGIN_WINDOW_MS
  );

  const failsRef = db.collection("auth_rate_limits").doc(`fails_${phoneE164}`);
  const failsSnap = await failsRef.get();
  const lockUntil = failsSnap.data()?.lockedUntil as number | undefined;
  if (lockUntil && Date.now() < lockUntil) {
    throw new HttpsError(
      "resource-exhausted",
      "Too many failed attempts. Try again later."
    );
  }

  const idx = await db.collection("phone_login_index").doc(phoneE164).get();
  if (!idx.exists) {
    throw new HttpsError("not-found", "Invalid phone or password.");
  }
  const mappedUid = (idx.data() as { uid: string }).uid;
  const userRecord = await admin.auth().getUser(mappedUid);
  const em = userRecord.email;
  if (!em) {
    throw new HttpsError("failed-precondition", "Account has no email.");
  }

  try {
    const uid = await identityToolkitSignIn(em, password);
    const customToken = await admin.auth().createCustomToken(uid);
    await db.collection("auth_rate_limits").doc(`fails_${phoneE164}`).delete().catch(() => undefined);
    return { customToken };
  } catch (e) {
    if (e instanceof HttpsError) {
      const failsRef = db.collection("auth_rate_limits").doc(`fails_${phoneE164}`);
      await db.runTransaction(async (tx) => {
        const s = await tx.get(failsRef);
        const n = ((s.data()?.count as number) ?? 0) + 1;
        const payload: Record<string, unknown> = { count: n, updatedAt: Date.now() };
        if (n >= 8) {
          payload.lockedUntil = Date.now() + LOCKOUT_MS;
        }
        tx.set(failsRef, payload, { merge: true });
      });
    }
    throw e;
  }
});

export const requestEmailVerificationOtp = onCall(
  { secrets: ["SENDGRID_API_KEY", "OTP_FROM_EMAIL"] },
  async (request) => {
  if (!request.auth?.uid) {
    throw new HttpsError("unauthenticated", "Sign in required.");
  }
  const uid = request.auth.uid;
  const userRecord = await admin.auth().getUser(uid);
  const email = userRecord.email;
  if (!email) {
    throw new HttpsError("failed-precondition", "No email on account.");
  }
  if (userRecord.emailVerified) {
    return { alreadyVerified: true };
  }

  await checkRateLimit(`otp_req_${uid}`, 5, 60 * 60 * 1000);

  const challengeRef = db.collection("email_otp_challenges").doc(uid);
  const existing = await challengeRef.get();
  const lastSent = existing.data()?.lastSentAt as admin.firestore.Timestamp | undefined;
  if (lastSent) {
    const elapsed = Date.now() - lastSent.toMillis();
    if (elapsed < OTP_RESEND_COOLDOWN_MS) {
      const waitSec = Math.ceil((OTP_RESEND_COOLDOWN_MS - elapsed) / 1000);
      throw new HttpsError(
        "resource-exhausted",
        `Wait ${waitSec}s before resending.`
      );
    }
  }

  const otp = randomDigits(OTP_LEN);
  const secret = crypto.randomBytes(32).toString("hex");
  const otpHash = hashOtp(otp, secret);

  await challengeRef.set({
    otpHash,
    secret,
    expiresAt: admin.firestore.Timestamp.fromMillis(Date.now() + OTP_TTL_MS),
    attempts: 0,
    lastSentAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  await sendOtpEmail(email, otp);
  return { ok: true };
});

export const verifyEmailOtp = onCall(async (request) => {
  if (!request.auth?.uid) {
    throw new HttpsError("unauthenticated", "Sign in required.");
  }
  const uid = request.auth.uid;
  const otp = String(request.data?.otp ?? "").replace(/\D/g, "");
  if (otp.length !== OTP_LEN) {
    throw new HttpsError("invalid-argument", "Enter the 6-digit code.");
  }

  const challengeRef = db.collection("email_otp_challenges").doc(uid);
  await checkRateLimit(`otp_verify_${uid}`, 20, 60 * 60 * 1000);

  await db.runTransaction(async (tx) => {
    const snap = await tx.get(challengeRef);
    if (!snap.exists) {
      throw new HttpsError("not-found", "No verification code pending. Request a new code.");
    }
    const d = snap.data() as {
      otpHash: string;
      secret: string;
      expiresAt: admin.firestore.Timestamp;
      attempts: number;
    };
    if (d.expiresAt.toMillis() < Date.now()) {
      tx.delete(challengeRef);
      throw new HttpsError("deadline-exceeded", "Code expired. Request a new one.");
    }
    if (d.attempts >= MAX_OTP_ATTEMPTS) {
      throw new HttpsError(
        "resource-exhausted",
        "Too many incorrect attempts. Request a new code."
      );
    }
    const expected = hashOtp(otp, d.secret);
    if (expected !== d.otpHash) {
      tx.update(challengeRef, { attempts: d.attempts + 1 });
      throw new HttpsError("invalid-argument", "Incorrect code.");
    }
    tx.delete(challengeRef);
  });

  await admin.auth().updateUser(uid, { emailVerified: true });
  await db.collection("users").doc(uid).set(
    { isVerified: true },
    { merge: true }
  );

  return { ok: true };
});

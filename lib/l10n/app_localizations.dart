import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Agri Ledger'**
  String get appTitle;

  /// No description provided for @appTitleWord1.
  ///
  /// In en, this message translates to:
  /// **'Agri'**
  String get appTitleWord1;

  /// No description provided for @appTitleWord2.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get appTitleWord2;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get commonOpen;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonWorking.
  ///
  /// In en, this message translates to:
  /// **'Working...'**
  String get commonWorking;

  /// No description provided for @commonActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get commonActions;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @commonStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get commonStatus;

  /// No description provided for @commonPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get commonPending;

  /// No description provided for @commonCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get commonCompleted;

  /// No description provided for @commonOverpaid.
  ///
  /// In en, this message translates to:
  /// **'Overpaid'**
  String get commonOverpaid;

  /// No description provided for @commonRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get commonRequired;

  /// No description provided for @commonInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get commonInvalid;

  /// No description provided for @commonSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get commonSaving;

  /// No description provided for @feedbackShipmentAdded.
  ///
  /// In en, this message translates to:
  /// **'Shipment saved'**
  String get feedbackShipmentAdded;

  /// No description provided for @feedbackShipmentUpdated.
  ///
  /// In en, this message translates to:
  /// **'Shipment updated'**
  String get feedbackShipmentUpdated;

  /// No description provided for @feedbackCashEntryAdded.
  ///
  /// In en, this message translates to:
  /// **'Cash entry saved'**
  String get feedbackCashEntryAdded;

  /// No description provided for @feedbackCashEntryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Cash entry updated'**
  String get feedbackCashEntryUpdated;

  /// No description provided for @feedbackLabourAdded.
  ///
  /// In en, this message translates to:
  /// **'Labour record saved'**
  String get feedbackLabourAdded;

  /// No description provided for @feedbackLabourUpdated.
  ///
  /// In en, this message translates to:
  /// **'Labour record updated'**
  String get feedbackLabourUpdated;

  /// No description provided for @feedbackRecordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get feedbackRecordDeleted;

  /// No description provided for @cashEntryDeletedSnack.
  ///
  /// In en, this message translates to:
  /// **'Cash entry deleted'**
  String get cashEntryDeletedSnack;

  /// No description provided for @authSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get authSignedIn;

  /// No description provided for @authAccountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created'**
  String get authAccountCreated;

  /// No description provided for @authFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authFailed;

  /// No description provided for @authSubtitleRegister.
  ///
  /// In en, this message translates to:
  /// **'Create an account to sync shipments, cash, and labour.'**
  String get authSubtitleRegister;

  /// No description provided for @authSubtitleLogin.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage fruit trading and finances.'**
  String get authSubtitleLogin;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get authEmailRequired;

  /// No description provided for @authEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get authEmailInvalid;

  /// No description provided for @authPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get authPasswordTooShort;

  /// No description provided for @authPleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get authPleaseWait;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateAccount;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get authAlreadyHaveAccount;

  /// No description provided for @authNewHere.
  ///
  /// In en, this message translates to:
  /// **'New here? Create an account'**
  String get authNewHere;

  /// No description provided for @authFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get authFullNameLabel;

  /// No description provided for @authPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get authPhoneLabel;

  /// No description provided for @authPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Include country code (e.g. +92…)'**
  String get authPhoneHint;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPasswordMismatch;

  /// No description provided for @authPasswordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters with upper, lower, and a number.'**
  String get authPasswordRequirements;

  /// No description provided for @authLoginWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authLoginWithEmail;

  /// No description provided for @authLoginWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get authLoginWithPhone;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authRememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get authRememberMe;

  /// No description provided for @authVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get authVerifyTitle;

  /// No description provided for @authVerifySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a link to your inbox. Use Resend if you need a new one.'**
  String get authVerifySubtitle;

  /// No description provided for @authResendVerificationEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend verification email'**
  String get authResendVerificationEmail;

  /// No description provided for @authCheckedVerification.
  ///
  /// In en, this message translates to:
  /// **'I\'ve verified — continue'**
  String get authCheckedVerification;

  /// No description provided for @authOtpSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Email code'**
  String get authOtpSectionTitle;

  /// No description provided for @authOtpHint.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get authOtpHint;

  /// No description provided for @authRequestOtp.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get authRequestOtp;

  /// No description provided for @authVerifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get authVerifyOtp;

  /// No description provided for @authForgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get authForgotTitle;

  /// No description provided for @authForgotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send a reset link.'**
  String get authForgotSubtitle;

  /// No description provided for @authSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get authSendResetLink;

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get authBackToLogin;

  /// No description provided for @authResetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password'**
  String get authResetPasswordTitle;

  /// No description provided for @authNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get authNewPasswordLabel;

  /// No description provided for @authResetSubmit.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get authResetSubmit;

  /// No description provided for @authSignupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get authSignupTitle;

  /// No description provided for @authPasswordStrengthWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get authPasswordStrengthWeak;

  /// No description provided for @authPasswordStrengthFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get authPasswordStrengthFair;

  /// No description provided for @authPasswordStrengthGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get authPasswordStrengthGood;

  /// No description provided for @authPasswordStrengthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get authPasswordStrengthStrong;

  /// No description provided for @authErrorUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get authErrorUserDisabled;

  /// No description provided for @authErrorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get authErrorInvalidCredentials;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered. Sign in instead.'**
  String get authErrorEmailInUse;

  /// No description provided for @authAccountAlreadyExistsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account already exists'**
  String get authAccountAlreadyExistsTitle;

  /// No description provided for @authAccountAlreadyExistsMessage.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered—often because a previous sign-up finished but the email was not verified yet.\n\nSign in with your password. You can send a new verification email from the next screen. If you forgot your password, use Forgot password.'**
  String get authAccountAlreadyExistsMessage;

  /// No description provided for @authGoToSignInFromSignup.
  ///
  /// In en, this message translates to:
  /// **'Go to sign in'**
  String get authGoToSignInFromSignup;

  /// No description provided for @authPrefilledEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to continue. You can resend verification after signing in.'**
  String get authPrefilledEmailHint;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later.'**
  String get authErrorTooManyRequests;

  /// No description provided for @authErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Check your connection.'**
  String get authErrorNetwork;

  /// No description provided for @authErrorAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'That email or phone is already registered.'**
  String get authErrorAlreadyExists;

  /// No description provided for @authErrorUnauthenticated.
  ///
  /// In en, this message translates to:
  /// **'Please sign in again.'**
  String get authErrorUnauthenticated;

  /// No description provided for @authOtpSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent.'**
  String get authOtpSent;

  /// No description provided for @authOtpExpired.
  ///
  /// In en, this message translates to:
  /// **'That code expired. Request a new one.'**
  String get authOtpExpired;

  /// No description provided for @authVerifyEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Verify your email to continue.'**
  String get authVerifyEmailRequired;

  /// No description provided for @authEmailVerificationCompleted.
  ///
  /// In en, this message translates to:
  /// **'Email verified. Sign in to continue.'**
  String get authEmailVerificationCompleted;

  /// No description provided for @authVerificationStillPending.
  ///
  /// In en, this message translates to:
  /// **'We still don\'t see a verified email. Check your inbox or tap Resend.'**
  String get authVerificationStillPending;

  /// No description provided for @authEmailVerifiedFromLinkSnack.
  ///
  /// In en, this message translates to:
  /// **'Email address verified.'**
  String get authEmailVerifiedFromLinkSnack;

  /// No description provided for @authProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved.'**
  String get authProfileSaved;

  /// No description provided for @authProfileIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile to continue.'**
  String get authProfileIncomplete;

  /// No description provided for @authCompleteProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete profile'**
  String get authCompleteProfileTitle;

  /// No description provided for @authCompleteProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your name and phone to finish setup.'**
  String get authCompleteProfileSubtitle;

  /// No description provided for @authUnverifiedBlocked.
  ///
  /// In en, this message translates to:
  /// **'Verify your email before signing in.'**
  String get authUnverifiedBlocked;

  /// No description provided for @authTabEmailLink.
  ///
  /// In en, this message translates to:
  /// **'Email link'**
  String get authTabEmailLink;

  /// No description provided for @authTabOtpCode.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get authTabOtpCode;

  /// No description provided for @authPasswordResetDone.
  ///
  /// In en, this message translates to:
  /// **'Password updated. You can sign in now.'**
  String get authPasswordResetDone;

  /// No description provided for @authResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'If an account exists, we sent a reset link.'**
  String get authResetEmailSent;

  /// No description provided for @authVerificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent. Check your inbox.'**
  String get authVerificationEmailSent;

  /// No description provided for @creditsIntro.
  ///
  /// In en, this message translates to:
  /// **'Crafted with care'**
  String get creditsIntro;

  /// No description provided for @creditsAttributionPrefix.
  ///
  /// In en, this message translates to:
  /// **'Designed & developed by '**
  String get creditsAttributionPrefix;

  /// No description provided for @creditsAuthorName.
  ///
  /// In en, this message translates to:
  /// **'Muhammad Maaz Ali'**
  String get creditsAuthorName;

  /// No description provided for @creditsAuthorLinkA11yHint.
  ///
  /// In en, this message translates to:
  /// **'Opens the developer website'**
  String get creditsAuthorLinkA11yHint;

  /// No description provided for @creditsLinkCouldNotOpen.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link. Try again later.'**
  String get creditsLinkCouldNotOpen;

  /// No description provided for @shipmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Shipments'**
  String get shipmentsTitle;

  /// No description provided for @shipmentsNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New shipment'**
  String get shipmentsNewTitle;

  /// No description provided for @shipmentsEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit shipment'**
  String get shipmentsEditTitle;

  /// No description provided for @shipmentsDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Shipment details'**
  String get shipmentsDetailsTitle;

  /// No description provided for @shipmentsNoShipmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'No shipments'**
  String get shipmentsNoShipmentsTitle;

  /// No description provided for @shipmentsNoShipmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a shipment to get started.'**
  String get shipmentsNoShipmentsSubtitle;

  /// No description provided for @shipmentsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Buyer, market, remarks'**
  String get shipmentsSearchHint;

  /// No description provided for @shipmentsUnableToLoad.
  ///
  /// In en, this message translates to:
  /// **'Unable to load shipments'**
  String get shipmentsUnableToLoad;

  /// No description provided for @shipmentsUnableToLoadMarkets.
  ///
  /// In en, this message translates to:
  /// **'Unable to load markets'**
  String get shipmentsUnableToLoadMarkets;

  /// No description provided for @shipmentsStatusFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get shipmentsStatusFilterAll;

  /// No description provided for @shipmentsMarketFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All markets'**
  String get shipmentsMarketFilterAll;

  /// No description provided for @shipmentsMarketLabel.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get shipmentsMarketLabel;

  /// No description provided for @shipmentsDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get shipmentsDateLabel;

  /// No description provided for @shipmentsBuyerLabel.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get shipmentsBuyerLabel;

  /// No description provided for @shipmentsQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity (boxes/cartons)'**
  String get shipmentsQuantityLabel;

  /// No description provided for @shipmentsTotalAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get shipmentsTotalAmountLabel;

  /// No description provided for @shipmentsAmountReceivedLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount received'**
  String get shipmentsAmountReceivedLabel;

  /// No description provided for @shipmentsRemarksLabel.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get shipmentsRemarksLabel;

  /// No description provided for @shipmentsBalanceAuto.
  ///
  /// In en, this message translates to:
  /// **'Outstanding balance (calculated)'**
  String get shipmentsBalanceAuto;

  /// No description provided for @shipmentsAddMarketFirst.
  ///
  /// In en, this message translates to:
  /// **'Add a market first (Markets tab → add market).'**
  String get shipmentsAddMarketFirst;

  /// No description provided for @shipmentsDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete shipment?'**
  String get shipmentsDeleteConfirmTitle;

  /// No description provided for @shipmentsDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get shipmentsDeleteConfirmBody;

  /// No description provided for @shipmentsDeleted.
  ///
  /// In en, this message translates to:
  /// **'Shipment deleted'**
  String get shipmentsDeleted;

  /// No description provided for @shipmentsCompletedReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Completed (read-only)'**
  String get shipmentsCompletedReadOnly;

  /// No description provided for @labourTitle.
  ///
  /// In en, this message translates to:
  /// **'Labour'**
  String get labourTitle;

  /// No description provided for @labourNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New labour'**
  String get labourNewTitle;

  /// No description provided for @labourEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit labour'**
  String get labourEditTitle;

  /// No description provided for @labourDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Labour details'**
  String get labourDetailsTitle;

  /// No description provided for @labourNoRecordsTitle.
  ///
  /// In en, this message translates to:
  /// **'No labour records'**
  String get labourNoRecordsTitle;

  /// No description provided for @labourNoRecordsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track labour cost and payments.'**
  String get labourNoRecordsSubtitle;

  /// No description provided for @labourSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search remarks'**
  String get labourSearchHint;

  /// No description provided for @labourUnableToLoad.
  ///
  /// In en, this message translates to:
  /// **'Unable to load labour records'**
  String get labourUnableToLoad;

  /// No description provided for @labourStartDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get labourStartDateLabel;

  /// No description provided for @labourEndDateLabel.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get labourEndDateLabel;

  /// No description provided for @labourTotalCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Total labour cost'**
  String get labourTotalCostLabel;

  /// No description provided for @labourReceivedPaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment received'**
  String get labourReceivedPaymentLabel;

  /// No description provided for @labourRemarksLabel.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get labourRemarksLabel;

  /// No description provided for @labourRemainingAuto.
  ///
  /// In en, this message translates to:
  /// **'Remaining balance (calculated)'**
  String get labourRemainingAuto;

  /// No description provided for @labourDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete labour record?'**
  String get labourDeleteConfirmTitle;

  /// No description provided for @labourDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get labourDeleteConfirmBody;

  /// No description provided for @labourDeleted.
  ///
  /// In en, this message translates to:
  /// **'Labour record deleted'**
  String get labourDeleted;

  /// No description provided for @labourCompletedReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Completed (read-only)'**
  String get labourCompletedReadOnly;

  /// No description provided for @marketCashTitle.
  ///
  /// In en, this message translates to:
  /// **'Market cash'**
  String get marketCashTitle;

  /// No description provided for @marketNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New market'**
  String get marketNewTitle;

  /// No description provided for @marketNewHint.
  ///
  /// In en, this message translates to:
  /// **'Name (e.g. Lahore)'**
  String get marketNewHint;

  /// No description provided for @marketAdded.
  ///
  /// In en, this message translates to:
  /// **'Market \"{name}\" added'**
  String marketAdded(Object name);

  /// No description provided for @marketDeleted.
  ///
  /// In en, this message translates to:
  /// **'Market \"{name}\" deleted'**
  String marketDeleted(Object name);

  /// No description provided for @marketsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No markets yet'**
  String get marketsEmptyTitle;

  /// No description provided for @marketsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add Lahore or other markets to track cash.'**
  String get marketsEmptySubtitle;

  /// No description provided for @marketsDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete market?'**
  String get marketsDeleteConfirmTitle;

  /// No description provided for @marketsDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'If this market is used in any shipment, it cannot be deleted.\n\n\"{name}\" and its cash entries will be deleted.'**
  String marketsDeleteConfirmBody(Object name);

  /// No description provided for @marketsTapToOpenCashLedger.
  ///
  /// In en, this message translates to:
  /// **'Tap to open cash ledger'**
  String get marketsTapToOpenCashLedger;

  /// No description provided for @cashExportExcel.
  ///
  /// In en, this message translates to:
  /// **'Export Excel'**
  String get cashExportExcel;

  /// No description provided for @cashEntryButton.
  ///
  /// In en, this message translates to:
  /// **'Add entry'**
  String get cashEntryButton;

  /// No description provided for @cashNoEntriesTitle.
  ///
  /// In en, this message translates to:
  /// **'No cash entries'**
  String get cashNoEntriesTitle;

  /// No description provided for @cashNoEntriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add amount received and payments for this market.'**
  String get cashNoEntriesSubtitle;

  /// No description provided for @cashLedgerRowSummary.
  ///
  /// In en, this message translates to:
  /// **'Available {cash} · Payments {pay} · Balance {bal}'**
  String cashLedgerRowSummary(Object cash, Object pay, Object bal);

  /// No description provided for @cashDeleteEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete entry?'**
  String get cashDeleteEntryTitle;

  /// No description provided for @cashDeleteEntryBody.
  ///
  /// In en, this message translates to:
  /// **'Running totals will be recalculated.'**
  String get cashDeleteEntryBody;

  /// No description provided for @cashDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get cashDateLabel;

  /// No description provided for @cashAmountReceivedLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount received'**
  String get cashAmountReceivedLabel;

  /// No description provided for @cashPaymentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get cashPaymentsLabel;

  /// No description provided for @cashPreviousCashLabel.
  ///
  /// In en, this message translates to:
  /// **'Previous cash'**
  String get cashPreviousCashLabel;

  /// No description provided for @cashCashAvailableLabel.
  ///
  /// In en, this message translates to:
  /// **'Cash available'**
  String get cashCashAvailableLabel;

  /// No description provided for @cashBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get cashBalanceLabel;

  /// No description provided for @cashRemarksLabel.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get cashRemarksLabel;

  /// No description provided for @errorsSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorsSomethingWentWrong;

  /// No description provided for @errorsFirestoreBlocked.
  ///
  /// In en, this message translates to:
  /// **'Firestore is blocking access. Deploy the provided `firestore.rules` in Firebase Console (or put Firestore in test mode for development).'**
  String get errorsFirestoreBlocked;

  /// No description provided for @shipmentsListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{buyer} · Outstanding {bal}'**
  String shipmentsListSubtitle(Object buyer, Object bal);

  /// No description provided for @shipmentsListTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Shipment {serial} · {market}'**
  String shipmentsListTileTitle(Object serial, Object market);

  /// No description provided for @shipmentDetailAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Shipment {serial}'**
  String shipmentDetailAppBarTitle(Object serial);

  /// No description provided for @labourListTitle.
  ///
  /// In en, this message translates to:
  /// **'Labour #{serial} · {amount} outstanding'**
  String labourListTitle(Object serial, Object amount);

  /// No description provided for @labourListDateRange.
  ///
  /// In en, this message translates to:
  /// **'{dateStart} — {dateEnd}'**
  String labourListDateRange(Object dateStart, Object dateEnd);

  /// No description provided for @labourDetailAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Labour {serial}'**
  String labourDetailAppBarTitle(Object serial);

  /// No description provided for @cashLedgerListTitle.
  ///
  /// In en, this message translates to:
  /// **'Entry {serial} · {date}'**
  String cashLedgerListTitle(Object serial, Object date);

  /// No description provided for @cashEntryDetailsAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'{marketName} · Entry {serial}'**
  String cashEntryDetailsAppBarTitle(Object marketName, Object serial);

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardUnableToLoad.
  ///
  /// In en, this message translates to:
  /// **'Unable to load dashboard data'**
  String get dashboardUnableToLoad;

  /// No description provided for @dashboardUnableToLoadCash.
  ///
  /// In en, this message translates to:
  /// **'Unable to load cash balances'**
  String get dashboardUnableToLoadCash;

  /// No description provided for @dashboardOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get dashboardOverview;

  /// No description provided for @dashboardOverviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Performance at a glance'**
  String get dashboardOverviewSubtitle;

  /// No description provided for @dashboardPendingShipments.
  ///
  /// In en, this message translates to:
  /// **'Pending shipments'**
  String get dashboardPendingShipments;

  /// No description provided for @dashboardPendingShipmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Awaiting full settlement'**
  String get dashboardPendingShipmentsSubtitle;

  /// No description provided for @dashboardCompletedShipments.
  ///
  /// In en, this message translates to:
  /// **'Completed shipments'**
  String get dashboardCompletedShipments;

  /// No description provided for @dashboardCompletedShipmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recently finalized'**
  String get dashboardCompletedShipmentsSubtitle;

  /// No description provided for @dashboardRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get dashboardRecentActivity;

  /// No description provided for @dashboardRecentActivitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Latest ledger activity'**
  String get dashboardRecentActivitySubtitle;

  /// No description provided for @dashboardNone.
  ///
  /// In en, this message translates to:
  /// **'No records to show'**
  String get dashboardNone;

  /// No description provided for @dashboardNoRecentUpdates.
  ///
  /// In en, this message translates to:
  /// **'No recent activity yet'**
  String get dashboardNoRecentUpdates;

  /// No description provided for @dashboardTotalShipments.
  ///
  /// In en, this message translates to:
  /// **'Total shipments'**
  String get dashboardTotalShipments;

  /// No description provided for @dashboardTotalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total revenue'**
  String get dashboardTotalRevenue;

  /// No description provided for @dashboardAmountReceived.
  ///
  /// In en, this message translates to:
  /// **'Amount received'**
  String get dashboardAmountReceived;

  /// No description provided for @dashboardPendingShipmentsKpi.
  ///
  /// In en, this message translates to:
  /// **'Shipment receivables'**
  String get dashboardPendingShipmentsKpi;

  /// No description provided for @dashboardCashAvailable.
  ///
  /// In en, this message translates to:
  /// **'Cash available'**
  String get dashboardCashAvailable;

  /// No description provided for @dashboardLabourExpenses.
  ///
  /// In en, this message translates to:
  /// **'Labour expenses'**
  String get dashboardLabourExpenses;

  /// No description provided for @dashboardPendingLabourKpi.
  ///
  /// In en, this message translates to:
  /// **'Labour outstanding'**
  String get dashboardPendingLabourKpi;

  /// No description provided for @dashboardBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Outstanding balance {amount}'**
  String dashboardBalanceLabel(Object amount);

  /// No description provided for @dashboardCompletedValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Settlement amount'**
  String get dashboardCompletedValueLabel;

  /// No description provided for @dashboardActivityShipmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Shipment #{serial} · {marketName}'**
  String dashboardActivityShipmentTitle(Object serial, Object marketName);

  /// No description provided for @dashboardActivityPaymentReceivedCaption.
  ///
  /// In en, this message translates to:
  /// **'Payment received {amount}'**
  String dashboardActivityPaymentReceivedCaption(Object amount);

  /// No description provided for @dashboardActivityLabourTitle.
  ///
  /// In en, this message translates to:
  /// **'Labour #{serial}'**
  String dashboardActivityLabourTitle(Object serial);

  /// No description provided for @dashboardActivityLabourPaidCaption.
  ///
  /// In en, this message translates to:
  /// **'Wages paid {amount}'**
  String dashboardActivityLabourPaidCaption(Object amount);

  /// No description provided for @dashboardActivityCashTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash · {market} · #{serial}'**
  String dashboardActivityCashTitle(Object market, Object serial);

  /// No description provided for @dashboardActivityCashCaption.
  ///
  /// In en, this message translates to:
  /// **'Received {recv} · Paid {pay}'**
  String dashboardActivityCashCaption(Object recv, Object pay);

  /// No description provided for @moreTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTitle;

  /// No description provided for @moreReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports & summaries'**
  String get moreReportsTitle;

  /// No description provided for @moreReportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily / monthly totals, Excel & PDF'**
  String get moreReportsSubtitle;

  /// No description provided for @moreSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get moreSettingsTitle;

  /// No description provided for @moreSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign-in mode, backup info'**
  String get moreSettingsSubtitle;

  /// No description provided for @moreExportShipmentsExcel.
  ///
  /// In en, this message translates to:
  /// **'Export shipments (Excel)'**
  String get moreExportShipmentsExcel;

  /// No description provided for @moreExportLabourExcel.
  ///
  /// In en, this message translates to:
  /// **'Export labour (Excel)'**
  String get moreExportLabourExcel;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @reportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily / monthly summaries'**
  String get reportsSubtitle;

  /// No description provided for @reportsFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get reportsFrom;

  /// No description provided for @reportsTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get reportsTo;

  /// No description provided for @reportsGenerateSummary.
  ///
  /// In en, this message translates to:
  /// **'Generate summary'**
  String get reportsGenerateSummary;

  /// No description provided for @reportsShipmentsInRange.
  ///
  /// In en, this message translates to:
  /// **'Shipments in range'**
  String get reportsShipmentsInRange;

  /// No description provided for @reportsRevenueInRange.
  ///
  /// In en, this message translates to:
  /// **'Revenue in range'**
  String get reportsRevenueInRange;

  /// No description provided for @reportsReceivedShipmentsInRange.
  ///
  /// In en, this message translates to:
  /// **'Amount collected (shipments, in range)'**
  String get reportsReceivedShipmentsInRange;

  /// No description provided for @reportsPendingBalanceShipmentsFiltered.
  ///
  /// In en, this message translates to:
  /// **'Outstanding shipment balances (filtered)'**
  String get reportsPendingBalanceShipmentsFiltered;

  /// No description provided for @reportsLabourCostInRange.
  ///
  /// In en, this message translates to:
  /// **'Labour cost in range'**
  String get reportsLabourCostInRange;

  /// No description provided for @reportsPendingLabourFiltered.
  ///
  /// In en, this message translates to:
  /// **'Outstanding labour balances (filtered)'**
  String get reportsPendingLabourFiltered;

  /// No description provided for @reportsCashReceivedAllMarketsInRange.
  ///
  /// In en, this message translates to:
  /// **'Cash collected (all markets, in range)'**
  String get reportsCashReceivedAllMarketsInRange;

  /// No description provided for @reportsCashPaymentsAllMarketsInRange.
  ///
  /// In en, this message translates to:
  /// **'Cash paid out (all markets, in range)'**
  String get reportsCashPaymentsAllMarketsInRange;

  /// No description provided for @reportsTotalCashAvailableCurrentAllMarkets.
  ///
  /// In en, this message translates to:
  /// **'Total cash on hand (current, all markets)'**
  String get reportsTotalCashAvailableCurrentAllMarkets;

  /// No description provided for @reportsExcel.
  ///
  /// In en, this message translates to:
  /// **'Excel'**
  String get reportsExcel;

  /// No description provided for @reportsPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get reportsPdf;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsRequireEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Require email sign-in'**
  String get settingsRequireEmailTitle;

  /// No description provided for @settingsRequireEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When off, the app signs you in as a guest (Firebase anonymous) so data still backs up to the cloud.'**
  String get settingsRequireEmailSubtitle;

  /// No description provided for @settingsBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get settingsBackupTitle;

  /// No description provided for @settingsBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your records are stored in Cloud Firestore under your account. Use Reports → Excel/PDF to keep file copies on your device.'**
  String get settingsBackupSubtitle;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOut;

  /// No description provided for @settingsAccountType.
  ///
  /// In en, this message translates to:
  /// **'Account type'**
  String get settingsAccountType;

  /// No description provided for @settingsAccountTypeGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest (anonymous)'**
  String get settingsAccountTypeGuest;

  /// No description provided for @settingsAccountTypeEmail.
  ///
  /// In en, this message translates to:
  /// **'Email user'**
  String get settingsAccountTypeEmail;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navShipments.
  ///
  /// In en, this message translates to:
  /// **'Shipments'**
  String get navShipments;

  /// No description provided for @navCash.
  ///
  /// In en, this message translates to:
  /// **'Markets'**
  String get navCash;

  /// No description provided for @navLabour.
  ///
  /// In en, this message translates to:
  /// **'Labour'**
  String get navLabour;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageUrdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get settingsLanguageUrdu;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

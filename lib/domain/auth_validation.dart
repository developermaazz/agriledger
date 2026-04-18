/// Client-side validation aligned with Firebase Auth expectations.
class AuthValidation {
  static final RegExp _email = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static bool isValidEmail(String email) {
    final t = email.trim();
    return t.length <= 254 && _email.hasMatch(t);
  }

  /// Minimum rules: 8+ chars, upper, lower, digit.
  static PasswordStrength assessPassword(String password) {
    var score = 0;
    final issues = <String>[];
    if (password.length >= 8) {
      score += 1;
    } else {
      issues.add('short');
    }
    if (password.length >= 12) score += 1;
    if (RegExp(r'[A-Z]').hasMatch(password)) {
      score += 1;
    } else {
      issues.add('upper');
    }
    if (RegExp(r'[a-z]').hasMatch(password)) {
      score += 1;
    } else {
      issues.add('lower');
    }
    if (RegExp(r'\d').hasMatch(password)) {
      score += 1;
    } else {
      issues.add('digit');
    }
    if (RegExp(r'[^\w\s]').hasMatch(password)) score += 1;
    return PasswordStrength(
      score: score.clamp(0, 6),
      maxScore: 6,
      issues: issues,
    );
  }

  static bool isPasswordAcceptable(String password) {
    final p = assessPassword(password);
    return p.score >= 4 && password.length >= 8;
  }
}

class PasswordStrength {
  const PasswordStrength({
    required this.score,
    required this.maxScore,
    required this.issues,
  });

  final int score;
  final int maxScore;
  final List<String> issues;

  double get fraction => maxScore == 0 ? 0 : score / maxScore;
}

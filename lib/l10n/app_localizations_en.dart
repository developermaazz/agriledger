// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Agri Ledger';

  @override
  String get appTitleWord1 => 'Agri';

  @override
  String get appTitleWord2 => 'Ledger';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonOpen => 'Open';

  @override
  String get commonSave => 'Save';

  @override
  String get commonWorking => 'Working...';

  @override
  String get commonActions => 'Actions';

  @override
  String get commonAll => 'All';

  @override
  String get commonStatus => 'Status';

  @override
  String get commonPending => 'Pending';

  @override
  String get commonCompleted => 'Completed';

  @override
  String get commonOverpaid => 'Overpaid';

  @override
  String get commonRequired => 'Required';

  @override
  String get commonInvalid => 'Invalid';

  @override
  String get commonSaving => 'Saving...';

  @override
  String get feedbackShipmentAdded => 'Shipment saved';

  @override
  String get feedbackShipmentUpdated => 'Shipment updated';

  @override
  String get feedbackCashEntryAdded => 'Cash entry saved';

  @override
  String get feedbackCashEntryUpdated => 'Cash entry updated';

  @override
  String get feedbackLabourAdded => 'Labour record saved';

  @override
  String get feedbackLabourUpdated => 'Labour record updated';

  @override
  String get feedbackRecordDeleted => 'Deleted';

  @override
  String get cashEntryDeletedSnack => 'Cash entry deleted';

  @override
  String get authSignedIn => 'Signed in';

  @override
  String get authAccountCreated => 'Account created';

  @override
  String get authFailed => 'Authentication failed';

  @override
  String get authSubtitleRegister =>
      'Create an account to sync shipments, cash, and labour.';

  @override
  String get authSubtitleLogin =>
      'Sign in to manage fruit trading and finances.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authEmailRequired => 'Email is required';

  @override
  String get authEmailInvalid => 'Enter a valid email';

  @override
  String get authPasswordTooShort => 'Password must be at least 6 characters';

  @override
  String get authPleaseWait => 'Please wait...';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authAlreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get authNewHere => 'New here? Create an account';

  @override
  String get authFullNameLabel => 'Full name';

  @override
  String get authPhoneLabel => 'Phone';

  @override
  String get authPhoneHint => 'Include country code (e.g. +92…)';

  @override
  String get authConfirmPasswordLabel => 'Confirm password';

  @override
  String get authPasswordMismatch => 'Passwords do not match';

  @override
  String get authPasswordRequirements =>
      'Use at least 8 characters with upper, lower, and a number.';

  @override
  String get authLoginWithEmail => 'Email';

  @override
  String get authLoginWithPhone => 'Phone';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authRememberMe => 'Remember me';

  @override
  String get authVerifyTitle => 'Verify your email';

  @override
  String get authVerifySubtitle =>
      'We sent a link to your inbox. Use Resend if you need a new one.';

  @override
  String get authResendVerificationEmail => 'Resend verification email';

  @override
  String get authCheckedVerification => 'I\'ve verified — continue';

  @override
  String get authOtpSectionTitle => 'Email code';

  @override
  String get authOtpHint => '6-digit code';

  @override
  String get authRequestOtp => 'Send code';

  @override
  String get authVerifyOtp => 'Verify code';

  @override
  String get authForgotTitle => 'Reset password';

  @override
  String get authForgotSubtitle =>
      'Enter your email and we\'ll send a reset link.';

  @override
  String get authSendResetLink => 'Send reset link';

  @override
  String get authBackToLogin => 'Back to sign in';

  @override
  String get authResetPasswordTitle => 'Choose a new password';

  @override
  String get authNewPasswordLabel => 'New password';

  @override
  String get authResetSubmit => 'Update password';

  @override
  String get authSignupTitle => 'Create your account';

  @override
  String get authPasswordStrengthWeak => 'Weak';

  @override
  String get authPasswordStrengthFair => 'Fair';

  @override
  String get authPasswordStrengthGood => 'Good';

  @override
  String get authPasswordStrengthStrong => 'Strong';

  @override
  String get authErrorUserDisabled => 'This account has been disabled.';

  @override
  String get authErrorInvalidCredentials => 'Invalid email or password.';

  @override
  String get authErrorEmailInUse =>
      'This email is already registered. Sign in instead.';

  @override
  String get authAccountAlreadyExistsTitle => 'Account already exists';

  @override
  String get authAccountAlreadyExistsMessage =>
      'This email is already registered—often because a previous sign-up finished but the email was not verified yet.\n\nSign in with your password. You can send a new verification email from the next screen. If you forgot your password, use Forgot password.';

  @override
  String get authGoToSignInFromSignup => 'Go to sign in';

  @override
  String get authPrefilledEmailHint =>
      'Enter your password to continue. You can resend verification after signing in.';

  @override
  String get authErrorWeakPassword => 'Password is too weak.';

  @override
  String get authErrorTooManyRequests => 'Too many attempts. Try again later.';

  @override
  String get authErrorNetwork => 'Network error. Check your connection.';

  @override
  String get authErrorAlreadyExists =>
      'That email or phone is already registered.';

  @override
  String get authErrorUnauthenticated => 'Please sign in again.';

  @override
  String get authOtpSent => 'Verification code sent.';

  @override
  String get authOtpExpired => 'That code expired. Request a new one.';

  @override
  String get authVerifyEmailRequired => 'Verify your email to continue.';

  @override
  String get authEmailVerificationCompleted =>
      'Email verified. Sign in to continue.';

  @override
  String get authVerificationStillPending =>
      'We still don\'t see a verified email. Check your inbox or tap Resend.';

  @override
  String get authEmailVerifiedFromLinkSnack => 'Email address verified.';

  @override
  String get authProfileSaved => 'Profile saved.';

  @override
  String get authProfileIncomplete => 'Complete your profile to continue.';

  @override
  String get authCompleteProfileTitle => 'Complete profile';

  @override
  String get authCompleteProfileSubtitle =>
      'Add your name and phone to finish setup.';

  @override
  String get authUnverifiedBlocked => 'Verify your email before signing in.';

  @override
  String get authTabEmailLink => 'Email link';

  @override
  String get authTabOtpCode => 'OTP';

  @override
  String get authPasswordResetDone => 'Password updated. You can sign in now.';

  @override
  String get authResetEmailSent =>
      'If an account exists, we sent a reset link.';

  @override
  String get authVerificationEmailSent =>
      'Verification email sent. Check your inbox.';

  @override
  String get creditsIntro => 'Crafted with care';

  @override
  String get creditsAttributionPrefix => 'Designed & developed by ';

  @override
  String get creditsAuthorName => 'Muhammad Maaz Ali';

  @override
  String get creditsAuthorLinkA11yHint => 'Opens the developer website';

  @override
  String get creditsLinkCouldNotOpen =>
      'Could not open the link. Try again later.';

  @override
  String get shipmentsTitle => 'Shipments';

  @override
  String get shipmentsNewTitle => 'New shipment';

  @override
  String get shipmentsEditTitle => 'Edit shipment';

  @override
  String get shipmentsDetailsTitle => 'Shipment details';

  @override
  String get shipmentsNoShipmentsTitle => 'No shipments';

  @override
  String get shipmentsNoShipmentsSubtitle => 'Add a shipment to get started.';

  @override
  String get shipmentsSearchHint => 'Buyer, market, remarks';

  @override
  String get shipmentsUnableToLoad => 'Unable to load shipments';

  @override
  String get shipmentsUnableToLoadMarkets => 'Unable to load markets';

  @override
  String get shipmentsStatusFilterAll => 'All';

  @override
  String get shipmentsMarketFilterAll => 'All markets';

  @override
  String get shipmentsMarketLabel => 'Market';

  @override
  String get shipmentsDateLabel => 'Date';

  @override
  String get shipmentsBuyerLabel => 'Buyer';

  @override
  String get shipmentsQuantityLabel => 'Quantity (boxes/cartons)';

  @override
  String get shipmentsTotalAmountLabel => 'Total amount';

  @override
  String get shipmentsAmountReceivedLabel => 'Amount received';

  @override
  String get shipmentsRemarksLabel => 'Remarks';

  @override
  String get shipmentsBalanceAuto => 'Outstanding balance (calculated)';

  @override
  String get shipmentsAddMarketFirst =>
      'Add a market first (Markets tab → add market).';

  @override
  String get shipmentsDeleteConfirmTitle => 'Delete shipment?';

  @override
  String get shipmentsDeleteConfirmBody => 'This cannot be undone.';

  @override
  String get shipmentsDeleted => 'Shipment deleted';

  @override
  String get shipmentsCompletedReadOnly => 'Completed (read-only)';

  @override
  String get labourTitle => 'Labour';

  @override
  String get labourNewTitle => 'New labour';

  @override
  String get labourEditTitle => 'Edit labour';

  @override
  String get labourDetailsTitle => 'Labour details';

  @override
  String get labourNoRecordsTitle => 'No labour records';

  @override
  String get labourNoRecordsSubtitle => 'Track labour cost and payments.';

  @override
  String get labourSearchHint => 'Search remarks';

  @override
  String get labourUnableToLoad => 'Unable to load labour records';

  @override
  String get labourStartDateLabel => 'Start date';

  @override
  String get labourEndDateLabel => 'End date';

  @override
  String get labourTotalCostLabel => 'Total labour cost';

  @override
  String get labourReceivedPaymentLabel => 'Payment received';

  @override
  String get labourRemarksLabel => 'Remarks';

  @override
  String get labourRemainingAuto => 'Remaining balance (calculated)';

  @override
  String get labourDeleteConfirmTitle => 'Delete labour record?';

  @override
  String get labourDeleteConfirmBody => 'This cannot be undone.';

  @override
  String get labourDeleted => 'Labour record deleted';

  @override
  String get labourCompletedReadOnly => 'Completed (read-only)';

  @override
  String get marketCashTitle => 'Market cash';

  @override
  String get marketNewTitle => 'New market';

  @override
  String get marketNewHint => 'Name (e.g. Lahore)';

  @override
  String marketAdded(Object name) {
    return 'Market \"$name\" added';
  }

  @override
  String marketDeleted(Object name) {
    return 'Market \"$name\" deleted';
  }

  @override
  String get marketsEmptyTitle => 'No markets yet';

  @override
  String get marketsEmptySubtitle =>
      'Add Lahore or other markets to track cash.';

  @override
  String get marketsDeleteConfirmTitle => 'Delete market?';

  @override
  String marketsDeleteConfirmBody(Object name) {
    return 'If this market is used in any shipment, it cannot be deleted.\n\n\"$name\" and its cash entries will be deleted.';
  }

  @override
  String get marketsTapToOpenCashLedger => 'Tap to open cash ledger';

  @override
  String get cashExportExcel => 'Export Excel';

  @override
  String get cashEntryButton => 'Add entry';

  @override
  String get cashNoEntriesTitle => 'No cash entries';

  @override
  String get cashNoEntriesSubtitle =>
      'Add amount received and payments for this market.';

  @override
  String cashLedgerRowSummary(Object cash, Object pay, Object bal) {
    return 'Available $cash · Payments $pay · Balance $bal';
  }

  @override
  String get cashDeleteEntryTitle => 'Delete entry?';

  @override
  String get cashDeleteEntryBody => 'Running totals will be recalculated.';

  @override
  String get cashDateLabel => 'Date';

  @override
  String get cashAmountReceivedLabel => 'Amount received';

  @override
  String get cashPaymentsLabel => 'Payments';

  @override
  String get cashPreviousCashLabel => 'Previous cash';

  @override
  String get cashCashAvailableLabel => 'Cash available';

  @override
  String get cashBalanceLabel => 'Balance';

  @override
  String get cashRemarksLabel => 'Remarks';

  @override
  String get errorsSomethingWentWrong => 'Something went wrong';

  @override
  String get errorsFirestoreBlocked =>
      'Firestore is blocking access. Deploy the provided `firestore.rules` in Firebase Console (or put Firestore in test mode for development).';

  @override
  String shipmentsListSubtitle(Object buyer, Object bal) {
    return '$buyer · Outstanding $bal';
  }

  @override
  String shipmentsListTileTitle(Object serial, Object market) {
    return 'Shipment $serial · $market';
  }

  @override
  String shipmentDetailAppBarTitle(Object serial) {
    return 'Shipment $serial';
  }

  @override
  String labourListTitle(Object serial, Object amount) {
    return 'Labour #$serial · $amount outstanding';
  }

  @override
  String labourListDateRange(Object dateStart, Object dateEnd) {
    return '$dateStart — $dateEnd';
  }

  @override
  String labourDetailAppBarTitle(Object serial) {
    return 'Labour $serial';
  }

  @override
  String cashLedgerListTitle(Object serial, Object date) {
    return 'Entry $serial · $date';
  }

  @override
  String cashEntryDetailsAppBarTitle(Object marketName, Object serial) {
    return '$marketName · Entry $serial';
  }

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get welcomeGuestName => 'there';

  @override
  String dashboardWelcomeLine(Object greeting, Object name) {
    return '$greeting, $name!';
  }

  @override
  String get dashboardWelcomeSubtitle => 'Here\'s your trading snapshot.';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardUnableToLoad => 'Unable to load dashboard data';

  @override
  String get dashboardUnableToLoadCash => 'Unable to load cash balances';

  @override
  String get dashboardOverview => 'Overview';

  @override
  String get dashboardOverviewSubtitle => 'Performance at a glance';

  @override
  String get dashboardPendingShipments => 'Pending shipments';

  @override
  String get dashboardPendingShipmentsSubtitle => 'Awaiting full settlement';

  @override
  String get dashboardCompletedShipments => 'Completed shipments';

  @override
  String get dashboardCompletedShipmentsSubtitle => 'Recently finalized';

  @override
  String get dashboardRecentActivity => 'Recent activity';

  @override
  String get dashboardRecentActivitySubtitle => 'Latest ledger activity';

  @override
  String get dashboardNone => 'No records to show';

  @override
  String get dashboardNoRecentUpdates => 'No recent activity yet';

  @override
  String get dashboardTotalShipments => 'Total shipments';

  @override
  String get dashboardTotalRevenue => 'Total revenue';

  @override
  String get dashboardAmountReceived => 'Amount received';

  @override
  String get dashboardPendingShipmentsKpi => 'Shipment receivables';

  @override
  String get dashboardCashAvailable => 'Cash available';

  @override
  String get dashboardLabourExpenses => 'Labour expenses';

  @override
  String get dashboardPendingLabourKpi => 'Labour outstanding';

  @override
  String dashboardBalanceLabel(Object amount) {
    return 'Outstanding balance $amount';
  }

  @override
  String get dashboardCompletedValueLabel => 'Settlement amount';

  @override
  String dashboardActivityShipmentTitle(Object serial, Object marketName) {
    return 'Shipment #$serial · $marketName';
  }

  @override
  String dashboardActivityPaymentReceivedCaption(Object amount) {
    return 'Payment received $amount';
  }

  @override
  String dashboardActivityLabourTitle(Object serial) {
    return 'Labour #$serial';
  }

  @override
  String dashboardActivityLabourPaidCaption(Object amount) {
    return 'Wages paid $amount';
  }

  @override
  String dashboardActivityCashTitle(Object market, Object serial) {
    return 'Cash · $market · #$serial';
  }

  @override
  String dashboardActivityCashCaption(Object recv, Object pay) {
    return 'Received $recv · Paid $pay';
  }

  @override
  String get moreTitle => 'More';

  @override
  String get moreReportsTitle => 'Reports & summaries';

  @override
  String get moreReportsSubtitle => 'Daily / monthly totals, Excel & PDF';

  @override
  String get moreSettingsTitle => 'Settings';

  @override
  String get moreSettingsSubtitle => 'Sign-in mode, backup info';

  @override
  String get moreExportShipmentsExcel => 'Export shipments (Excel)';

  @override
  String get moreExportLabourExcel => 'Export labour (Excel)';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get reportsSubtitle => 'Daily / monthly summaries';

  @override
  String get reportsFrom => 'From';

  @override
  String get reportsTo => 'To';

  @override
  String get reportsGenerateSummary => 'Generate summary';

  @override
  String get reportsShipmentsInRange => 'Shipments in range';

  @override
  String get reportsRevenueInRange => 'Revenue in range';

  @override
  String get reportsReceivedShipmentsInRange =>
      'Amount collected (shipments, in range)';

  @override
  String get reportsPendingBalanceShipmentsFiltered =>
      'Outstanding shipment balances (filtered)';

  @override
  String get reportsLabourCostInRange => 'Labour cost in range';

  @override
  String get reportsPendingLabourFiltered =>
      'Outstanding labour balances (filtered)';

  @override
  String get reportsCashReceivedAllMarketsInRange =>
      'Cash collected (all markets, in range)';

  @override
  String get reportsCashPaymentsAllMarketsInRange =>
      'Cash paid out (all markets, in range)';

  @override
  String get reportsTotalCashAvailableCurrentAllMarkets =>
      'Total cash on hand (current, all markets)';

  @override
  String get reportsExcel => 'Excel';

  @override
  String get reportsPdf => 'PDF';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsRequireEmailTitle => 'Require email sign-in';

  @override
  String get settingsRequireEmailSubtitle =>
      'When off, the app signs you in as a guest (Firebase anonymous) so data still backs up to the cloud.';

  @override
  String get settingsBackupTitle => 'Backup';

  @override
  String get settingsBackupSubtitle =>
      'Your records are stored in Cloud Firestore under your account. Use Reports → Excel/PDF to keep file copies on your device.';

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String get settingsDeleteAccountTitle => 'Delete account';

  @override
  String get settingsDeleteAccountSubtitle =>
      'Permanently remove your data and sign-in.';

  @override
  String get settingsDeleteAccountConfirmTitle => 'Delete your account?';

  @override
  String get settingsDeleteAccountConfirmBody =>
      'This removes your shipments, markets, labour records, and profile from the cloud. This cannot be undone.';

  @override
  String get settingsDeleteAccountPasswordLabel => 'Current password';

  @override
  String get settingsDeleteAccountConfirmButton => 'Delete forever';

  @override
  String get settingsDeleteAccountSuccess => 'Your account was deleted.';

  @override
  String get settingsDeleteAccountWrongPassword => 'Incorrect password.';

  @override
  String get authErrorRequiresRecentLogin =>
      'Please sign out, sign in again, then try deleting your account.';

  @override
  String get settingsAccountType => 'Account type';

  @override
  String get settingsAccountTypeGuest => 'Guest (anonymous)';

  @override
  String get settingsAccountTypeEmail => 'Email user';

  @override
  String get navHome => 'Home';

  @override
  String get navShipments => 'Shipments';

  @override
  String get navCash => 'Markets';

  @override
  String get navLabour => 'Labour';

  @override
  String get navMore => 'More';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageUrdu => 'Urdu';
}

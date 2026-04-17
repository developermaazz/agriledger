// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Fruit Ledger';

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
  String get shipmentsBalanceAuto => 'Balance (auto)';

  @override
  String get shipmentsAddMarketFirst =>
      'Add a market first (Cash tab → add market).';

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
  String get labourReceivedPaymentLabel => 'Received payment';

  @override
  String get labourRemarksLabel => 'Remarks';

  @override
  String get labourRemainingAuto => 'Remaining (auto)';

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
  String get cashEntryButton => 'Entry';

  @override
  String get cashNoEntriesTitle => 'No cash entries';

  @override
  String get cashNoEntriesSubtitle =>
      'Add amount received and payments for this market.';

  @override
  String cashLedgerRowSummary(Object cash, Object pay, Object bal) {
    return 'Cash $cash · Pay $pay · Bal $bal';
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
    return '$buyer · Bal $bal';
  }

  @override
  String labourListTitle(Object serial, Object amount) {
    return '#$serial · $amount due';
  }

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardUnableToLoad => 'Unable to load dashboard data';

  @override
  String get dashboardOverview => 'Overview';

  @override
  String get dashboardPendingShipments => 'Pending shipments';

  @override
  String get dashboardCompletedShipments => 'Completed shipments';

  @override
  String get dashboardRecentActivity => 'Recent activity';

  @override
  String get dashboardNone => 'None';

  @override
  String get dashboardNoRecentUpdates => 'No recent updates';

  @override
  String get dashboardTotalShipments => 'Total shipments';

  @override
  String get dashboardTotalRevenue => 'Total revenue';

  @override
  String get dashboardAmountReceived => 'Amount received';

  @override
  String get dashboardPendingShipmentsKpi => 'Pending (shipments)';

  @override
  String get dashboardCashAvailable => 'Cash available';

  @override
  String get dashboardLabourExpenses => 'Labour expenses';

  @override
  String get dashboardPendingLabourKpi => 'Pending (labour)';

  @override
  String dashboardBalanceLabel(Object amount) {
    return 'Balance $amount';
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
  String get reportsReceivedShipmentsInRange => 'Received (shipments) in range';

  @override
  String get reportsPendingBalanceShipmentsFiltered =>
      'Pending balance (shipments, filtered)';

  @override
  String get reportsLabourCostInRange => 'Labour cost in range';

  @override
  String get reportsPendingLabourFiltered => 'Pending labour (filtered)';

  @override
  String get reportsCashReceivedAllMarketsInRange =>
      'Cash received (all markets, in range)';

  @override
  String get reportsCashPaymentsAllMarketsInRange =>
      'Cash payments (all markets, in range)';

  @override
  String get reportsTotalCashAvailableCurrentAllMarkets =>
      'Total cash available (current, all markets)';

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
  String get navCash => 'Cash';

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

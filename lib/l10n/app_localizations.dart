import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Fruit Ledger'**
  String get appTitle;

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
  /// **'Balance (auto)'**
  String get shipmentsBalanceAuto;

  /// No description provided for @shipmentsAddMarketFirst.
  ///
  /// In en, this message translates to:
  /// **'Add a market first (Cash tab → add market).'**
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
  /// **'Received payment'**
  String get labourReceivedPaymentLabel;

  /// No description provided for @labourRemarksLabel.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get labourRemarksLabel;

  /// No description provided for @labourRemainingAuto.
  ///
  /// In en, this message translates to:
  /// **'Remaining (auto)'**
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
  /// **'Entry'**
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
  /// **'Cash {cash} · Pay {pay} · Bal {bal}'**
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
  /// **'{buyer} · Bal {bal}'**
  String shipmentsListSubtitle(Object buyer, Object bal);

  /// No description provided for @labourListTitle.
  ///
  /// In en, this message translates to:
  /// **'#{serial} · {amount} due'**
  String labourListTitle(Object serial, Object amount);

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

  /// No description provided for @dashboardOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get dashboardOverview;

  /// No description provided for @dashboardPendingShipments.
  ///
  /// In en, this message translates to:
  /// **'Pending shipments'**
  String get dashboardPendingShipments;

  /// No description provided for @dashboardCompletedShipments.
  ///
  /// In en, this message translates to:
  /// **'Completed shipments'**
  String get dashboardCompletedShipments;

  /// No description provided for @dashboardRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get dashboardRecentActivity;

  /// No description provided for @dashboardNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get dashboardNone;

  /// No description provided for @dashboardNoRecentUpdates.
  ///
  /// In en, this message translates to:
  /// **'No recent updates'**
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
  /// **'Pending (shipments)'**
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
  /// **'Pending (labour)'**
  String get dashboardPendingLabourKpi;

  /// No description provided for @dashboardBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance {amount}'**
  String dashboardBalanceLabel(Object amount);

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
  /// **'Received (shipments) in range'**
  String get reportsReceivedShipmentsInRange;

  /// No description provided for @reportsPendingBalanceShipmentsFiltered.
  ///
  /// In en, this message translates to:
  /// **'Pending balance (shipments, filtered)'**
  String get reportsPendingBalanceShipmentsFiltered;

  /// No description provided for @reportsLabourCostInRange.
  ///
  /// In en, this message translates to:
  /// **'Labour cost in range'**
  String get reportsLabourCostInRange;

  /// No description provided for @reportsPendingLabourFiltered.
  ///
  /// In en, this message translates to:
  /// **'Pending labour (filtered)'**
  String get reportsPendingLabourFiltered;

  /// No description provided for @reportsCashReceivedAllMarketsInRange.
  ///
  /// In en, this message translates to:
  /// **'Cash received (all markets, in range)'**
  String get reportsCashReceivedAllMarketsInRange;

  /// No description provided for @reportsCashPaymentsAllMarketsInRange.
  ///
  /// In en, this message translates to:
  /// **'Cash payments (all markets, in range)'**
  String get reportsCashPaymentsAllMarketsInRange;

  /// No description provided for @reportsTotalCashAvailableCurrentAllMarkets.
  ///
  /// In en, this message translates to:
  /// **'Total cash available (current, all markets)'**
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
  /// **'Cash'**
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
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

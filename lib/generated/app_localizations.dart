import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('id'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'ConvertEase'**
  String get appTitle;

  /// Text for selecting a category
  ///
  /// In en, this message translates to:
  /// **'Select a conversion category'**
  String get selectCategory;

  /// Converter text
  ///
  /// In en, this message translates to:
  /// **'Converter'**
  String get converter;

  /// Loading text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Enter color value text
  ///
  /// In en, this message translates to:
  /// **'Enter color value'**
  String get enterColorValue;

  /// Enter value to convert text
  ///
  /// In en, this message translates to:
  /// **'Enter value to convert'**
  String get enterValueToConvert;

  /// Please enter a value text
  ///
  /// In en, this message translates to:
  /// **'Please enter a value'**
  String get pleaseEnterValue;

  /// Select units text
  ///
  /// In en, this message translates to:
  /// **'Select Units'**
  String get selectUnits;

  /// From text
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// To text
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// Convert button text
  ///
  /// In en, this message translates to:
  /// **'Convert'**
  String get convert;

  /// Result text
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// Waiting for input text
  ///
  /// In en, this message translates to:
  /// **'Waiting for input...'**
  String get waitingForInput;

  /// Result copied message
  ///
  /// In en, this message translates to:
  /// **'Result copied to clipboard'**
  String get resultCopied;

  /// Unit text
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// Currency text
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// Units text
  ///
  /// In en, this message translates to:
  /// **'units'**
  String get units;

  /// Show more text
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get showMore;

  /// Show less text
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get showLess;

  /// Hiding categories text
  ///
  /// In en, this message translates to:
  /// **'Hiding {count} categories'**
  String hiding(int count);

  /// More categories text
  ///
  /// In en, this message translates to:
  /// **'+{count} more'**
  String moreCategories(int count);

  /// Settings text
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language text
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Select language text
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Chinese language name
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get chinese;

  /// Traditional Chinese language name
  ///
  /// In en, this message translates to:
  /// **'繁體中文'**
  String get traditionalChinese;

  /// Indonesian language name
  ///
  /// In en, this message translates to:
  /// **'Bahasa Indonesia'**
  String get indonesian;

  /// Language changed message
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// Theme text
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Dark mode text
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Light mode text
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// About text
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// App name text
  ///
  /// In en, this message translates to:
  /// **'App Name'**
  String get appName;

  /// Version text
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Build number text
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get buildNumber;

  /// Developer text
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// App description text
  ///
  /// In en, this message translates to:
  /// **'A powerful and beautiful unit conversion app\nsupporting multiple categories and languages.'**
  String get appDescription;

  /// Theme switching coming soon message
  ///
  /// In en, this message translates to:
  /// **'Theme switching coming soon!'**
  String get themeSwitchingComingSoon;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// History tab label
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Favorites tab label
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Conversion history title
  ///
  /// In en, this message translates to:
  /// **'Conversion History'**
  String get conversionHistory;

  /// Clear all button
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// Clear all history dialog title
  ///
  /// In en, this message translates to:
  /// **'Clear All History'**
  String get clearAllHistory;

  /// Clear all history confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all conversion history?'**
  String get clearAllHistoryConfirm;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No history message title
  ///
  /// In en, this message translates to:
  /// **'No Conversion History'**
  String get noConversionHistory;

  /// History placeholder text
  ///
  /// In en, this message translates to:
  /// **'Your conversion history will appear here'**
  String get historyWillAppearHere;

  /// Category label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Time label
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Delete button tooltip
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Favorites coming soon message
  ///
  /// In en, this message translates to:
  /// **'Favorites feature coming soon!'**
  String get favoritesComingSoon;

  /// Currency loading error
  ///
  /// In en, this message translates to:
  /// **'Failed to load currencies'**
  String get failedToLoadCurrencies;

  /// History loading error
  ///
  /// In en, this message translates to:
  /// **'Failed to load history'**
  String get failedToLoadHistory;

  /// Exchange failure error
  ///
  /// In en, this message translates to:
  /// **'Exchange failed'**
  String get exchangeFailed;

  /// Invalid result error
  ///
  /// In en, this message translates to:
  /// **'Invalid result format'**
  String get invalidResult;

  /// No result message
  ///
  /// In en, this message translates to:
  /// **'No result'**
  String get noResult;

  /// Generic error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Conversion not implemented message
  ///
  /// In en, this message translates to:
  /// **'Conversion not implemented yet'**
  String get conversionNotImplemented;

  /// Invalid color format error
  ///
  /// In en, this message translates to:
  /// **'Invalid color format'**
  String get invalidColorFormat;

  /// Invalid hex format error
  ///
  /// In en, this message translates to:
  /// **'Invalid hex format'**
  String get invalidHexFormat;

  /// Invalid RGB format error
  ///
  /// In en, this message translates to:
  /// **'Invalid RGB format'**
  String get invalidRgbFormat;

  /// Recent rate update message
  ///
  /// In en, this message translates to:
  /// **'Rate updated recently'**
  String get rateUpdatedRecently;

  /// Just now rate update
  ///
  /// In en, this message translates to:
  /// **'Rate updated just now'**
  String get rateUpdatedJustNow;

  /// Minutes ago rate update
  ///
  /// In en, this message translates to:
  /// **'Rate updated {minutes} minute{plural} ago'**
  String rateUpdatedMinutesAgo(int minutes, String plural);

  /// Hours ago rate update
  ///
  /// In en, this message translates to:
  /// **'Rate updated {hours} hour{plural} ago'**
  String rateUpdatedHoursAgo(int hours, String plural);

  /// Days ago rate update
  ///
  /// In en, this message translates to:
  /// **'Rate updated {days} day{plural} ago'**
  String rateUpdatedDaysAgo(int days, String plural);

  /// Rate updated at specific time
  ///
  /// In en, this message translates to:
  /// **'Rate updated at: {time}'**
  String rateUpdatedAt(String time);

  /// Length category name
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get categoryLength;

  /// Area category name
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get categoryArea;

  /// Volume category name
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get categoryVolume;

  /// Weight category name
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get categoryWeight;

  /// Temperature category name
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get categoryTemperature;

  /// Storage category name
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get categoryStorage;

  /// Speed category name
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get categorySpeed;

  /// Color category name
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get categoryColor;

  /// Energy category name
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get categoryEnergy;

  /// Pressure category name
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get categoryPressure;

  /// Angle category name
  ///
  /// In en, this message translates to:
  /// **'Angle'**
  String get categoryAngle;

  /// Message shown when history is empty
  ///
  /// In en, this message translates to:
  /// **'No conversion history yet'**
  String get conversionHistoryEmpty;

  /// Subtitle for empty history
  ///
  /// In en, this message translates to:
  /// **'Start converting to see your history here'**
  String get startConverting;

  /// Delete item confirmation title
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get deleteItem;

  /// Delete item confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get deleteItemConfirm;

  /// App subtitle description
  ///
  /// In en, this message translates to:
  /// **'A Powerful Unit Converter'**
  String get appSubtitle;

  /// Dark mode setting title
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkModeTitle;

  /// Dark mode setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Enable eye-friendly dark theme'**
  String get darkModeSubtitle;

  /// Accent color setting title
  ///
  /// In en, this message translates to:
  /// **'Accent Color'**
  String get accentColor;

  /// Color picker title
  ///
  /// In en, this message translates to:
  /// **'Color Picker'**
  String get colorPicker;

  /// Select color button text
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get selectColor;

  /// Choose from color palette text
  ///
  /// In en, this message translates to:
  /// **'Choose from Palette'**
  String get chooseFromPalette;

  /// Color selected confirmation message
  ///
  /// In en, this message translates to:
  /// **'Color selected'**
  String get colorSelected;

  /// Pick color button text
  ///
  /// In en, this message translates to:
  /// **'Pick Color'**
  String get pickColor;

  /// Use selected color button text
  ///
  /// In en, this message translates to:
  /// **'Use Selected Color'**
  String get useSelectedColor;
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
      <String>['en', 'id', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

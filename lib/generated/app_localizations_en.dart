// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ConvertEase';

  @override
  String get selectCategory => 'Select a conversion category';

  @override
  String get converter => 'Converter';

  @override
  String get loading => 'Loading...';

  @override
  String get enterColorValue => 'Enter color value';

  @override
  String get enterValueToConvert => 'Enter value to convert';

  @override
  String get pleaseEnterValue => 'Please enter a value';

  @override
  String get selectUnits => 'Select Units';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get convert => 'Convert';

  @override
  String get result => 'Result';

  @override
  String get waitingForInput => 'Waiting for input...';

  @override
  String get resultCopied => 'Result copied to clipboard';

  @override
  String get unit => 'Unit';

  @override
  String get currency => 'Currency';

  @override
  String get units => 'units';

  @override
  String get showMore => 'Show More';

  @override
  String get showLess => 'Show Less';

  @override
  String hiding(int count) {
    return 'Hiding $count categories';
  }

  @override
  String moreCategories(int count) {
    return '+$count more';
  }

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get chinese => '简体中文';

  @override
  String get traditionalChinese => '繁體中文';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get languageChanged => 'Language changed successfully';

  @override
  String get theme => 'Theme';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get about => 'About';

  @override
  String get appName => 'App Name';

  @override
  String get version => 'Version';

  @override
  String get buildNumber => 'Build Number';

  @override
  String get developer => 'Developer';

  @override
  String get appDescription =>
      'A powerful and beautiful unit conversion app\nsupporting multiple categories and languages.';

  @override
  String get themeSwitchingComingSoon => 'Theme switching coming soon!';

  @override
  String get home => 'Home';

  @override
  String get history => 'History';

  @override
  String get favorites => 'Favorites';

  @override
  String get conversionHistory => 'Conversion History';

  @override
  String get clearAll => 'Clear All';

  @override
  String get clearAllHistory => 'Clear All History';

  @override
  String get clearAllHistoryConfirm =>
      'Are you sure you want to delete all conversion history?';

  @override
  String get cancel => 'Cancel';

  @override
  String get noConversionHistory => 'No Conversion History';

  @override
  String get historyWillAppearHere =>
      'Your conversion history will appear here';

  @override
  String get category => 'Category';

  @override
  String get time => 'Time';

  @override
  String get delete => 'Delete';

  @override
  String get favoritesComingSoon => 'Favorites feature coming soon!';

  @override
  String get failedToLoadCurrencies => 'Failed to load currencies';

  @override
  String get failedToLoadHistory => 'Failed to load history';

  @override
  String get exchangeFailed => 'Exchange failed';

  @override
  String get invalidResult => 'Invalid result format';

  @override
  String get noResult => 'No result';

  @override
  String get error => 'Error';

  @override
  String get conversionNotImplemented => 'Conversion not implemented yet';

  @override
  String get invalidColorFormat => 'Invalid color format';

  @override
  String get invalidHexFormat => 'Invalid hex format';

  @override
  String get invalidRgbFormat => 'Invalid RGB format';

  @override
  String get rateUpdatedRecently => 'Rate updated recently';

  @override
  String get rateUpdatedJustNow => 'Rate updated just now';

  @override
  String rateUpdatedMinutesAgo(int minutes, String plural) {
    return 'Rate updated $minutes minute$plural ago';
  }

  @override
  String rateUpdatedHoursAgo(int hours, String plural) {
    return 'Rate updated $hours hour$plural ago';
  }

  @override
  String rateUpdatedDaysAgo(int days, String plural) {
    return 'Rate updated $days day$plural ago';
  }

  @override
  String rateUpdatedAt(String time) {
    return 'Rate updated at: $time';
  }

  @override
  String get categoryLength => 'Length';

  @override
  String get categoryArea => 'Area';

  @override
  String get categoryVolume => 'Volume';

  @override
  String get categoryWeight => 'Weight';

  @override
  String get categoryTemperature => 'Temperature';

  @override
  String get categoryStorage => 'Storage';

  @override
  String get categorySpeed => 'Speed';

  @override
  String get categoryColor => 'Color';

  @override
  String get categoryEnergy => 'Energy';

  @override
  String get categoryPressure => 'Pressure';

  @override
  String get categoryAngle => 'Angle';

  @override
  String get conversionHistoryEmpty => 'No conversion history yet';

  @override
  String get startConverting => 'Start converting to see your history here';

  @override
  String get deleteItem => 'Delete Item';

  @override
  String get deleteItemConfirm => 'Are you sure you want to delete this item?';

  @override
  String get appSubtitle => 'A Powerful Unit Converter';

  @override
  String get darkModeTitle => 'Dark Mode';

  @override
  String get darkModeSubtitle => 'Enable eye-friendly dark theme';

  @override
  String get accentColor => 'Accent Color';

  @override
  String get colorPicker => 'Color Picker';

  @override
  String get selectColor => 'Select Color';

  @override
  String get chooseFromPalette => 'Choose from Palette';

  @override
  String get colorSelected => 'Color selected';

  @override
  String get pickColor => 'Pick Color';

  @override
  String get useSelectedColor => 'Use Selected Color';
}

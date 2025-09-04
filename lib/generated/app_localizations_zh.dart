// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '转换大师';

  @override
  String get selectCategory => '选择转换类别';

  @override
  String get converter => '转换器';

  @override
  String get loading => '正在加载...';

  @override
  String get enterColorValue => '输入颜色值';

  @override
  String get enterValueToConvert => '输入要转换的值';

  @override
  String get pleaseEnterValue => '请输入数值';

  @override
  String get selectUnits => '选择单位';

  @override
  String get from => '从';

  @override
  String get to => '到';

  @override
  String get convert => '转换';

  @override
  String get result => '结果';

  @override
  String get waitingForInput => '等待输入...';

  @override
  String get resultCopied => '结果已复制到剪贴板';

  @override
  String get unit => '单位';

  @override
  String get currency => '货币';

  @override
  String get units => '个单位';

  @override
  String get showMore => '查看更多';

  @override
  String get showLess => '收起';

  @override
  String hiding(int count) {
    return '隐藏 $count 个类别';
  }

  @override
  String moreCategories(int count) {
    return '还有 $count 个';
  }

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get english => 'English';

  @override
  String get chinese => '简体中文';

  @override
  String get traditionalChinese => '繁體中文';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get languageChanged => '语言切换成功';

  @override
  String get theme => '主题';

  @override
  String get darkMode => '深色模式';

  @override
  String get lightMode => '浅色模式';

  @override
  String get about => '关于';

  @override
  String get appName => '应用名称';

  @override
  String get version => '版本';

  @override
  String get buildNumber => '构建号';

  @override
  String get developer => '开发者';

  @override
  String get appDescription => '一个功能强大且美观的单位转换应用\n支持多种类别和语言。';

  @override
  String get themeSwitchingComingSoon => '主题切换功能即将推出！';

  @override
  String get home => '首页';

  @override
  String get history => '历史记录';

  @override
  String get favorites => '收藏夹';

  @override
  String get conversionHistory => '转换历史';

  @override
  String get clearAll => '全部清除';

  @override
  String get clearAllHistory => '清除所有历史记录';

  @override
  String get clearAllHistoryConfirm => '您确定要删除所有转换历史记录吗？';

  @override
  String get cancel => '取消';

  @override
  String get noConversionHistory => '暂无转换历史记录';

  @override
  String get historyWillAppearHere => '您的转换历史记录将显示在这里';

  @override
  String get category => '类别';

  @override
  String get time => '时间';

  @override
  String get delete => '删除';

  @override
  String get favoritesComingSoon => '收藏夹功能即将推出！';

  @override
  String get failedToLoadCurrencies => '无法加载货币';

  @override
  String get failedToLoadHistory => '无法加载历史记录';

  @override
  String get exchangeFailed => '汇率转换失败';

  @override
  String get invalidResult => '无效的结果格式';

  @override
  String get noResult => '无结果';

  @override
  String get error => '错误';

  @override
  String get conversionNotImplemented => '转换功能尚未实现';

  @override
  String get invalidColorFormat => '无效的颜色格式';

  @override
  String get invalidHexFormat => '无效的十六进制格式';

  @override
  String get invalidRgbFormat => '无效的RGB格式';

  @override
  String get rateUpdatedRecently => '汇率最近已更新';

  @override
  String get rateUpdatedJustNow => '汇率刚刚更新';

  @override
  String rateUpdatedMinutesAgo(int minutes, String plural) {
    return '汇率在 $minutes 分钟前更新';
  }

  @override
  String rateUpdatedHoursAgo(int hours, String plural) {
    return '汇率在 $hours 小时前更新';
  }

  @override
  String rateUpdatedDaysAgo(int days, String plural) {
    return '汇率在 $days 天前更新';
  }

  @override
  String rateUpdatedAt(String time) {
    return '汇率更新时间：$time';
  }

  @override
  String get categoryLength => '长度';

  @override
  String get categoryArea => '面积';

  @override
  String get categoryVolume => '体积';

  @override
  String get categoryWeight => '重量';

  @override
  String get categoryTemperature => '温度';

  @override
  String get categoryStorage => '存储';

  @override
  String get categorySpeed => '速度';

  @override
  String get categoryColor => '颜色';

  @override
  String get categoryEnergy => '能量';

  @override
  String get categoryPressure => '压力';

  @override
  String get categoryAngle => '角度';

  @override
  String get conversionHistoryEmpty => '暂无转换历史';

  @override
  String get startConverting => '开始转换以查看历史记录';

  @override
  String get deleteItem => '删除项目';

  @override
  String get deleteItemConfirm => '您确定要删除此项目吗？';

  @override
  String get appSubtitle => '强大的单位转换工具';

  @override
  String get darkModeTitle => '深色模式';

  @override
  String get darkModeSubtitle => '启用护眼的深色主题';

  @override
  String get accentColor => '主题色';

  @override
  String get colorPicker => '颜色选择器';

  @override
  String get selectColor => '选择颜色';

  @override
  String get chooseFromPalette => '从调色板选择';

  @override
  String get colorSelected => '颜色已选择';

  @override
  String get pickColor => '选取颜色';

  @override
  String get useSelectedColor => '使用选中的颜色';

  @override
  String get unitMeters => '米';

  @override
  String get unitFeet => '英尺';

  @override
  String get unitInches => '英寸';

  @override
  String get unitCentimeters => '厘米';

  @override
  String get unitYards => '码';

  @override
  String get unitMiles => '英里';

  @override
  String get unitSquareMeters => '平方米';

  @override
  String get unitSquareFeet => '平方英尺';

  @override
  String get unitSquareInches => '平方英寸';

  @override
  String get unitAcres => '英亩';

  @override
  String get unitHectares => '公顷';

  @override
  String get unitLiters => '升';

  @override
  String get unitGallons => '加仑';

  @override
  String get unitMilliliters => '毫升';

  @override
  String get unitCubicMeters => '立方米';

  @override
  String get unitCubicFeet => '立方英尺';

  @override
  String get unitKg => '公斤';

  @override
  String get unitPounds => '磅';

  @override
  String get unitOunces => '盎司';

  @override
  String get unitGrams => '克';

  @override
  String get unitTons => '吨';

  @override
  String get unitByte => '字节';

  @override
  String get unitBit => '位';

  @override
  String get unitKB => '千字节';

  @override
  String get unitMB => '兆字节';

  @override
  String get unitGB => '吉字节';

  @override
  String get unitTB => '太字节';

  @override
  String get unitSecond => '秒';

  @override
  String get unitMinute => '分钟';

  @override
  String get unitHour => '小时';

  @override
  String get unitDay => '天';

  @override
  String get unitWeek => '周';

  @override
  String get unitYear => '年';

  @override
  String get unitMs => '米/秒';

  @override
  String get unitKmh => '千米/小时';

  @override
  String get unitMph => '英里/小时';

  @override
  String get unitKnot => '节';

  @override
  String get unitMach => '马赫';

  @override
  String get unitJoule => '焦耳';

  @override
  String get unitCalorie => '卡路里';

  @override
  String get unitKilocalorie => '千卡';

  @override
  String get unitKWh => '千瓦时';

  @override
  String get unitPascal => '帕斯卡';

  @override
  String get unitBar => '巴';

  @override
  String get unitPSI => '磅力每平方英寸';

  @override
  String get unitAtmosphere => '大气压';

  @override
  String get unitDegree => '度';

  @override
  String get unitRadian => '弧度';

  @override
  String get unitGradian => '百分度';

  @override
  String get unitCelsius => '摄氏度';

  @override
  String get unitFahrenheit => '华氏度';

  @override
  String get unitKelvin => '开尔文';

  @override
  String get unitHEX => '十六进制';

  @override
  String get unitRGBA => 'RGB(A)';

  @override
  String get unitHSLA => 'HSL(A)';

  @override
  String get unitHSV => 'HSV';

  @override
  String get unitCMYK => 'CMYK';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => '轉換大師';

  @override
  String get selectCategory => '選擇轉換類別';

  @override
  String get converter => '轉換器';

  @override
  String get loading => '正在載入...';

  @override
  String get enterColorValue => '輸入顏色值';

  @override
  String get enterValueToConvert => '輸入要轉換的值';

  @override
  String get pleaseEnterValue => '請輸入數值';

  @override
  String get selectUnits => '選擇單位';

  @override
  String get from => '從';

  @override
  String get to => '到';

  @override
  String get convert => '轉換';

  @override
  String get result => '結果';

  @override
  String get waitingForInput => '等待輸入...';

  @override
  String get resultCopied => '結果已複製到剪貼簿';

  @override
  String get unit => '單位';

  @override
  String get currency => '貨幣';

  @override
  String get units => '個單位';

  @override
  String get showMore => '查看更多';

  @override
  String get showLess => '收起';

  @override
  String hiding(int count) {
    return '隱藏 $count 個類別';
  }

  @override
  String moreCategories(int count) {
    return '還有 $count 個';
  }

  @override
  String get settings => '設定';

  @override
  String get language => '語言';

  @override
  String get selectLanguage => '選擇語言';

  @override
  String get english => 'English';

  @override
  String get chinese => '简体中文';

  @override
  String get traditionalChinese => '繁體中文';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get languageChanged => '語言切換成功';

  @override
  String get theme => '主題';

  @override
  String get darkMode => '深色模式';

  @override
  String get lightMode => '淺色模式';

  @override
  String get about => '關於';

  @override
  String get appName => '應用程式名稱';

  @override
  String get version => '版本';

  @override
  String get buildNumber => '建置編號';

  @override
  String get developer => '開發者';

  @override
  String get appDescription => '一個功能強大且美觀的單位轉換應用程式\n支援多種類別和語言。';

  @override
  String get themeSwitchingComingSoon => '主題切換功能即將推出！';

  @override
  String get home => '首頁';

  @override
  String get history => '歷史記錄';

  @override
  String get favorites => '我的最愛';

  @override
  String get conversionHistory => '轉換歷史';

  @override
  String get clearAll => '全部清除';

  @override
  String get clearAllHistory => '清除所有歷史記錄';

  @override
  String get clearAllHistoryConfirm => '您確定要刪除所有轉換歷史記錄嗎？';

  @override
  String get cancel => '取消';

  @override
  String get noConversionHistory => '暫無轉換歷史記錄';

  @override
  String get historyWillAppearHere => '您的轉換歷史記錄將顯示在這裡';

  @override
  String get category => '類別';

  @override
  String get time => '時間';

  @override
  String get delete => '刪除';

  @override
  String get favoritesComingSoon => '我的最愛功能即將推出！';

  @override
  String get failedToLoadCurrencies => '無法載入貨幣';

  @override
  String get failedToLoadHistory => '無法載入歷史記錄';

  @override
  String get exchangeFailed => '匯率轉換失敗';

  @override
  String get invalidResult => '無效的結果格式';

  @override
  String get noResult => '無結果';

  @override
  String get error => '錯誤';

  @override
  String get conversionNotImplemented => '轉換功能尚未實現';

  @override
  String get invalidColorFormat => '無效的顏色格式';

  @override
  String get invalidHexFormat => '無效的十六進制格式';

  @override
  String get invalidRgbFormat => '無效的RGB格式';

  @override
  String get rateUpdatedRecently => '匯率最近已更新';

  @override
  String get rateUpdatedJustNow => '匯率剛剛更新';

  @override
  String rateUpdatedMinutesAgo(int minutes, String plural) {
    return '匯率在 $minutes 分鐘前更新';
  }

  @override
  String rateUpdatedHoursAgo(int hours, String plural) {
    return '匯率在 $hours 小時前更新';
  }

  @override
  String rateUpdatedDaysAgo(int days, String plural) {
    return '匯率在 $days 天前更新';
  }

  @override
  String rateUpdatedAt(String time) {
    return '匯率更新時間：$time';
  }

  @override
  String get categoryLength => '長度';

  @override
  String get categoryArea => '面積';

  @override
  String get categoryVolume => '體積';

  @override
  String get categoryWeight => '重量';

  @override
  String get categoryTemperature => '溫度';

  @override
  String get categoryStorage => '儲存';

  @override
  String get categorySpeed => '速度';

  @override
  String get categoryColor => '顏色';

  @override
  String get categoryEnergy => '能量';

  @override
  String get categoryPressure => '壓力';

  @override
  String get categoryAngle => '角度';

  @override
  String get conversionHistoryEmpty => '暫無轉換歷史';

  @override
  String get startConverting => '開始轉換以查看歷史記錄';

  @override
  String get deleteItem => '刪除項目';

  @override
  String get deleteItemConfirm => '您確定要刪除此項目嗎？';

  @override
  String get appSubtitle => '強大的單位轉換工具';

  @override
  String get darkModeTitle => '深色模式';

  @override
  String get darkModeSubtitle => '啟用護眼的深色主題';

  @override
  String get accentColor => '主題色';

  @override
  String get colorPicker => '顏色選擇器';

  @override
  String get selectColor => '選擇顏色';

  @override
  String get chooseFromPalette => '從調色盤選擇';

  @override
  String get colorSelected => '顏色已選擇';

  @override
  String get pickColor => '選取顏色';

  @override
  String get useSelectedColor => '使用選中的顏色';

  @override
  String get unitMeters => '公尺';

  @override
  String get unitFeet => '英尺';

  @override
  String get unitInches => '英寸';

  @override
  String get unitCentimeters => '公分';

  @override
  String get unitYards => '碼';

  @override
  String get unitMiles => '英里';

  @override
  String get unitSquareMeters => '平方公尺';

  @override
  String get unitSquareFeet => '平方英尺';

  @override
  String get unitSquareInches => '平方英寸';

  @override
  String get unitAcres => '英畝';

  @override
  String get unitHectares => '公頃';

  @override
  String get unitLiters => '公升';

  @override
  String get unitGallons => '加侖';

  @override
  String get unitMilliliters => '毫升';

  @override
  String get unitCubicMeters => '立方公尺';

  @override
  String get unitCubicFeet => '立方英尺';

  @override
  String get unitKg => '公斤';

  @override
  String get unitPounds => '磅';

  @override
  String get unitOunces => '盎司';

  @override
  String get unitGrams => '公克';

  @override
  String get unitTons => '公噸';

  @override
  String get unitByte => '位元組';

  @override
  String get unitBit => '位元';

  @override
  String get unitKB => '千位元組';

  @override
  String get unitMB => '百萬位元組';

  @override
  String get unitGB => '十億位元組';

  @override
  String get unitTB => '兆位元組';

  @override
  String get unitSecond => '秒';

  @override
  String get unitMinute => '分鐘';

  @override
  String get unitHour => '小時';

  @override
  String get unitDay => '天';

  @override
  String get unitWeek => '週';

  @override
  String get unitYear => '年';

  @override
  String get unitMs => '公尺/秒';

  @override
  String get unitKmh => '公里/小時';

  @override
  String get unitMph => '英里/小時';

  @override
  String get unitKnot => '節';

  @override
  String get unitMach => '馬赫';

  @override
  String get unitJoule => '焦耳';

  @override
  String get unitCalorie => '卡路里';

  @override
  String get unitKilocalorie => '千卡';

  @override
  String get unitKWh => '千瓦時';

  @override
  String get unitPascal => '帕斯卡';

  @override
  String get unitBar => '巴';

  @override
  String get unitPSI => '磅力每平方英寸';

  @override
  String get unitAtmosphere => '大氣壓';

  @override
  String get unitDegree => '度';

  @override
  String get unitRadian => '弧度';

  @override
  String get unitGradian => '百分度';

  @override
  String get unitCelsius => '攝氏度';

  @override
  String get unitFahrenheit => '華氏度';

  @override
  String get unitKelvin => '開爾文';

  @override
  String get unitHEX => '十六進制';

  @override
  String get unitRGBA => 'RGB(A)';

  @override
  String get unitHSLA => 'HSL(A)';

  @override
  String get unitHSV => 'HSV';

  @override
  String get unitCMYK => 'CMYK';
}

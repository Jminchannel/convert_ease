import 'package:flutter/material.dart';
import '../services/language_service.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  /// 初始化语言设置
  Future<void> initialize() async {
    _currentLocale = await LanguageService.getSavedLanguage();
    notifyListeners();
  }

  /// 切换语言
  Future<void> changeLanguage(Locale locale) async {
    if (_currentLocale == locale) return;
    
    _currentLocale = locale;
    await LanguageService.saveLanguage(locale);
    notifyListeners();
  }

  /// 获取支持的语言列表
  List<Locale> get supportedLocales => LanguageService.supportedLocales;

  /// 获取语言显示名称
  String getLanguageName(Locale locale) => LanguageService.getLanguageName(locale);
}

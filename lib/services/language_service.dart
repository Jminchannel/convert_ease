import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'selected_language';
  static const String _defaultLanguage = 'en';

  // 支持的语言列表
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('zh'), // Simplified Chinese
    Locale('zh', 'TW'), // Traditional Chinese
    Locale('id'), // Indonesian
  ];

  // 语言显示名称映射
  static const Map<String, String> languageNames = {
    'en': 'English',
    'zh': '简体中文',
    'zh_TW': '繁體中文',
    'id': 'Bahasa Indonesia',
  };

  /// 获取当前保存的语言
  static Future<Locale> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? _defaultLanguage;
    
    // 处理繁体中文的特殊情况
    if (languageCode == 'zh_TW') {
      return const Locale('zh', 'TW');
    }
    
    return Locale(languageCode);
  }

  /// 保存选择的语言
  static Future<void> saveLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    
    // 处理繁体中文的特殊情况
    String languageCode;
    if (locale.languageCode == 'zh' && locale.countryCode == 'TW') {
      languageCode = 'zh_TW';
    } else {
      languageCode = locale.languageCode;
    }
    
    await prefs.setString(_languageKey, languageCode);
  }

  /// 获取语言显示名称
  static String getLanguageName(Locale locale) {
    if (locale.languageCode == 'zh' && locale.countryCode == 'TW') {
      return languageNames['zh_TW'] ?? 'Unknown';
    }
    return languageNames[locale.languageCode] ?? 'Unknown';
  }

  /// 检查是否是支持的语言
  static bool isSupported(Locale locale) {
    return supportedLocales.any((supported) =>
        supported.languageCode == locale.languageCode &&
        supported.countryCode == locale.countryCode);
  }

  /// 获取语言代码字符串（用于存储）
  static String getLanguageCode(Locale locale) {
    if (locale.languageCode == 'zh' && locale.countryCode == 'TW') {
      return 'zh_TW';
    }
    return locale.languageCode;
  }
}

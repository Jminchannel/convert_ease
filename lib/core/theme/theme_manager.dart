import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

/// 主题颜色枚举
enum ThemeColor {
  blue('Blue', Colors.blue),
  green('Green', Colors.green),
  purple('Purple', Colors.purple),
  orange('Orange', Colors.orange),
  red('Red', Colors.red),
  teal('Teal', Colors.teal),
  indigo('Indigo', Colors.indigo),
  pink('Pink', Colors.pink);

  const ThemeColor(this.label, this.color);
  final String label;
  final Color color;
}

/// 主题管理器
/// 
/// 管理应用的主题状态，支持亮色和暗色主题切换以及多种颜色主题
class ThemeManager extends ValueNotifier<ThemeData> {
  static const String _themeKey = 'app_theme_mode';
  static const String _colorKey = 'app_theme_color';
  bool _isDarkMode = false;
  ThemeColor _currentColor = ThemeColor.blue;

  ThemeManager() : super(AppTheme.getTheme(ThemeColor.blue, false)) {
    _loadTheme();
  }

  /// 获取当前是否为暗色主题
  bool get isDarkMode => _isDarkMode;
  
  /// 获取当前主题颜色
  ThemeColor get currentColor => _currentColor;

  /// 切换主题
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    value = AppTheme.getTheme(_currentColor, _isDarkMode);
    await _saveTheme();
  }

  /// 设置主题模式
  Future<void> setThemeMode(bool isDark) async {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      value = AppTheme.getTheme(_currentColor, _isDarkMode);
      await _saveTheme();
    }
  }

  /// 设置主题颜色
  Future<void> setThemeColor(ThemeColor color) async {
    if (_currentColor != color) {
      _currentColor = color;
      value = AppTheme.getTheme(_currentColor, _isDarkMode);
      await _saveTheme();
    }
  }

  /// 加载保存的主题设置
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_themeKey) ?? false;
      
      // 加载颜色主题
      final colorIndex = prefs.getInt(_colorKey) ?? 0;
      if (colorIndex >= 0 && colorIndex < ThemeColor.values.length) {
        _currentColor = ThemeColor.values[colorIndex];
      }
      
      value = AppTheme.getTheme(_currentColor, _isDarkMode);
    } catch (e) {
      // 如果加载失败，使用默认主题
      _isDarkMode = false;
      _currentColor = ThemeColor.blue;
      value = AppTheme.getTheme(_currentColor, _isDarkMode);
    }
  }

  /// 保存主题设置
  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
      await prefs.setInt(_colorKey, _currentColor.index);
    } catch (e) {
      // 保存失败时静默处理
    }
  }
}

/// 全局主题管理器实例
final themeManager = ThemeManager();

/// 应用主题配置
library app_theme;

import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import 'theme_manager.dart';

/// 应用主题管理器
class AppTheme {
  AppTheme._(); // 防止实例化

  /// 根据颜色和模式获取主题
  static ThemeData getTheme(ThemeColor themeColor, bool isDark) {
    return isDark ? _getDarkTheme(themeColor) : _getLightTheme(themeColor);
  }

  /// 获取浅色主题
  static ThemeData _getLightTheme(ThemeColor themeColor) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeColor.color,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: themeColor.color.withOpacity(0.1),
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: AppSizes.fontSizeM,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      scaffoldBackgroundColor: Colors.grey[50],
      
      /// 文本主题
      textTheme: _buildTextTheme(),
      
      /// 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor.color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius / 2),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingL,
            vertical: AppSizes.spacingS,
          ),
        ),
      ),
      
      /// 卡片主题
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        color: Colors.white,
      ),
      
      /// 进度指示器主题
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: themeColor.color,
      ),
    );
  }

  /// 浅色主题（保持向后兼容）
  static ThemeData get lightTheme => _getLightTheme(ThemeColor.blue);

  /// 获取深色主题
  static ThemeData _getDarkTheme(ThemeColor themeColor) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeColor.color,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      
      /// AppBar主题
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: AppSizes.fontSizeM,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      
      /// 文本主题
      textTheme: _buildDarkTextTheme(),
      
      /// 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor.color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius / 2),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingL,
            vertical: AppSizes.spacingS,
          ),
        ),
      ),
      
      /// 卡片主题
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        color: const Color(0xFF1F1F1F),
      ),
      
      /// 抽屉主题
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(0xFF1F1F1F),
      ),
      
      /// 进度指示器主题
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: themeColor.color,
      ),
    );
  }

  /// 深色主题（保持向后兼容）
  static ThemeData get darkTheme => _getDarkTheme(ThemeColor.blue);

  /// 构建文本主题
  static TextTheme _buildTextTheme() {
    return const TextTheme(
      headlineLarge: TextStyle(
        fontSize: AppSizes.fontSizeL,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: AppSizes.fontSizeM,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: AppSizes.fontSizeS,
        color: AppColors.textSecondary,
      ),
    );
  }

  /// 构建深色主题文本主题
  static TextTheme _buildDarkTextTheme() {
    return const TextTheme(
      headlineLarge: TextStyle(
        fontSize: AppSizes.fontSizeL,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontSize: AppSizes.fontSizeM,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: AppSizes.fontSizeM,
        color: Colors.white,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: AppSizes.fontSizeS,
        color: Colors.white70,
      ),
    );
  }
}

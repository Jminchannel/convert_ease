/// 应用主题配置
library app_theme;

import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// 应用主题管理器
class AppTheme {
  AppTheme._(); // 防止实例化

  /// 浅色主题
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: AppSizes.fontSizeM,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      scaffoldBackgroundColor: AppColors.primaryLight,
      
      /// 文本主题
      textTheme: _buildTextTheme(),
      
      /// 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
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
        color: AppColors.background,
      ),
      
      /// 进度指示器主题
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.textPrimary,
      ),
    );
  }

  /// 深色主题 (可选)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      textTheme: _buildTextTheme(),
    );
  }

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
}

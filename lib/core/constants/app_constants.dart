/// 应用程序常量定义
library app_constants;

import 'package:flutter/material.dart';

/// 应用程序基本信息
class AppInfo {
  static const String appName = 'Convert Ease';
  static const String appDescription = '一个强大的转换工具应用';
}

/// 颜色常量
class AppColors {
  AppColors._(); // 防止实例化

  /// 主要颜色
  static const Color primary = Colors.deepPurple;
  static Color primaryLight = Colors.grey[300]!;

  /// 文本颜色
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;

  /// 背景颜色
  static const Color background = Colors.deepPurple;
}

/// 尺寸常量
class AppSizes {
  AppSizes._(); // 防止实例化

  /// 通用间距
  static const double spacingXS = 8.0;
  static const double spacingS = 16.0;
  static const double spacingM = 20.0;
  static const double spacingL = 25.0;
  static const double spacingXL = 30.0;

  /// 图标尺寸
  static const double iconSizeL = 100.0;

  /// 容器尺寸
  static const double containerSize = 300.0;
  static const double borderRadius = 20.0;

  /// 字体尺寸
  static const double fontSizeS = 14.0;
  static const double fontSizeM = 20.0;
  static const double fontSizeL = 32.0;
}

/// 动画常量
class AppAnimations {
  AppAnimations._(); // 防止实例化

  /// 动画持续时间
  static const Duration splashAnimationDuration = Duration(milliseconds: 1500);
  static const Duration navigationDelay = Duration(milliseconds: 500);

  /// 动画间隔
  static const Interval fadeInInterval = Interval(
    0.0,
    0.6,
    curve: Curves.easeIn,
  );
  static const Interval scaleInterval = Interval(
    0.2,
    0.8,
    curve: Curves.elasticOut,
  );
  static const Interval slideInterval = Interval(
    0.3,
    1.0,
    curve: Curves.easeOut,
  );
  static const Interval progressInterval = Interval(0.6, 1.0);
  static const Interval versionInterval = Interval(0.7, 1.0);
}

/// 路由常量
class AppRoutes {
  AppRoutes._(); // 防止实例化

  static const String splash = '/';
  static const String home = '/home';
}

/// 字符串常量
class AppStrings {
  AppStrings._(); // 防止实例化

  static const String welcomeMessage = '欢迎使用 Convert Ease！\n\n这里可以放置您的转换工具。';
  static const String versionPrefix = 'v';
}

// lib/core/routes/app_routes.dart
import 'package:flutter/material.dart';

import '../ui/main_screen.dart';
import '../ui/splash_screen.dart';

/// 应用路由名称常量
class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/home';
// 可以在这里添加更多路由
// static const String details = '/details';
// static const String profile = '/profile';
}

/// 应用路由配置管理类
class AppRouter {
  /// 获取所有路由配置
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.splash: (context) => const SplashScreen(),
      AppRoutes.home: (context) => const MainScreen(),
      // 在这里添加更多路由配置
    };
  }

  /// 获取初始路由
  static String get initialRoute => AppRoutes.splash;

  /// 可选：路由生成器（用于带参数的路由）
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // 这里可以处理带参数的路由
    // switch (settings.name) {
    //   case AppRoutes.details:
    //     final args = settings.arguments as Map<String, dynamic>;
    //     return MaterialPageRoute(
    //       builder: (context) => DetailsScreen(args: args),
    //     );
    //   default:
    //     return null;
    // }
    return null;
  }
}
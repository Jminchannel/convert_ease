import 'package:flutter/material.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_manager.dart';
import 'routes/app_routes.dart';
import 'ui/main_screen.dart';
import 'ui/splash_screen.dart';

/// 应用程序入口点
void main() {
  runApp(const MyApp());
}

/// 应用程序根组件
///
/// 配置应用主题、路由和基本设置
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: themeManager,
      builder: (context, theme, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppInfo.appName,
          theme: theme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeManager.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: AppRouter.initialRoute,
          routes: AppRouter.getRoutes(),
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}

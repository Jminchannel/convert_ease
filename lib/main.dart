import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_manager.dart';
import 'generated/app_localizations.dart';
import 'providers/language_provider.dart';
import 'routes/app_routes.dart';
import 'ui/main_screen.dart';
import 'ui/splash_screen.dart';

/// 应用程序入口点
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化语言提供者
  final languageProvider = LanguageProvider();
  await languageProvider.initialize();
  
  runApp(MyApp(languageProvider: languageProvider));
}

/// 应用程序根组件
///
/// 配置应用主题、路由和基本设置
class MyApp extends StatelessWidget {
  final LanguageProvider languageProvider;
  
  const MyApp({super.key, required this.languageProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LanguageProvider>.value(
      value: languageProvider,
      child: Consumer<LanguageProvider>(
        builder: (context, langProvider, child) {
          return ValueListenableBuilder<ThemeData>(
            valueListenable: themeManager,
            builder: (context, theme, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: AppInfo.appName,
                theme: theme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeManager.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                
                // 多语言支持
                locale: langProvider.currentLocale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: langProvider.supportedLocales,
                
                initialRoute: AppRouter.initialRoute,
                routes: AppRouter.getRoutes(),
                onGenerateRoute: AppRouter.onGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/theme_manager.dart';
import '../generated/app_localizations.dart';
import '../providers/language_provider.dart';
import 'favour_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

/// 应用主页面
///
/// 显示欢迎信息和主要功能区域
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen>{
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  List<Widget> _getPages(LanguageProvider languageProvider) {
    return [
      const HomeScreen(),
      const HistoryScreen(),
      SettingsScreen(languageProvider: languageProvider),
    ];
  }
  @override
  void initState() {
    super.initState();
    // 监听页面滑动事件
    _pageController.addListener(_handlePageChange);
  }
  void _handlePageChange() {
    // 滑动界面更新底部导航
    final page = _pageController.page?.round();
    if(page != null && page != _currentIndex) {
      setState(() {
        _currentIndex = page;
      });
    }
  }
  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }
  @override
  void dispose() {
    _pageController.removeListener(_handlePageChange);
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final l10n = AppLocalizations.of(context)!;
        final pages = _getPages(languageProvider);
        
        return Scaffold(
          // 通过 _scaffoldKey 可以直接调用 Scaffold 的各种方法
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          drawer: _buildDrawer(l10n),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: _openDrawer,
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                splashRadius: 20,
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          body: PageView(
            controller: _pageController,
            physics: const ClampingScrollPhysics(),
            children: pages,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          bottomNavigationBar: _buildBottomNavigationBar(l10n),
        );
      },
    );
  }
  Widget _buildDrawer(AppLocalizations l10n) {
    return Drawer(
      child: Column(
        children: [
          _builderDrawerHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                _buildSectionTitle(context, 'Appearance'),
                _buildThemeSection(),
                const Divider(height: 30),
                _buildSectionTitle(context, 'About'),
                _buildAboutSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(AppLocalizations l10n) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOut);
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: l10n.home
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.history),
              label: l10n.history
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: l10n.settings
          )
        ]
    );
  }

  Widget _builderDrawerHeader() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.calculate_outlined,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              final l10n = AppLocalizations.of(context)!;
              return Column(
                children: [
                  Text(
                    l10n.appTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.appSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSection() {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: themeManager,
      builder: (context, theme, child) {
        return Column(
          children: [
            Consumer<LanguageProvider>(
              builder: (context, languageProvider, child) {
                final l10n = AppLocalizations.of(context)!;
                return SwitchListTile(
                  title: Text(l10n.darkModeTitle),
                  subtitle: Text(l10n.darkModeSubtitle),
                  value: themeManager.isDarkMode,
                  onChanged: (value) {
                    themeManager.setThemeMode(value);
                  },
                  secondary: Icon(
                    themeManager.isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Consumer<LanguageProvider>(
                    builder: (context, languageProvider, child) {
                      final l10n = AppLocalizations.of(context)!;
                      return Text(l10n.accentColor, style: Theme.of(context).textTheme.titleMedium);
                    },
                  ),
                   const SizedBox(height: 16),
                  _buildColorSelector(),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildColorSelector() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: ThemeColor.values.map((color) {
        final isSelected = themeManager.currentColor == color;
        return GestureDetector(
          onTap: () {
            themeManager.setThemeColor(color);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected 
                        ? (themeManager.isDarkMode ? Colors.white : Colors.black87)
                        : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24,
                      )
                    : null,
              ),
              const SizedBox(height: 4),
              Text(
                color.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? color.color : null,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.apps_outlined),
          title: const Text('App Name'),
          subtitle: const Text('Convert Ease'),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Version'),
          subtitle: const Text('v1.0.0'),
        ),
        ListTile(
          leading: const Icon(Icons.code_outlined),
          title: const Text('Developer'),
          subtitle: const Text('Your Name'),
        ),
      ],
    );
  }
}



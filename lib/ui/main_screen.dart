import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/theme_manager.dart';
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
  final List<Widget> _pages = [
    const HomeScreen(),
    const HistoryScreen(),
    const FavourScreen(),
    const SettingsScreen(),
  ];
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
    return Scaffold(
      // 通过 _scaffoldKey 可以直接调用 Scaffold 的各种方法
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      appBar: AppBar(
        leading: IconButton(
            onPressed: _openDrawer,
            icon: const Icon(Icons.menu)
        ),
        foregroundColor: Colors.black,
      ),
      body: PageView(
        controller: _pageController,
        physics: const ClampingScrollPhysics(),
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
  Widget _buildDrawer() {
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

  BottomNavigationBar _buildBottomNavigationBar() {
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
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'home'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'history'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'favour'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'settings'
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
          Text(
            'Convert Ease',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'A Powerful Unit Converter',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
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
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Enable eye-friendly dark theme'),
              value: themeManager.isDarkMode,
              onChanged: (value) {
                themeManager.setThemeMode(value);
              },
              secondary: Icon(
                themeManager.isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('Accent Color', style: Theme.of(context).textTheme.titleMedium),
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



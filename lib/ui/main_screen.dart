import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
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
    throw UnimplementedError();
  }
  Widget _buildDrawer() {
    return Drawer(
      // 抽屉宽度为屏幕的75%
      width: MediaQuery.of(context).size.width * 0.75,
      child: Column(
        children: [
          _builderDrawerHeader(),
        ],
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
    return DrawerHeader(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.blue,
              ),
            )
          ],
        )
    );
  }
}



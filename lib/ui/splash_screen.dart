import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/logger.dart';

/// 启动画面组件
///
/// 显示应用logo、动画效果和版本信息，
/// 在动画完成后自动跳转到主页面
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _positionAnimation;
  String _version = '';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _getAppVersion();
    _startAnimationSequence();
  }

  /// 初始化所有动画
  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.splashAnimationDuration,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.fadeInInterval),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.scaleInterval),
    );

    _positionAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: AppAnimations.slideInterval,
          ),
        );
  }

  /// 开始动画序列并导航
  void _startAnimationSequence() {
    _controller.forward().then((_) {
      Future.delayed(AppAnimations.navigationDelay, () {
        if (mounted) {
          _navigateToHome();
        }
      });
    });
  }

  /// 导航到主页面
  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedIcon(),
            SizedBox(height: AppSizes.spacingM),
            _buildAnimatedTitle(),
            SizedBox(height: AppSizes.spacingXL),
            _buildProgressIndicator(),
            SizedBox(height: AppSizes.spacingM),
            if (_version.isNotEmpty) _buildVersionText(),
          ],
        ),
      ),
    );
  }

  /// 构建动画图标
  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(scale: _scaleAnimation.value, child: child),
        );
      },
      child: Icon(
        Icons.calculate,
        size: AppSizes.iconSizeL,
        color: AppColors.textPrimary,
      ),
    );
  }

  /// 构建动画标题
  Widget _buildAnimatedTitle() {
    return SlideTransition(
      position: _positionAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Text(
          AppInfo.appName,
          style: TextStyle(
            fontSize: AppSizes.fontSizeL,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  /// 构建进度指示器
  Widget _buildProgressIndicator() {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: AppAnimations.progressInterval,
        ),
      ),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimary),
      ),
    );
  }

  /// 构建版本号文本
  Widget _buildVersionText() {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: AppAnimations.versionInterval,
        ),
      ),
      child: Text(
        _version,
        style: TextStyle(
          fontSize: AppSizes.fontSizeS,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 获取应用版本信息
  Future<void> _getAppVersion() async {
    try {
      AppLogger.info('开始获取应用版本信息');
      final packageInfo = await PackageInfo.fromPlatform();
      
      if (mounted) {
        final version = '${AppStrings.versionPrefix}${packageInfo.version}';
        setState(() {
          _version = version;
        });
        AppLogger.info('版本信息获取成功: $version');
      }
    } catch (e, stackTrace) {
      AppLogger.error('获取版本信息失败', e, stackTrace);
      // 如果获取版本信息失败，保持默认空字符串
    }
  }
}

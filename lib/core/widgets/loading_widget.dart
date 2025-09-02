/// 加载状态组件
library loading_widget;

import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// 通用加载组件
class AppLoadingWidget extends StatelessWidget {
  /// 加载提示信息
  final String? message;
  
  /// 是否显示在覆盖层
  final bool overlay;
  
  /// 加载指示器大小
  final double? size;

  const AppLoadingWidget({
    super.key,
    this.message,
    this.overlay = false,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final child = _buildLoadingContent();
    
    if (overlay) {
      return Container(
        color: Colors.black54,
        child: child,
      );
    }
    
    return child;
  }

  Widget _buildLoadingContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size ?? 50,
            height: size ?? 50,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            SizedBox(height: AppSizes.spacingM),
            Text(
              message!,
              style: TextStyle(
                fontSize: AppSizes.fontSizeS,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// 简单的加载指示器
class AppLoadingIndicator extends StatelessWidget {
  /// 大小
  final double size;
  
  /// 颜色
  final Color? color;

  const AppLoadingIndicator({
    super.key,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primary,
        ),
        strokeWidth: 2,
      ),
    );
  }
}

/// 页面级加载覆盖组件
class AppLoadingOverlay extends StatelessWidget {
  /// 子组件
  final Widget child;
  
  /// 是否显示加载
  final bool isLoading;
  
  /// 加载提示信息
  final String? loadingMessage;

  const AppLoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          AppLoadingWidget(
            message: loadingMessage,
            overlay: true,
          ),
      ],
    );
  }
}

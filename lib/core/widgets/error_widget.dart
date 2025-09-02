/// 错误处理组件
library error_widget;

import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// 通用错误显示组件
class AppErrorWidget extends StatelessWidget {
  /// 错误信息
  final String message;
  
  /// 重试回调函数
  final VoidCallback? onRetry;
  
  /// 图标
  final IconData icon;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppSizes.iconSizeL,
              color: Colors.red[300],
            ),
            SizedBox(height: AppSizes.spacingM),
            Text(
              message,
              style: TextStyle(
                fontSize: AppSizes.fontSizeM,
                color: Colors.red[400],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: AppSizes.spacingL),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('重试'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 空状态组件
class AppEmptyWidget extends StatelessWidget {
  /// 显示信息
  final String message;
  
  /// 图标
  final IconData icon;
  
  /// 操作按钮文本
  final String? actionText;
  
  /// 操作回调
  final VoidCallback? onAction;

  const AppEmptyWidget({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppSizes.iconSizeL,
              color: Colors.grey[400],
            ),
            SizedBox(height: AppSizes.spacingM),
            Text(
              message,
              style: TextStyle(
                fontSize: AppSizes.fontSizeM,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              SizedBox(height: AppSizes.spacingL),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 日志工具类
library logger;

import 'package:flutter/foundation.dart';

/// 应用日志管理器
class AppLogger {
  AppLogger._(); // 防止实例化

  /// 调试日志
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('🐛 [DEBUG] $message');
      if (error != null) {
        debugPrint('🐛 [ERROR] $error');
      }
      if (stackTrace != null) {
        debugPrint('🐛 [STACK] $stackTrace');
      }
    }
  }

  /// 信息日志
  static void info(String message) {
    if (kDebugMode) {
      debugPrint('ℹ️ [INFO] $message');
    }
  }

  /// 警告日志
  static void warning(String message) {
    if (kDebugMode) {
      debugPrint('⚠️ [WARNING] $message');
    }
  }

  /// 错误日志
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('❌ [ERROR] $message');
      if (error != null) {
        debugPrint('❌ [DETAILS] $error');
      }
      if (stackTrace != null) {
        debugPrint('❌ [STACK] $stackTrace');
      }
    }
  }

  /// 性能日志
  static void performance(String operation, Duration duration) {
    if (kDebugMode) {
      debugPrint('⏱️ [PERF] $operation took ${duration.inMilliseconds}ms');
    }
  }
}

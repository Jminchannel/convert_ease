import 'dart:convert';

/// 转换历史记录模型
class ConversionHistory {
  final String id;
  final String category;
  final String fromUnit;
  final String toUnit;
  final double inputValue;
  final String resultValue;
  final DateTime timestamp;
  final String? updateTime; // 汇率更新时间（仅适用于货币转换）

  ConversionHistory({
    required this.id,
    required this.category,
    required this.fromUnit,
    required this.toUnit,
    required this.inputValue,
    required this.resultValue,
    required this.timestamp,
    this.updateTime,
  });

  /// 从JSON创建ConversionHistory对象
  factory ConversionHistory.fromJson(Map<String, dynamic> json) {
    return ConversionHistory(
      id: json['id'] as String,
      category: json['category'] as String,
      fromUnit: json['fromUnit'] as String,
      toUnit: json['toUnit'] as String,
      inputValue: (json['inputValue'] as num).toDouble(),
      resultValue: json['resultValue'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      updateTime: json['updateTime'] as String?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'fromUnit': fromUnit,
      'toUnit': toUnit,
      'inputValue': inputValue,
      'resultValue': resultValue,
      'timestamp': timestamp.toIso8601String(),
      'updateTime': updateTime,
    };
  }

  /// 格式化显示时间
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  /// 获取转换描述
  String get conversionDescription {
    return '$inputValue $fromUnit → $resultValue $toUnit';
  }
}


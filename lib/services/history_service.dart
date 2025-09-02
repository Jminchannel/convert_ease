import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/conversion_history.dart';

/// 历史记录服务
class HistoryService {
  static const String _historyKey = 'conversion_history';
  static const int _maxHistoryCount = 100; // 最大保存100条记录

  /// 获取所有历史记录
  static Future<List<ConversionHistory>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];
      
      return historyJson
          .map((json) => ConversionHistory.fromJson(jsonDecode(json)))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // 按时间倒序排列
    } catch (e) {
      print('Error loading history: $e');
      return [];
    }
  }

  /// 添加新的历史记录
  static Future<void> addHistory(ConversionHistory history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentHistory = await getHistory();
      
      // 添加新记录到列表开头
      currentHistory.insert(0, history);
      
      // 如果超过最大数量，删除最旧的记录
      if (currentHistory.length > _maxHistoryCount) {
        currentHistory.removeRange(_maxHistoryCount, currentHistory.length);
      }
      
      // 转换为JSON字符串列表并保存
      final historyJson = currentHistory
          .map((history) => jsonEncode(history.toJson()))
          .toList();
      
      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      print('Error saving history: $e');
    }
  }

  /// 删除指定的历史记录
  static Future<void> deleteHistory(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentHistory = await getHistory();
      
      // 删除指定ID的记录
      currentHistory.removeWhere((history) => history.id == id);
      
      // 保存更新后的列表
      final historyJson = currentHistory
          .map((history) => jsonEncode(history.toJson()))
          .toList();
      
      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      print('Error deleting history: $e');
    }
  }

  /// 清空所有历史记录
  static Future<void> clearAllHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      print('Error clearing history: $e');
    }
  }

  /// 生成唯一ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}


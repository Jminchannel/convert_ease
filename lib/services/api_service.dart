import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _exchangeUrl = 'https://v3.alapi.cn/api/exchange';
  static const String _token = 'evhbjuxo7lprx4r7ose6yv3exlz5pq';

  Future<Map<String, dynamic>> getCurrencyTypesAndRates() async {
    final response = await http.get(Uri.parse('$_exchangeUrl/type?token=$_token'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        final List<dynamic> currencyList = data['data'];
        final currencies = currencyList.map((currency) {
          return {
            'name': currency['name'].toString(),
            'value': currency['value'].toString(),
          };
        }).toList();
        return {
          'currencies': currencies
        };
      } else {
        throw Exception('Failed to load currency types: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load currency types');
    }
  }


  Future<Map<String, dynamic>> getSingleRate(String from, String to,double money) async {
    final url = '$_exchangeUrl?from=$from&to=$to&money=${money}&token=$_token';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        dynamic apiData = data['data'];
        
        // 处理API返回的不同数据结构
        if (apiData is List) {
          // 如果返回的是List，取第一个元素
          final result = apiData.map((item) {
            return {
              'exchange': item['exchange']?.toString() ?? '',
              'exchange_from': item['exchange_from']?.toString() ?? '',
              'exchange_to': item['exchange_to']?.toString() ?? '',
              'exchange_round': item['exchange_round']?.toString() ?? '',
              'currency_money': item['currency_money']?.toString() ?? '',
              'update_time': item['update_time']?.toString() ?? '',
            };
          }).toList();
          return {'result': result};
        } else if (apiData is Map) {
          // 如果返回的是Map，直接处理
          return {
            'result': [{
              'exchange': apiData['exchange']?.toString() ?? '',
              'exchange_from': apiData['exchange_from']?.toString() ?? '',
              'exchange_to': apiData['exchange_to']?.toString() ?? '',
              'exchange_round': apiData['exchange_round']?.toString() ?? '',
              'currency_money': apiData['currency_money']?.toString() ?? '',
              'update_time': apiData['update_time']?.toString() ?? '',
            }]
          };
        } else {
          throw Exception('Unexpected data format from API');
        }
      } else {
        throw Exception('Failed to get rate: ${data['message']}');
      }
    } else {
      throw Exception('Failed to get rate');
    }
  }
}

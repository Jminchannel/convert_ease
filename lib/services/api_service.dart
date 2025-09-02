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


  Future<Map<String, dynamic>> _getSingleRate(String from, String to,double money) async {
    final url = '$_exchangeUrl?from=$from&to=$to&money=${money}&token=$_token';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        final List<dynamic> dataList = data['data'];
        final result = dataList.map((data) {
          return {
            'exchange': data['exchange'].toString(),
            'exchange_from': data['exchange_from'].toString(),
            'exchange_to': data['exchange_to'].toString(),
            'exchange_round': data['exchange_round'].toString(),
            'currency_money': data['currency_money'].toString(),
            'update_time': data['update_time'].toString(),
          };
        }).toList();
        return {
          'result': result
        };
      } else {
        throw Exception('Failed to get rate: ${data['message']}');
      }
    } else {
      throw Exception('Failed to get rate');
    }
  }
}

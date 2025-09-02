
import 'package:convert_ease/models/category_model.dart';
import 'package:convert_ease/models/conversion_history.dart';
import 'package:convert_ease/services/api_service.dart';
import 'package:convert_ease/services/history_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConversionScreen extends StatefulWidget {
  final Category category;

  const ConversionScreen({super.key, required this.category});

  @override
  State<ConversionScreen> createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  String? _fromUnit;
  String? _toUnit;
  final TextEditingController _inputController = TextEditingController();
  String _result = '';
  String _updateTime = '';
  bool _isCurrencyConversion = false;
  List<Map<String, String>> _currencyTypes = [];
  bool _isLoading = false;

  final ApiService _apiService = ApiService();

  // 各类别单位转换系数 (以基准单位为1.0)
  final Map<String, double> _conversionFactors = {
    // Length (基准: Meters)
    'Meters': 1.0,
    'Feet': 0.3048,
    'Inches': 0.0254,
    'Centimeters': 0.01,
    'Yards': 0.9144,
    'Miles': 1609.34,
    
    // Area (基准: Square Meters)
    'Square Meters': 1.0,
    'Square Feet': 0.092903,
    'Square Inches': 0.00064516,
    'Acres': 4046.86,
    'Hectares': 10000.0,
    
    // Volume (基准: Liters)
    'Liters': 1.0,
    'Gallons': 3.78541,
    'Milliliters': 0.001,
    'Cubic Meters': 1000.0,
    'Cubic Feet': 28.3168,
    
    // Weight (基准: Kg)
    'Kg': 1.0,
    'Pounds': 0.453592,
    'Ounces': 0.0283495,
    'Grams': 0.001,
    'Tons': 1000.0,
    
    // Storage (基准: Byte)
    'Byte': 1.0,
    'bit': 0.125,
    'KB': 1024.0,
    'MB': 1048576.0,
    'GB': 1073741824.0,
    'TB': 1099511627776.0,
    
    // Time (基准: Second)
    'Second': 1.0,
    'Minute': 60.0,
    'Hour': 3600.0,
    'Day': 86400.0,
    'Week': 604800.0,
    'Year': 31536000.0,
    
    // Speed (基准: m/s)
    'm/s': 1.0,
    'km/h': 0.277778,
    'mph': 0.44704,
    'knot': 0.514444,
    'Mach': 343.0,
    
    // Energy (基准: Joule)
    'Joule': 1.0,
    'Calorie': 4.184,
    'Kilocalorie': 4184.0,
    'kWh': 3600000.0,
    
    // Pressure (基准: Pascal)
    'Pascal': 1.0,
    'Bar': 100000.0,
    'PSI': 6894.76,
    'Atmosphere': 101325.0,
    
    // Angle (基准: Degree)
    'Degree': 1.0,
    'Radian': 57.2958,
    'Gradian': 0.9,
  };

  @override
  void initState() {
    super.initState();
    _isCurrencyConversion = widget.category.name == 'Currency';

    if (_isCurrencyConversion) {
      _loadCurrencyTypes();
    } else {
      _fromUnit = widget.category.units.first;
      _toUnit = widget.category.units.length > 1
          ? widget.category.units[1]
          : widget.category.units.first;
    }
    if (!_isCurrencyConversion) {
      _inputController.addListener(_convert);
    } else {
      _inputController.addListener(() {
        setState(() {}); // 更新按钮状态
      });
    }
  }

  Future<void> _loadCurrencyTypes() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data = await _apiService.getCurrencyTypesAndRates();
      setState(() {
        _currencyTypes = List<Map<String, String>>.from(data['currencies']);
        // 不再预加载汇率数据，而是在转换时实时获取
        _fromUnit = _currencyTypes.isNotEmpty ? _currencyTypes.first['value'] : null;
        _toUnit = _currencyTypes.length > 1 ? _currencyTypes[1]['value'] : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error, e.g., show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load currencies: $e')),
      );
    }
  }

  void _convert() {
    if (_isCurrencyConversion) {
      _convertCurrency();
    } else {
      _convertUnits();
    }
  }

  void _convertUnits() {
    // 特殊处理颜色转换
    if (widget.category.name == 'Color') {
      if (_inputController.text.isEmpty || _fromUnit == null || _toUnit == null) {
        setState(() {
          _result = '';
        });
        return;
      }
      final colorResult = _convertColor(_inputController.text, _fromUnit!, _toUnit!);
      setState(() {
        _result = colorResult;
      });
      // 保存到历史记录（颜色转换使用输入文本）
      _saveToHistoryWithText(_inputController.text, colorResult, null);
      return;
    }

    // 对于数字转换
    final input = double.tryParse(_inputController.text);
    if (input == null || _fromUnit == null || _toUnit == null) {
      setState(() {
        _result = '';
      });
      return;
    }

    double convertedValue;
    
    // 特殊处理温度转换
    if (widget.category.name == 'Temperature') {
      convertedValue = _convertTemperature(input, _fromUnit!, _toUnit!);
    }
    // 普通的线性转换
    else {
      final fromFactor = _conversionFactors[_fromUnit!] ?? 1.0;
      final toFactor = _conversionFactors[_toUnit!] ?? 1.0;

      final valueInBaseUnit = input * fromFactor;
      convertedValue = valueInBaseUnit / toFactor;
    }

    final resultString = convertedValue.toStringAsFixed(6).replaceAll(RegExp(r'\.?0+$'), '');

    setState(() {
      _result = resultString;
    });

    // 保存到历史记录
    _saveToHistory(input, resultString, null);
  }

  Future<void> _convertCurrency() async {
    final input = double.tryParse(_inputController.text);
    if (input == null || _fromUnit == null || _toUnit == null || input == 0) {
       setState(() => _result = '');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _apiService.getSingleRate(_fromUnit!, _toUnit!, input);
      // 检查响应数据类型并处理
      if (response['result'] != null) {
        dynamic resultData = response['result'];
        if (resultData is List && resultData.isNotEmpty) {
          // 如果是List，取第一个元素
          final convertedValue = resultData[0]['exchange_round'];
          final updateTime = resultData[0]['update_time'];
          final resultString = convertedValue.toString();
          final formattedUpdateTime = _formatUpdateTime(updateTime?.toString() ?? '');
          setState(() {
            _result = resultString;
            _updateTime = formattedUpdateTime;
          });
          // 保存到历史记录
          _saveToHistory(input, resultString, formattedUpdateTime);
        } else if (resultData is Map) {
          // 如果是Map，直接获取exchange_round
          final convertedValue = resultData['exchange_round'];
          final updateTime = resultData['update_time'];
          final resultString = convertedValue.toString();
          final formattedUpdateTime = _formatUpdateTime(updateTime?.toString() ?? '');
          setState(() {
            _result = resultString;
            _updateTime = formattedUpdateTime;
          });
          // 保存到历史记录
          _saveToHistory(input, resultString, formattedUpdateTime);
        } else {
          setState(() {
            _result = 'Invalid result format';
            _updateTime = '';
          });
        }
      } else {
        setState(() {
          _result = 'No result';
          _updateTime = '';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error: ${e.toString()}';
        _updateTime = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exchange failed: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool _canConvert() {
    final input = _inputController.text.trim();
    return input.isNotEmpty && 
           double.tryParse(input) != null && 
           _fromUnit != null && 
           _toUnit != null &&
           !_isLoading;
  }

  /// 温度转换逻辑
  double _convertTemperature(double value, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) return value;
    
    // 先转换到摄氏度作为中间单位
    double celsius;
    switch (fromUnit) {
      case '°C':
        celsius = value;
        break;
      case '°F':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'Kelvin':
        celsius = value - 273.15;
        break;
      default:
        celsius = value;
    }
    
    // 从摄氏度转换到目标单位
    switch (toUnit) {
      case '°C':
        return celsius;
      case '°F':
        return celsius * 9 / 5 + 32;
      case 'Kelvin':
        return celsius + 273.15;
      default:
        return celsius;
    }
  }

  /// 颜色格式转换逻辑
  String _convertColor(String input, String fromFormat, String toFormat) {
    if (fromFormat == toFormat) return input;
    
    try {
      // 这是一个简化的颜色转换实现
      // 实际项目中可能需要更复杂的颜色转换库
      
      if (fromFormat == 'HEX' && toFormat == 'RGB(A)') {
        return _hexToRgb(input);
      } else if (fromFormat == 'RGB(A)' && toFormat == 'HEX') {
        return _rgbToHex(input);
      } else if (fromFormat == 'HEX' && toFormat == 'HSL(A)') {
        final rgb = _hexToRgbValues(input);
        return _rgbToHsl(rgb[0], rgb[1], rgb[2]);
      } else {
        return 'Conversion not implemented yet';
      }
    } catch (e) {
      return 'Invalid color format';
    }
  }

  String _hexToRgb(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      final r = int.parse(hex.substring(0, 2), radix: 16);
      final g = int.parse(hex.substring(2, 4), radix: 16);
      final b = int.parse(hex.substring(4, 6), radix: 16);
      return 'rgb($r, $g, $b)';
    }
    return 'Invalid hex format';
  }

  List<int> _hexToRgbValues(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      final r = int.parse(hex.substring(0, 2), radix: 16);
      final g = int.parse(hex.substring(2, 4), radix: 16);
      final b = int.parse(hex.substring(4, 6), radix: 16);
      return [r, g, b];
    }
    return [0, 0, 0];
  }

  String _rgbToHex(String rgb) {
    final RegExp rgbRegex = RegExp(r'rgb\((\d+),\s*(\d+),\s*(\d+)\)');
    final match = rgbRegex.firstMatch(rgb);
    if (match != null) {
      final r = int.parse(match.group(1)!);
      final g = int.parse(match.group(2)!);
      final b = int.parse(match.group(3)!);
      return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
    }
    return 'Invalid RGB format';
  }

  String _rgbToHsl(int r, int g, int b) {
    final rNorm = r / 255.0;
    final gNorm = g / 255.0;
    final bNorm = b / 255.0;
    
    final max = [rNorm, gNorm, bNorm].reduce((a, b) => a > b ? a : b);
    final min = [rNorm, gNorm, bNorm].reduce((a, b) => a < b ? a : b);
    
    final diff = max - min;
    final sum = max + min;
    final lightness = sum / 2;
    
    if (diff == 0) {
      return 'hsl(0, 0%, ${(lightness * 100).round()}%)';
    }
    
    final saturation = lightness > 0.5 ? diff / (2 - sum) : diff / sum;
    
    double hue;
    if (max == rNorm) {
      hue = ((gNorm - bNorm) / diff) % 6;
    } else if (max == gNorm) {
      hue = (bNorm - rNorm) / diff + 2;
    } else {
      hue = (rNorm - gNorm) / diff + 4;
    }
    hue *= 60;
    if (hue < 0) hue += 360;
    
    return 'hsl(${hue.round()}, ${(saturation * 100).round()}%, ${(lightness * 100).round()}%)';
  }

  String _formatUpdateTime(String timestamp) {
    if (timestamp.isEmpty) return 'Rate updated recently';
    
    // 先直接显示原始时间戳用于调试
    print('Raw timestamp: $timestamp');
    
    try {
      // 尝试不同的时间格式
      DateTime? dateTime;
      
      // 尝试Unix时间戳（秒）
      final int? timestampInt = int.tryParse(timestamp);
      if (timestampInt != null && timestampInt > 0) {
        // 检查是否是毫秒级时间戳
        if (timestampInt > 1000000000000) {
          dateTime = DateTime.fromMillisecondsSinceEpoch(timestampInt);
        } else {
          dateTime = DateTime.fromMillisecondsSinceEpoch(timestampInt * 1000);
        }
      } else {
        // 尝试解析ISO 8601格式
        dateTime = DateTime.tryParse(timestamp);
      }
      
      if (dateTime != null) {
        final Duration difference = DateTime.now().difference(dateTime);
        
        if (difference.inMinutes < 1) {
          return 'Rate updated just now';
        } else if (difference.inMinutes < 60) {
          return 'Rate updated ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
        } else if (difference.inHours < 24) {
          return 'Rate updated ${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
        } else {
          return 'Rate updated ${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
        }
      } else {
        // 如果无法解析，直接显示原始时间戳
        return 'Rate updated at: $timestamp';
      }
    } catch (e) {
      return 'Rate updated at: $timestamp';
    }
  }

  /// 保存转换记录到历史
  Future<void> _saveToHistory(double inputValue, String resultValue, String? updateTime) async {
    if (_fromUnit == null || _toUnit == null) return;

    final history = ConversionHistory(
      id: HistoryService.generateId(),
      category: widget.category.name,
      fromUnit: _fromUnit!,
      toUnit: _toUnit!,
      inputValue: inputValue,
      resultValue: resultValue,
      timestamp: DateTime.now(),
      updateTime: updateTime,
    );

    await HistoryService.addHistory(history);
  }

  /// 保存颜色转换记录到历史（使用文本输入）
  Future<void> _saveToHistoryWithText(String inputText, String resultValue, String? updateTime) async {
    if (_fromUnit == null || _toUnit == null) return;

    // 对于颜色转换，我们使用0作为数值占位符，实际的输入值在结果中体现
    final history = ConversionHistory(
      id: HistoryService.generateId(),
      category: widget.category.name,
      fromUnit: _fromUnit!,
      toUnit: _toUnit!,
      inputValue: 0, // 颜色转换不使用数值输入
      resultValue: '$inputText → $resultValue', // 显示完整的转换过程
      timestamp: DateTime.now(),
      updateTime: updateTime,
    );

    await HistoryService.addHistory(history);
  }

  /// 获取颜色输入提示
  String? _getColorHint() {
    if (_fromUnit == null) return null;
    
    switch (_fromUnit!) {
      case 'HEX':
        return '#FF0000';
      case 'RGB(A)':
        return 'rgb(255, 0, 0)';
      case 'HSL(A)':
        return 'hsl(0, 100%, 50%)';
      case 'CMYK':
        return 'cmyk(0, 100, 100, 0)';
      case 'HSV':
        return 'hsv(0, 100, 100)';
      default:
        return null;
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _inputController,
              keyboardType: widget.category.name == 'Color' 
                  ? TextInputType.text 
                  : TextInputType.number,
              decoration: InputDecoration(
                labelText: widget.category.name == 'Color' 
                    ? 'Enter color value (e.g., #FF0000 or rgb(255,0,0))'
                    : 'Enter value to convert',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: widget.category.name == 'Color' 
                    ? _getColorHint() 
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _isCurrencyConversion
                      ? _buildCurrencyDropdown(_fromUnit, (newValue) {
                          setState(() {
                            _fromUnit = newValue;
                          });
                        })
                      : _buildUnitDropdown(_fromUnit, (newValue) {
                          setState(() {
                            _fromUnit = newValue;
                            _convert();
                          });
                        }),
                ),
                IconButton(
                  icon: Icon(Icons.swap_horiz, color: widget.category.color),
                  onPressed: () {
                    setState(() {
                      final temp = _fromUnit;
                      _fromUnit = _toUnit;
                      _toUnit = temp;
                      if (!_isCurrencyConversion) {
                        _convert();
                      }
                    });
                  },
                ),
                Expanded(
                  child: _isCurrencyConversion
                      ? _buildCurrencyDropdown(_toUnit, (newValue) {
                          setState(() {
                            _toUnit = newValue;
                          });
                        })
                      : _buildUnitDropdown(_toUnit, (newValue) {
                          setState(() {
                            _toUnit = newValue;
                            _convert();
                          });
                        }),
                ),
              ],
            ),
            if (_isCurrencyConversion)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  onPressed: _canConvert() ? _convert : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.category.color,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Convert'),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'Result',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.category.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _result,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: widget.category.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        if (_result.isNotEmpty) {
                          Clipboard.setData(ClipboardData(text: _result));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Result copied to clipboard')),
                          );
                        }
                      },
                    ),
                ],
              ),
            ),
            // 显示汇率更新时间
            if (_isCurrencyConversion)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _updateTime.isNotEmpty ? _updateTime : 'Rate updated recently',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitDropdown(String? value, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      value: value,
      items: widget.category.units.map((String unit) {
        return DropdownMenuItem<String>(
          value: unit,
          child: Text(unit),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildCurrencyDropdown(String? value, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      value: value,
      items: _currencyTypes.map((currency) {
        return DropdownMenuItem<String>(
          value: currency['value'],
          child: Text('${currency['value']}', overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}


import 'package:convert_ease/models/category_model.dart';
import 'package:convert_ease/models/conversion_history.dart';
import 'package:convert_ease/services/api_service.dart';
import 'package:convert_ease/services/history_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import '../generated/app_localizations.dart';

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
  Color _selectedColor = Colors.red; // 默认选中的颜色

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
    // 添加监听器以更新按钮状态
    _inputController.addListener(() {
      setState(() {}); // 更新按钮状态
    });
  }

  bool get _canConvert {
    final input = _inputController.text.trim();
    if (input.isEmpty) return false;
    if (_fromUnit == null || _toUnit == null) return false;
    if (_isLoading) return false;
    if (_isCurrencyConversion && _currencyTypes.isEmpty) return false;
    
    // 对于非颜色转换，检查是否为有效数字
    if (widget.category.name != 'Color' && double.tryParse(input) == null) {
      return false;
    }
    
    return true;
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
      final l10n = AppLocalizations.of(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load currencies: $e')),
        );
      }
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

  /// 显示颜色选择器对话框
  Future<void> _showColorPicker(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
    final Color? result = await showColorPickerDialog(
      context,
      _selectedColor,
      title: Text(l10n.colorPicker),
      heading: Text(l10n.selectColor),
      subheading: Text(l10n.chooseFromPalette),
      showColorCode: true,
      colorCodeHasColor: true,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: true,
      },
      actionButtons: const ColorPickerActionButtons(
        okButton: true,
        closeButton: true,
        dialogActionButtons: false,
      ),
    );
    
    if (result != null && _fromUnit != null) {
      setState(() {
        _selectedColor = result;
      });
      _updateInputFromSelectedColor();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.colorSelected),
            backgroundColor: widget.category.color,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  /// 根据选中的颜色更新输入框
  void _updateInputFromSelectedColor() {
    if (_fromUnit == null) return;
    
    String colorValue = '';
    switch (_fromUnit!) {
      case 'HEX':
        colorValue = '#${_selectedColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
        break;
      case 'RGB(A)':
        colorValue = 'rgb(${(_selectedColor.r * 255).round()}, ${(_selectedColor.g * 255).round()}, ${(_selectedColor.b * 255).round()})';
        break;
      case 'HSL(A)':
        final hsl = HSLColor.fromColor(_selectedColor);
        colorValue = 'hsl(${hsl.hue.round()}, ${(hsl.saturation * 100).round()}%, ${(hsl.lightness * 100).round()}%)';
        break;
      case 'HSV':
        final hsv = HSVColor.fromColor(_selectedColor);
        colorValue = 'hsv(${hsv.hue.round()}, ${(hsv.saturation * 100).round()}, ${(hsv.value * 100).round()})';
        break;
      default:
        colorValue = '#${_selectedColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
    }
    
    _inputController.text = colorValue;
    _convertUnits(); // 自动执行转换
  }

  /// 颜色格式转换逻辑
  String _convertColor(String input, String fromFormat, String toFormat) {
    if (fromFormat == toFormat) return input;
    
    try {
      // 统一转换策略：先转换为RGB，再转换为目标格式
      List<int> rgb = _parseToRgb(input, fromFormat);
      return _formatFromRgb(rgb, toFormat);
    } catch (e) {
      return 'Invalid color format';
    }
  }

  /// 将任意颜色格式解析为RGB值
  List<int> _parseToRgb(String input, String format) {
    switch (format) {
      case 'HEX':
        return _hexToRgbValues(input);
      case 'RGB(A)':
        return _rgbStringToValues(input);
      case 'HSL(A)':
        return _hslToRgbValues(input);
      case 'HSV':
        return _hsvToRgbValues(input);
      case 'CMYK':
        return _cmykToRgbValues(input);
      default:
        throw Exception('Unsupported format: $format');
    }
  }

  /// 将RGB值格式化为目标格式
  String _formatFromRgb(List<int> rgb, String format) {
    final r = rgb[0], g = rgb[1], b = rgb[2];
    
    switch (format) {
      case 'HEX':
        return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}'.toUpperCase();
      case 'RGB(A)':
        return 'rgb($r, $g, $b)';
      case 'HSL(A)':
        return _rgbToHsl(r, g, b);
      case 'HSV':
        return _rgbToHsv(r, g, b);
      case 'CMYK':
        return _rgbToCmyk(r, g, b);
      default:
        throw Exception('Unsupported format: $format');
    }
  }

  /// 解析RGB字符串为数值
  List<int> _rgbStringToValues(String rgb) {
    final RegExp rgbRegex = RegExp(r'rgb\((\d+),\s*(\d+),\s*(\d+)\)');
    final match = rgbRegex.firstMatch(rgb);
    if (match != null) {
      final r = int.parse(match.group(1)!);
      final g = int.parse(match.group(2)!);
      final b = int.parse(match.group(3)!);
      return [r, g, b];
    }
    throw Exception('Invalid RGB format');
  }

  /// 解析HSL字符串为RGB值
  List<int> _hslToRgbValues(String hsl) {
    final RegExp hslRegex = RegExp(r'hsl\((\d+),\s*(\d+)%,\s*(\d+)%\)');
    final match = hslRegex.firstMatch(hsl);
    if (match != null) {
      final h = int.parse(match.group(1)!) / 360.0;
      final s = int.parse(match.group(2)!) / 100.0;
      final l = int.parse(match.group(3)!) / 100.0;
      return _hslToRgb(h, s, l);
    }
    throw Exception('Invalid HSL format');
  }

  /// HSL转RGB算法
  List<int> _hslToRgb(double h, double s, double l) {
    double r, g, b;

    if (s == 0) {
      r = g = b = l; // 灰色
    } else {
      double hue2rgb(double p, double q, double t) {
        if (t < 0) t += 1;
        if (t > 1) t -= 1;
        if (t < 1/6) return p + (q - p) * 6 * t;
        if (t < 1/2) return q;
        if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
        return p;
      }

      final q = l < 0.5 ? l * (1 + s) : l + s - l * s;
      final p = 2 * l - q;
      r = hue2rgb(p, q, h + 1/3);
      g = hue2rgb(p, q, h);
      b = hue2rgb(p, q, h - 1/3);
    }

    return [(r * 255).round(), (g * 255).round(), (b * 255).round()];
  }

  /// 解析HSV字符串为RGB值
  List<int> _hsvToRgbValues(String hsv) {
    final RegExp hsvRegex = RegExp(r'hsv\((\d+),\s*(\d+),\s*(\d+)\)');
    final match = hsvRegex.firstMatch(hsv);
    if (match != null) {
      final h = int.parse(match.group(1)!) / 360.0;
      final s = int.parse(match.group(2)!) / 100.0;
      final v = int.parse(match.group(3)!) / 100.0;
      return _hsvToRgb(h, s, v);
    }
    throw Exception('Invalid HSV format');
  }

  /// HSV转RGB算法
  List<int> _hsvToRgb(double h, double s, double v) {
    final c = v * s;
    final x = c * (1 - (((h * 6) % 2) - 1).abs());
    final m = v - c;
    
    double r0, g0, b0;
    final hPrime = h * 6;
    
    if (hPrime >= 0 && hPrime < 1) {
      r0 = c; g0 = x; b0 = 0;
    } else if (hPrime >= 1 && hPrime < 2) {
      r0 = x; g0 = c; b0 = 0;
    } else if (hPrime >= 2 && hPrime < 3) {
      r0 = 0; g0 = c; b0 = x;
    } else if (hPrime >= 3 && hPrime < 4) {
      r0 = 0; g0 = x; b0 = c;
    } else if (hPrime >= 4 && hPrime < 5) {
      r0 = x; g0 = 0; b0 = c;
    } else {
      r0 = c; g0 = 0; b0 = x;
    }
    
    return [((r0 + m) * 255).round(), ((g0 + m) * 255).round(), ((b0 + m) * 255).round()];
  }

  /// 解析CMYK字符串为RGB值  
  List<int> _cmykToRgbValues(String cmyk) {
    final RegExp cmykRegex = RegExp(r'cmyk\((\d+),\s*(\d+),\s*(\d+),\s*(\d+)\)');
    final match = cmykRegex.firstMatch(cmyk);
    if (match != null) {
      final c = int.parse(match.group(1)!) / 100.0;
      final m = int.parse(match.group(2)!) / 100.0;
      final y = int.parse(match.group(3)!) / 100.0;
      final k = int.parse(match.group(4)!) / 100.0;
      return _cmykToRgb(c, m, y, k);
    }
    throw Exception('Invalid CMYK format');
  }

  /// CMYK转RGB算法
  List<int> _cmykToRgb(double c, double m, double y, double k) {
    final r = 255 * (1 - c) * (1 - k);
    final g = 255 * (1 - m) * (1 - k);
    final b = 255 * (1 - y) * (1 - k);
    return [r.round(), g.round(), b.round()];
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

  /// RGB转HSV
  String _rgbToHsv(int r, int g, int b) {
    final rNorm = r / 255.0;
    final gNorm = g / 255.0;
    final bNorm = b / 255.0;
    
    final max = [rNorm, gNorm, bNorm].reduce((a, b) => a > b ? a : b);
    final min = [rNorm, gNorm, bNorm].reduce((a, b) => a < b ? a : b);
    final diff = max - min;
    
    // Value
    final v = max;
    
    // Saturation
    final s = max == 0 ? 0.0 : diff / max;
    
    // Hue
    double h;
    if (diff == 0) {
      h = 0;
    } else if (max == rNorm) {
      h = ((gNorm - bNorm) / diff) % 6;
    } else if (max == gNorm) {
      h = (bNorm - rNorm) / diff + 2;
    } else {
      h = (rNorm - gNorm) / diff + 4;
    }
    h *= 60;
    if (h < 0) h += 360;
    
    return 'hsv(${h.round()}, ${(s * 100).round()}, ${(v * 100).round()})';
  }

  /// RGB转CMYK
  String _rgbToCmyk(int r, int g, int b) {
    final rNorm = r / 255.0;
    final gNorm = g / 255.0;
    final bNorm = b / 255.0;
    
    final k = 1 - [rNorm, gNorm, bNorm].reduce((a, b) => a > b ? a : b);
    
    if (k == 1) {
      return 'cmyk(0, 0, 0, 100)';
    }
    
    final c = (1 - rNorm - k) / (1 - k);
    final m = (1 - gNorm - k) / (1 - k);
    final y = (1 - bNorm - k) / (1 - k);
    
    return 'cmyk(${(c * 100).round()}, ${(m * 100).round()}, ${(y * 100).round()}, ${(k * 100).round()})';
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

  /// 获取输入框图标
  IconData _getInputIcon() {
    switch (widget.category.name) {
      case 'Length':
        return Icons.straighten;
      case 'Area':
        return Icons.crop_square;
      case 'Volume':
        return Icons.local_drink;
      case 'Weight':
        return Icons.scale;
      case 'Temperature':
        return Icons.thermostat;
      case 'Storage':
        return Icons.storage;
      case 'Time':
        return Icons.access_time;
      case 'Speed':
        return Icons.speed;
      case 'Color':
        return Icons.palette;
      case 'Currency':
        return Icons.monetization_on;
      case 'Energy':
        return Icons.flash_on;
      case 'Pressure':
        return Icons.compress;
      case 'Angle':
        return Icons.rotate_right;
      default:
        return Icons.calculate;
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          '${widget.category.icon} ${widget.category.name} ${l10n?.converter}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.appBarTheme.foregroundColor ?? theme.colorScheme.onPrimary,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        backgroundColor: widget.category.color,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.category.color,
                widget.category.color.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(widget.category.color),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n!.loading,
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark 
                      ? [
                          theme.scaffoldBackgroundColor,
                          theme.scaffoldBackgroundColor,
                        ]
                      : [
                          widget.category.color.withOpacity(0.05),
                          Colors.white,
                        ],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                    Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.category.color.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _inputController,
                keyboardType: widget.category.name == 'Color' 
                    ? TextInputType.text 
                    : TextInputType.number,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodyLarge?.color,
                ),
                decoration: InputDecoration(
                  labelText: widget.category.name == 'Color' 
                      ? l10n!.enterColorValue
                      : l10n!.enterValueToConvert,
                  labelStyle: TextStyle(
                    color: widget.category.color,
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: widget.category.name == 'Color' 
                      ? _getColorHint() 
                      : l10n!.pleaseEnterValue,
                  hintStyle: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
                  filled: true,
                  fillColor: isDark 
                      ? theme.cardColor 
                      : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: widget.category.color.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: widget.category.color,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, 
                    vertical: 16,
                  ),
                  prefixIcon: Icon(
                    _getInputIcon(),
                    color: widget.category.color,
                  ),
                  suffixIcon: widget.category.name == 'Color' 
                      ? IconButton(
                          icon: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: _selectedColor,
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.palette,
                              size: 16,
                              color: _selectedColor.computeLuminance() > 0.5 
                                  ? Colors.black 
                                  : Colors.white,
                            ),
                          ),
                          onPressed: () => _showColorPicker(context),
                          tooltip: l10n!.pickColor,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDark ? theme.cardColor : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: widget.category.color.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n!.selectUnits,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 600) {
                        // Mobile layout - vertical
                        return Column(
                          children: [
                            _buildStyledDropdown(
                              value: _fromUnit,
                              label: l10n!.from,
                              items: _isCurrencyConversion ? _currencyTypes : widget.category.units,
                              onChanged: (newValue) {
                                setState(() {
                                  _fromUnit = newValue;
                                  if (!_isCurrencyConversion) {
                                    _convert();
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: widget.category.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.swap_vert,
                                  color: widget.category.color,
                                  size: 28,
                                ),
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
                            ),
                            const SizedBox(height: 16),
                            _buildStyledDropdown(
                              value: _toUnit,
                              label: l10n!.to,
                              items: _isCurrencyConversion ? _currencyTypes : widget.category.units,
                              onChanged: (newValue) {
                                setState(() {
                                  _toUnit = newValue;
                                  if (!_isCurrencyConversion) {
                                    _convert();
                                  }
                                });
                              },
                            ),
                          ],
                        );
                      } else {
                        // Desktop layout - horizontal
                        return Row(
                          children: [
                            Expanded(
                              child: _buildStyledDropdown(
                                value: _fromUnit,
                                label: l10n!.from,
                                items: _isCurrencyConversion ? _currencyTypes : widget.category.units,
                                onChanged: (newValue) {
                                  setState(() {
                                    _fromUnit = newValue;
                                    if (!_isCurrencyConversion) {
                                      _convert();
                                    }
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: widget.category.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.swap_horiz,
                                  color: widget.category.color,
                                  size: 28,
                                ),
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
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStyledDropdown(
                                value: _toUnit,
                                label: l10n!.to,
                                items: _isCurrencyConversion ? _currencyTypes : widget.category.units,
                                onChanged: (newValue) {
                                  setState(() {
                                    _toUnit = newValue;
                                    if (!_isCurrencyConversion) {
                                      _convert();
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            // Convert button for all conversions
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: _canConvert 
                          ? [
                              widget.category.color,
                              widget.category.color.withValues(alpha: 0.8),
                            ]
                          : [
                              Colors.grey.shade400,
                              Colors.grey.shade500,
                            ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _canConvert 
                            ? widget.category.color.withValues(alpha: 0.3)
                            : Colors.grey.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _canConvert ? _convert : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _canConvert 
                          ? Colors.transparent
                          : Colors.grey.withValues(alpha: 0.3),
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      l10n!.convert,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _canConvert 
                            ? Colors.white
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDark ? theme.cardColor : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: widget.category.color.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calculate,
                        color: widget.category.color,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n!.result,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.titleMedium?.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.category.color.withOpacity(0.1),
                          widget.category.color.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: widget.category.color.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _result.isEmpty ? l10n!.waitingForInput : _result,
                            style: TextStyle(
                              fontSize: _result.length > 20 ? 20 : 28,
                              fontWeight: FontWeight.bold,
                              color: _result.isEmpty 
                                  ? theme.textTheme.bodyMedium?.color?.withOpacity(0.5)
                                  : widget.category.color,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        if (_isLoading)
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(widget.category.color),
                              strokeWidth: 2,
                            ),
                          )
                        else if (_result.isNotEmpty)
                          Container(
                            decoration: BoxDecoration(
                              color: widget.category.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.copy,
                                color: widget.category.color,
                              ),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: _result));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n!.resultCopied),
                                    backgroundColor: widget.category.color,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 显示汇率更新时间
            if (_isCurrencyConversion && _updateTime.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: widget.category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: widget.category.color,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _updateTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodySmall?.color,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
                ),
              ),
            ),
    );
  }

  Widget _buildStyledDropdown({
    required String? value,
    required String label,
    required dynamic items,
    required ValueChanged<String?> onChanged,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    List<DropdownMenuItem<String>> dropdownItems;
    
    if (items is List<Map<String, String>>) {
      // For currency types
      dropdownItems = items.map<DropdownMenuItem<String>>((currency) {
        return DropdownMenuItem<String>(
          value: currency['value'],
          child: Text(
            currency['value'] ?? '',
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList();
    } else {
      // For regular units
      dropdownItems = (items as List<String>).map((String unit) {
        return DropdownMenuItem<String>(
          value: unit,
          child: Text(
            unit,
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: widget.category.color,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.category.color.withOpacity(0.3),
              width: 1,
            ),
            color: isDark ? theme.cardColor.withOpacity(0.7) : Colors.grey[50],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: widget.category.color,
              ),
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color,
                fontSize: 16,
              ),
              items: dropdownItems,
              onChanged: onChanged,
              dropdownColor: isDark ? theme.cardColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnitDropdown(String? value, ValueChanged<String?> onChanged) {
    final l10n = AppLocalizations.of(context);
    return _buildStyledDropdown(
      value: value,
      label: l10n!.unit,
      items: widget.category.units,
      onChanged: onChanged,
    );
  }

  Widget _buildCurrencyDropdown(String? value, ValueChanged<String?> onChanged) {
    final l10n = AppLocalizations.of(context);
    return _buildStyledDropdown(
      value: value,
      label: l10n!.currency,
      items: _currencyTypes,
      onChanged: onChanged,
    );
  }
}

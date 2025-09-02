
import 'package:convert_ease/models/category_model.dart';
import 'package:convert_ease/services/api_service.dart';
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
  bool _isCurrencyConversion = false;
  List<Map<String, String>> _currencyTypes = [];
  Map<String, double> _exchangeRates = {};
  bool _isLoading = false;

  final ApiService _apiService = ApiService();

  // 简单的转换逻辑，仅作为示例
  final Map<String, double> _conversionFactors = {
    // Length
    'Meters': 1.0,
    'Feet': 0.3048,
    'Inches': 0.0254,
    'Centimeters': 0.01,
    'Yards': 0.9144,
    'Miles': 1609.34,
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
        _exchangeRates = Map<String, double>.from(data['rates']);
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
    final input = double.tryParse(_inputController.text);
    if (input == null || _fromUnit == null || _toUnit == null) {
      setState(() {
        _result = '';
      });
      return;
    }

    // 这里应该是更复杂的转换逻辑
    // 为了演示，我们使用一个简化的模型
    final fromFactor = _conversionFactors[_fromUnit!] ?? 1.0;
    final toFactor = _conversionFactors[_toUnit!] ?? 1.0;

    final valueInMeters = input * fromFactor;
    final convertedValue = valueInMeters / toFactor;

    setState(() {
      _result = convertedValue.toStringAsFixed(4);
    });
  }

  void _convertCurrency() {
    final input = double.tryParse(_inputController.text);
    if (input == null || _fromUnit == null || _toUnit == null || input == 0) {
       setState(() => _result = '');
      return;
    }

    // 使用本地缓存的汇率数据进行转换
    final fromRate = _exchangeRates[_fromUnit!] ?? 1.0;
    final toRate = _exchangeRates[_toUnit!] ?? 1.0;
    
    // 先转换为USD，再转换为目标货币
    final usdValue = input / fromRate;
    final convertedValue = usdValue * toRate;

    setState(() {
      _result = convertedValue.toStringAsFixed(4);
    });
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
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter value to convert',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                  onPressed: _convert,
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
            )
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

import 'dart:ui';

import 'package:flutter/material.dart';
import '../generated/app_localizations.dart';

class Category {
  final String name;
  final String icon;
  final List<String> units;
  final Color color;

  Category({
    required this.name,
    required this.icon,
    required this.units,
    required this.color,
  });

  /// 获取本地化的分类名称
  String getLocalizedName(AppLocalizations l10n) {
    switch (name) {
      case 'Length':
        return l10n.categoryLength;
      case 'Area':
        return l10n.categoryArea;
      case 'Volume':
        return l10n.categoryVolume;
      case 'Weight':
        return l10n.categoryWeight;
      case 'Temperature':
        return l10n.categoryTemperature;
      case 'Storage':
        return l10n.categoryStorage;
      case 'Time':
        return l10n.time;
      case 'Speed':
        return l10n.categorySpeed;
      case 'Color':
        return l10n.categoryColor;
      case 'Currency':
        return l10n.currency;
      case 'Energy':
        return l10n.categoryEnergy;
      case 'Pressure':
        return l10n.categoryPressure;
      case 'Angle':
        return l10n.categoryAngle;
      default:
        return name;
    }
  }
}
List<Category> categories = [
  Category(
    name: 'Length',
    icon: '📏',
    units: ['Meters', 'Feet', 'Inches', 'Centimeters', 'Yards', 'Miles'],
    color: Colors.blue,
  ),
  Category(
    name: 'Area',
    icon: '📐',
    units: ['Square Meters', 'Square Feet', 'Square Inches', 'Acres', 'Hectares'],
    color: Colors.green,
  ),
  Category(
    name: 'Volume',
    icon: '🧪',
    units: ['Liters', 'Gallons', 'Milliliters', 'Cubic Meters', 'Cubic Feet'],
    color: Colors.orange,
  ),
  Category(
    name: 'Weight',
    icon: '⚖️',
    units: ['Kg', 'Pounds', 'Ounces', 'Grams', 'Tons'],
    color: Colors.red,
  ),
  Category(
    name: 'Temperature',
    icon: '🌡️',
    units: ['°C', '°F', 'Kelvin'],
    color: Colors.purple,
  ),
  Category(
    name: 'Storage',
    icon: '💾',
    units: ['bit', 'Byte', 'KB', 'MB', 'GB', 'TB'],
    color: Colors.teal,
  ),
  Category(
    name: 'Time',
    icon: '⏰',
    units: ['Second', 'Minute', 'Hour', 'Day', 'Week', 'Year'],
    color: Colors.indigo,
  ),
  Category(
    name: 'Speed',
    icon: '🚀',
    units: ['m/s', 'km/h', 'mph', 'knot', 'Mach'],
    color: Colors.cyan,
  ),
  Category(
    name: 'Color',
    icon: '🎨',
    units: ['HEX', 'RGB(A)', 'HSL(A)', 'CMYK', 'HSV'],
    color: Colors.pink,
  ),
  Category(
    name: 'Currency',
    icon: '💰',
    units: ['USD', 'EUR', 'JPY', 'GBP', 'CNY'],
    color: Colors.amber,
  ),
  Category(
    name: 'Energy',
    icon: '⚡',
    units: ['Joule', 'Calorie', 'Kilocalorie', 'kWh'],
    color: Colors.deepOrange,
  ),
  Category(
    name: 'Pressure',
    icon: '💨',
    units: ['Pascal', 'Bar', 'PSI', 'Atmosphere'],
    color: Colors.brown,
  ),
  Category(
    name: 'Angle',
    icon: '🧭',
    units: ['Degree', 'Radian', 'Gradian'],
    color: Colors.lightGreen,
  ),
];
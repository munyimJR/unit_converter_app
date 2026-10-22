import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/conversion_service.dart';

/// ConverterProvider holds all UI state for the Unit Converter screen.
/// It extends [ChangeNotifier] so that Provider can push updates to widgets.
class ConverterProvider extends ChangeNotifier {
  // ── Category ─────────────────────────────────────────────────────────────
  ConversionCategory _category = ConversionCategory.length;
  ConversionCategory get category => _category;

  // ── Units available for current category ─────────────────────────────────
  List<UnitModel> get availableUnits => UnitRepository.unitsFor(_category);

  // ── From / To ─────────────────────────────────────────────────────────────
  late UnitModel _fromUnit;
  late UnitModel _toUnit;

  UnitModel get fromUnit => _fromUnit;
  UnitModel get toUnit => _toUnit;

  // ── Input value ───────────────────────────────────────────────────────────
  double? _inputValue;
  double? get inputValue => _inputValue;

  // ── Computed result ───────────────────────────────────────────────────────
  double? _result;
  double? get result => _result;

  // ── Constructor ───────────────────────────────────────────────────────────
  ConverterProvider() {
    _initUnits();
  }

  /// Initialises from/to units to the first two units of the current category.
  void _initUnits() {
    final units = availableUnits;
    _fromUnit = units[0];
    _toUnit = units[1];
  }

  // ── Public Actions ────────────────────────────────────────────────────────

  /// Called when the user taps a category tab.
  void setCategory(ConversionCategory category) {
    if (_category == category) return;
    _category = category;
    _inputValue = null;
    _result = null;
    _initUnits();
    notifyListeners();
  }

  /// Called when the user selects a new "From" unit.
  void setFromUnit(UnitModel unit) {
    if (_fromUnit == unit) return;
    _fromUnit = unit;
    _calculate();
    notifyListeners();
  }

  /// Called when the user selects a new "To" unit.
  void setToUnit(UnitModel unit) {
    if (_toUnit == unit) return;
    _toUnit = unit;
    _calculate();
    notifyListeners();
  }

  /// Called every time the input text field changes.
  void setInputValue(String text) {
    if (text.isEmpty) {
      _inputValue = null;
      _result = null;
      notifyListeners();
      return;
    }
    final parsed = double.tryParse(text);
    _inputValue = parsed;
    _calculate();
    notifyListeners();
  }

  /// Swaps From ↔ To units, then recalculates.
  void swapUnits() {
    final temp = _fromUnit;
    _fromUnit = _toUnit;
    _toUnit = temp;
    _calculate();
    notifyListeners();
  }

  // ── Private Helpers ───────────────────────────────────────────────────────
  void _calculate() {
    if (_inputValue == null) {
      _result = null;
      return;
    }
    _result = ConversionService.convert(
      value: _inputValue!,
      from: _fromUnit,
      to: _toUnit,
      category: _category,
    );
  }

  /// Formats the result for display, stripping unnecessary decimals.
  String get formattedResult {
    if (_result == null) return '—';
    // If the result is a whole number, show without decimal point
    if (_result == _result!.truncateToDouble()) {
      return _result!.toStringAsFixed(0);
    }
    // Otherwise show up to 6 significant decimal digits
    return _result!.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '');
  }
}

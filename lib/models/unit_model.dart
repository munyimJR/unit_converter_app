import 'conversion_category.dart';

/// Represents a single unit (e.g. "Meter", "Kilogram", "Celsius").
class UnitModel {
  final String name;
  final String symbol;
  final ConversionCategory category;

  const UnitModel({
    required this.name,
    required this.symbol,
    required this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          category == other.category;

  @override
  int get hashCode => name.hashCode ^ category.hashCode;

  @override
  String toString() => name;
}

/// Centralised repository of all available units.
class UnitRepository {
  UnitRepository._();

  // ── Length ──────────────────────────────────────────────────────────────────
  static const UnitModel meter = UnitModel(
    name: 'Meter',
    symbol: 'm',
    category: ConversionCategory.length,
  );
  static const UnitModel kilometer = UnitModel(
    name: 'Kilometer',
    symbol: 'km',
    category: ConversionCategory.length,
  );

  // ── Weight ──────────────────────────────────────────────────────────────────
  static const UnitModel gram = UnitModel(
    name: 'Gram',
    symbol: 'g',
    category: ConversionCategory.weight,
  );
  static const UnitModel kilogram = UnitModel(
    name: 'Kilogram',
    symbol: 'kg',
    category: ConversionCategory.weight,
  );

  // ── Temperature ─────────────────────────────────────────────────────────────
  static const UnitModel celsius = UnitModel(
    name: 'Celsius',
    symbol: '°C',
    category: ConversionCategory.temperature,
  );
  static const UnitModel fahrenheit = UnitModel(
    name: 'Fahrenheit',
    symbol: '°F',
    category: ConversionCategory.temperature,
  );

  /// Returns all units for a given [category].
  static List<UnitModel> unitsFor(ConversionCategory category) {
    switch (category) {
      case ConversionCategory.length:
        return [meter, kilometer];
      case ConversionCategory.weight:
        return [gram, kilogram];
      case ConversionCategory.temperature:
        return [celsius, fahrenheit];
    }
  }
}

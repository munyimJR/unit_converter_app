import '../models/models.dart';

/// Contains all unit-conversion logic.
/// Each method accepts a [value] in the [from] unit and returns it in the [to] unit.
class ConversionService {
  ConversionService._();

  // ── Length ──────────────────────────────────────────────────────────────────
  /// Converts [value] between Meter and Kilometer.
  static double convertLength({
    required double value,
    required UnitModel from,
    required UnitModel to,
  }) {
    if (from == to) return value;

    if (from == UnitRepository.meter && to == UnitRepository.kilometer) {
      return value / 1000; // 1 m = 0.001 km
    } else if (from == UnitRepository.kilometer && to == UnitRepository.meter) {
      return value * 1000; // 1 km = 1000 m
    }
    return value;
  }

  // ── Weight ──────────────────────────────────────────────────────────────────
  /// Converts [value] between Gram and Kilogram.
  static double convertWeight({
    required double value,
    required UnitModel from,
    required UnitModel to,
  }) {
    if (from == to) return value;

    if (from == UnitRepository.gram && to == UnitRepository.kilogram) {
      return value / 1000; // 1 g = 0.001 kg
    } else if (from == UnitRepository.kilogram && to == UnitRepository.gram) {
      return value * 1000; // 1 kg = 1000 g
    }
    return value;
  }

  // ── Temperature ─────────────────────────────────────────────────────────────
  /// Converts [value] between Celsius and Fahrenheit.
  static double convertTemperature({
    required double value,
    required UnitModel from,
    required UnitModel to,
  }) {
    if (from == to) return value;

    if (from == UnitRepository.celsius && to == UnitRepository.fahrenheit) {
      return (value * 9 / 5) + 32; // °C → °F
    } else if (from == UnitRepository.fahrenheit &&
        to == UnitRepository.celsius) {
      return (value - 32) * 5 / 9; // °F → °C
    }
    return value;
  }

  // ── Dispatcher ──────────────────────────────────────────────────────────────
  /// Dispatches conversion to the correct method based on [category].
  static double convert({
    required double value,
    required UnitModel from,
    required UnitModel to,
    required ConversionCategory category,
  }) {
    switch (category) {
      case ConversionCategory.length:
        return convertLength(value: value, from: from, to: to);
      case ConversionCategory.weight:
        return convertWeight(value: value, from: from, to: to);
      case ConversionCategory.temperature:
        return convertTemperature(value: value, from: from, to: to);
    }
  }
}

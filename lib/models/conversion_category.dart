/// Enum representing the three supported conversion categories.
enum ConversionCategory { length, weight, temperature }

/// Extension to provide display labels for categories.
extension ConversionCategoryExtension on ConversionCategory {
  String get label {
    switch (this) {
      case ConversionCategory.length:
        return 'Length';
      case ConversionCategory.weight:
        return 'Weight';
      case ConversionCategory.temperature:
        return 'Temp';
    }
  }
}

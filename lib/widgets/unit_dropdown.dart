import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../models/models.dart';

/// A labelled dropdown for selecting a unit from [units].
class UnitDropdown extends StatelessWidget {
  final String label;
  final UnitModel selectedUnit;
  final List<UnitModel> units;
  final ValueChanged<UnitModel?> onChanged;

  const UnitDropdown({
    super.key,
    required this.label,
    required this.selectedUnit,
    required this.units,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.inputLabel),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderColor),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<UnitModel>(
              value: selectedUnit,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textMedium,
                size: 22,
              ),
              style: AppTextStyles.dropdownValue,
              dropdownColor: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              items: units.map((unit) {
                return DropdownMenuItem<UnitModel>(
                  value: unit,
                  child: Text(unit.name),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

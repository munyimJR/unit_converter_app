import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../models/models.dart';

/// A row of tabs for switching between conversion categories.
class CategoryTabBar extends StatelessWidget {
  final ConversionCategory selected;
  final ValueChanged<ConversionCategory> onCategoryChanged;

  const CategoryTabBar({
    super.key,
    required this.selected,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: ConversionCategory.values.map((category) {
          final isSelected = category == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onCategoryChanged(category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.tabActive
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  category.label,
                  style: AppTextStyles.tabLabel.copyWith(
                    color: isSelected ? Colors.white : AppColors.primaryBlue,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

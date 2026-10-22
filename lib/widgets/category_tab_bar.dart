import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../models/models.dart';

/// A polished tab bar with a sliding animated pill indicator.
/// Uses [LayoutBuilder] to precisely position the pill under the active tab.
class CategoryTabBar extends StatefulWidget {
  final ConversionCategory selected;
  final ValueChanged<ConversionCategory> onCategoryChanged;

  const CategoryTabBar({
    super.key,
    required this.selected,
    required this.onCategoryChanged,
  });

  @override
  State<CategoryTabBar> createState() => _CategoryTabBarState();
}

class _CategoryTabBarState extends State<CategoryTabBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _labelFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0,
    );
    _labelFade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(CategoryTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      // Quick flash of the label when tab changes
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ConversionCategory.values;
    final selectedIndex = categories.indexOf(widget.selected);

    return LayoutBuilder(
      builder: (context, constraints) {
        final tabWidth = (constraints.maxWidth - 8) / categories.length;
        final pillLeft = 4.0 + selectedIndex * tabWidth;

        return Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withValues(alpha: 0.10),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // ── Sliding pill ────────────────────────────────────────────────
              AnimatedPositioned(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeInOutCubic,
                left: pillLeft,
                top: 4,
                bottom: 4,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF448AFF), Color(0xFF2962FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withValues(alpha: 0.30),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              // ── Labels ──────────────────────────────────────────────────────
              Row(
                children: categories.map((category) {
                  final isSelected = category == widget.selected;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => widget.onCategoryChanged(category),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        style: AppTextStyles.tabLabel.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.primaryBlue.withValues(alpha: 0.65),
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                        child: Center(
                          child: FadeTransition(
                            opacity: isSelected ? _labelFade : const AlwaysStoppedAnimation(1.0),
                            child: Text(category.label),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

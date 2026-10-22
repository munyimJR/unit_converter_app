import 'package:flutter/material.dart';
import '../../constants/constants.dart';

/// Displays the conversion result with a fast fade crossfade on change.
class ResultCard extends StatelessWidget {
  final String resultValue;
  final String unitSymbol;

  const ResultCard({
    super.key,
    required this.resultValue,
    required this.unitSymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Result:', style: AppTextStyles.resultLabel),
          const SizedBox(height: 12),
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              child: RichText(
                key: ValueKey('$resultValue|$unitSymbol'),
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: resultValue,
                      style: AppTextStyles.resultValue,
                    ),
                    if (resultValue != '—') ...[
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: unitSymbol,
                        style: AppTextStyles.resultUnit,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

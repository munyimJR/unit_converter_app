import 'package:flutter/material.dart';
import '../../constants/constants.dart';

/// Displays the conversion result with a smooth scale+fade spring animation.
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.08),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 6),
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
              duration: const Duration(milliseconds: 380),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                // Scale spring + simultaneous fade
                final scaleTween = Tween<double>(begin: 0.72, end: 1.0)
                    .chain(CurveTween(curve: Curves.elasticOut));
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                  ),
                  child: ScaleTransition(
                    scale: animation.drive(scaleTween),
                    child: child,
                  ),
                );
              },
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    ...previousChildren,
                    ?currentChild,
                  ],
                );
              },
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/constants.dart';

/// A labelled numeric input field with an animated focus-glow border.
class ValueInputField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const ValueInputField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<ValueInputField> createState() => _ValueInputFieldState();
}

class _ValueInputFieldState extends State<ValueInputField>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  late final AnimationController _glowController;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _glow = CurvedAnimation(parent: _glowController, curve: Curves.easeInOut);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _glowController.forward();
      } else {
        _glowController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Enter Value', style: AppTextStyles.inputLabel),
        const SizedBox(height: 6),
        AnimatedBuilder(
          animation: _glow,
          builder: (_, child) => Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color.lerp(
                  AppColors.borderColor,
                  AppColors.primaryBlue,
                  _glow.value,
                )!,
                width: 1.0 + _glow.value * 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue
                      .withValues(alpha: 0.05 + _glow.value * 0.10),
                  blurRadius: 8 + _glow.value * 8,
                  spreadRadius: _glow.value * 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: child,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            onChanged: widget.onChanged,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
            ],
            style: AppTextStyles.inputValue,
            decoration: const InputDecoration(
              hintText: 'e.g. 25',
              hintStyle: AppTextStyles.hintText,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/constants.dart';

/// Swap button with a rotation + scale-bounce + haptic feedback animation.
/// Uses two controllers: one for spin, one for the press-scale bounce.
class SwapButton extends StatefulWidget {
  final VoidCallback onTap;

  const SwapButton({super.key, required this.onTap});

  @override
  State<SwapButton> createState() => _SwapButtonState();
}

class _SwapButtonState extends State<SwapButton>
    with TickerProviderStateMixin {
  // ── Spin ─────────────────────────────────────────────────────────────────
  late final AnimationController _spinController;
  late final Animation<double> _spin;

  // ── Scale bounce ─────────────────────────────────────────────────────────
  late final AnimationController _scaleController;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _spin = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _spinController, curve: Curves.easeInOutBack),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );
    // Press-in → small → spring back > 1 → settle at 1
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.82)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.82, end: 1.12)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.12, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 25,
      ),
    ]).animate(_scaleController);
  }

  @override
  void dispose() {
    _spinController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    HapticFeedback.lightImpact();
    widget.onTap();
    _spinController.forward(from: 0);
    await _scaleController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_spin, _scale]),
        builder: (_, child) => Transform.scale(
          scale: _scale.value,
          child: Transform.rotate(
            angle: _spin.value * 3.14159,
            child: child,
          ),
        ),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF448AFF), Color(0xFF2962FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withValues(alpha: 0.40),
                blurRadius: 14,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.swap_horiz_rounded,
            color: Colors.white,
            size: 27,
          ),
        ),
      ),
    );
  }
}

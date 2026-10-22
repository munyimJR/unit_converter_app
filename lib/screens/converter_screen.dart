import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../providers/converter_provider.dart';
import '../widgets/widgets.dart';

/// The main Unit Converter screen.
/// Animates each section in on first build and cross-fades the content
/// area when the user switches categories.
class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();

  // Staggered entry controller – animates items in from the bottom on launch
  late final AnimationController _entryController;
  late final List<Animation<double>> _entryFades;
  late final List<Animation<Offset>> _entrySlides;

  // How many staggered sections we have
  static const int _sectionCount = 5; // tab, input, from, to, result

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Build per-section fade + slide with increasing delays
    _entryFades = List.generate(_sectionCount, (i) {
      final start = i * 0.12;
      final end = (start + 0.45).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _entryController,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    });

    _entrySlides = List.generate(_sectionCount, (i) {
      final start = i * 0.12;
      final end = (start + 0.45).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.25),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    // Start entry animation after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entryController.forward();
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  // Wraps a widget with the staggered entry animation for [sectionIndex]
  Widget _animated(int index, Widget child) {
    return FadeTransition(
      opacity: _entryFades[index],
      child: SlideTransition(
        position: _entrySlides[index],
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: _buildAppBar(),
      body: Consumer<ConverterProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 0: Category tabs ─────────────────────────────────────────
                _animated(
                  0,
                  CategoryTabBar(
                    selected: provider.category,
                    onCategoryChanged: (cat) {
                      provider.setCategory(cat);
                      _inputController.clear();
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // ── 1–4: Content cross-fades when category changes ───────────
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 340),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.04, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: _buildForm(provider),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Builds the input + dropdowns + result column.
  /// Keyed on [category] so AnimatedSwitcher fires on every tab switch.
  Widget _buildForm(ConverterProvider provider) {
    return KeyedSubtree(
      key: ValueKey(provider.category),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1: Value input ─────────────────────────────────────────────────
          _animated(
            1,
            ValueInputField(
              controller: _inputController,
              onChanged: provider.setInputValue,
            ),
          ),

          const SizedBox(height: 20),

          // ── 2: From dropdown ───────────────────────────────────────────────
          _animated(
            2,
            UnitDropdown(
              label: 'From',
              selectedUnit: provider.fromUnit,
              units: provider.availableUnits,
              onChanged: (unit) {
                if (unit != null) provider.setFromUnit(unit);
              },
            ),
          ),

          const SizedBox(height: 8),

          // ── Swap button ────────────────────────────────────────────────────
          Center(child: SwapButton(onTap: provider.swapUnits)),

          const SizedBox(height: 8),

          // ── 3: To dropdown ─────────────────────────────────────────────────
          _animated(
            3,
            UnitDropdown(
              label: 'To',
              selectedUnit: provider.toUnit,
              units: provider.availableUnits,
              onChanged: (unit) {
                if (unit != null) provider.setToUnit(unit);
              },
            ),
          ),

          const SizedBox(height: 24),

          // ── 4: Result card ─────────────────────────────────────────────────
          _animated(
            4,
            ResultCard(
              resultValue: provider.formattedResult,
              unitSymbol: provider.toUnit.symbol,
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryBlue,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () {},
      ),
      title: const Text('Unit Converter', style: AppTextStyles.appBarTitle),
    );
  }
}

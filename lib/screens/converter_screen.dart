import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/models.dart';
import '../providers/converter_provider.dart';
import '../widgets/widgets.dart';

/// Main Unit Converter screen.
/// Uses [Selector] so only the result card rebuilds on every keystroke —
/// the rest of the layout rebuilds only when category/units change.
class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Category tabs — rebuilds only when category changes ──────────
            Selector<ConverterProvider, ConversionCategory>(
              selector: (_, p) => p.category,
              builder: (_, category, _) => CategoryTabBar(
                selected: category,
                onCategoryChanged: (cat) {
                  context.read<ConverterProvider>().setCategory(cat);
                  _inputController.clear();
                },
              ),
            ),

            const SizedBox(height: 24),

            // ── Input field — never rebuilt by provider (owns its own state) ─
            ValueInputField(
              controller: _inputController,
              onChanged: (v) => context.read<ConverterProvider>().setInputValue(v),
            ),

            const SizedBox(height: 20),

            // ── From dropdown — rebuilds when from-unit changes ──────────────
            Selector<ConverterProvider, _DropdownState>(
              selector: (_, p) => _DropdownState(p.fromUnit, p.availableUnits),
              builder: (_, state, _) => UnitDropdown(
                label: 'From',
                selectedUnit: state.selected,
                units: state.units,
                onChanged: (unit) {
                  if (unit != null) context.read<ConverterProvider>().setFromUnit(unit);
                },
              ),
            ),

            const SizedBox(height: 8),

            // ── Swap button — reads nothing from provider directly ───────────
            Center(
              child: SwapButton(
                onTap: () => context.read<ConverterProvider>().swapUnits(),
              ),
            ),

            const SizedBox(height: 8),

            // ── To dropdown — rebuilds when to-unit changes ──────────────────
            Selector<ConverterProvider, _DropdownState>(
              selector: (_, p) => _DropdownState(p.toUnit, p.availableUnits),
              builder: (_, state, _) => UnitDropdown(
                label: 'To',
                selectedUnit: state.selected,
                units: state.units,
                onChanged: (unit) {
                  if (unit != null) context.read<ConverterProvider>().setToUnit(unit);
                },
              ),
            ),

            const SizedBox(height: 24),

            // ── Result card — rebuilds only when result/symbol changes ────────
            Selector<ConverterProvider, _ResultState>(
              selector: (_, p) => _ResultState(p.formattedResult, p.toUnit.symbol),
              builder: (_, state, _) => ResultCard(
                resultValue: state.value,
                unitSymbol: state.symbol,
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
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

// ── Private data classes for Selector equality checks ─────────────────────────

class _DropdownState {
  final UnitModel selected;
  final List<UnitModel> units;
  const _DropdownState(this.selected, this.units);

  @override
  bool operator ==(Object other) =>
      other is _DropdownState &&
      selected == other.selected &&
      units.length == other.units.length;

  @override
  int get hashCode => selected.hashCode ^ units.length;
}

class _ResultState {
  final String value;
  final String symbol;
  const _ResultState(this.value, this.symbol);

  @override
  bool operator ==(Object other) =>
      other is _ResultState && value == other.value && symbol == other.symbol;

  @override
  int get hashCode => value.hashCode ^ symbol.hashCode;
}

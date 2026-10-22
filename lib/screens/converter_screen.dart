import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../providers/converter_provider.dart';
import '../widgets/widgets.dart';

/// The main Unit Converter screen.
/// It reads state from [ConverterProvider] and delegates rendering
/// to reusable widget components.
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
      body: Consumer<ConverterProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Category tabs ────────────────────────────────────────────
                CategoryTabBar(
                  selected: provider.category,
                  onCategoryChanged: (cat) {
                    provider.setCategory(cat);
                    // Clear the text field when switching categories
                    _inputController.clear();
                  },
                ),

                const SizedBox(height: 24),

                // ── Value input ──────────────────────────────────────────────
                ValueInputField(
                  controller: _inputController,
                  onChanged: provider.setInputValue,
                ),

                const SizedBox(height: 20),

                // ── From dropdown ────────────────────────────────────────────
                UnitDropdown(
                  label: 'From',
                  selectedUnit: provider.fromUnit,
                  units: provider.availableUnits,
                  onChanged: (unit) {
                    if (unit != null) provider.setFromUnit(unit);
                  },
                ),

                const SizedBox(height: 8),

                // ── Swap button (centred between From and To) ─────────────────
                Center(
                  child: SwapButton(onTap: provider.swapUnits),
                ),

                const SizedBox(height: 8),

                // ── To dropdown ──────────────────────────────────────────────
                UnitDropdown(
                  label: 'To',
                  selectedUnit: provider.toUnit,
                  units: provider.availableUnits,
                  onChanged: (unit) {
                    if (unit != null) provider.setToUnit(unit);
                  },
                ),

                const SizedBox(height: 24),

                // ── Result card ──────────────────────────────────────────────
                ResultCard(
                  resultValue: provider.formattedResult,
                  unitSymbol: provider.toUnit.symbol,
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
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

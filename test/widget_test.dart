import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:unit_converter_app/main.dart';
import 'package:unit_converter_app/providers/converter_provider.dart';
import 'package:unit_converter_app/screens/converter_screen.dart';

void main() {
  testWidgets('Unit Converter app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const UnitConverterApp());
    await tester.pumpAndSettle();

    // Verify AppBar title is present
    expect(find.text('Unit Converter'), findsOneWidget);

    // Verify the three tabs exist
    expect(find.text('Length'), findsOneWidget);
    expect(find.text('Weight'), findsOneWidget);
    expect(find.text('Temp'), findsOneWidget);
  });

  testWidgets('Category switching updates dropdowns', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ConverterProvider(),
        child: const MaterialApp(home: ConverterScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Switch to Weight tab
    await tester.tap(find.text('Weight'));
    await tester.pumpAndSettle();

    // Gram and Kilogram units should be visible in the dropdowns
    expect(find.text('Gram'), findsWidgets);
  });
}

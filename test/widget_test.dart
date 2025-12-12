import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_mastery/main.dart';

void main() {
  testWidgets('Provider shows today date and refreshes', (tester) async {
    // Pump app
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    final today = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

    // Verify text
    expect(find.text('Today is $today'), findsOneWidget);

    // Tap refresh button
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump(); // rebuilds
    // (date unchanged unless day rolled over)
    expect(find.text('Today is $today'), findsOneWidget);
  });
}
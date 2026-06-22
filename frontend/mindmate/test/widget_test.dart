import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindmate/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MindMateApp(hasSession: false));

    // Verify that MaterialApp is built.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

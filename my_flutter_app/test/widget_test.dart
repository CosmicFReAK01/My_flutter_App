// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:laundry_mate/main.dart';

void main() {
  testWidgets('LaundryVendorApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LaundryVendorApp());

    // Verify that role selection screen is displayed
    expect(find.text('Laundry Service'), findsOneWidget);
    expect(find.text('Choose your role to continue'), findsOneWidget);
    expect(find.text('Customer'), findsOneWidget);
    expect(find.text('Service Provider'), findsOneWidget);
  });

  testWidgets('Navigation items test', (WidgetTester tester) async {
    await tester.pumpWidget(const LaundryVendorApp());

    // Verify role selection buttons are present
    expect(find.text('Customer'), findsOneWidget);
    expect(find.text('Service Provider'), findsOneWidget);
  });

  testWidgets('Role selection test', (WidgetTester tester) async {
    await tester.pumpWidget(const LaundryVendorApp());

    // Verify role selection elements are present
    expect(find.byIcon(Icons.local_laundry_service), findsOneWidget);
    expect(find.text('Already have an account? Log in'), findsOneWidget);
  });
}

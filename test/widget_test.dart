import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:study_quiz/main.dart';

void main() {
  testWidgets('App boots without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const StudyBuddyApp());
    // Verify the app renders — detailed widget tests to be added per feature
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

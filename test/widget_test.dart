import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/main.dart';

void main() {
  testWidgets('Quiz app launches', (WidgetTester tester) async {
    await tester.pumpWidget(const QuizApp());
    expect(find.text('Quiz Challenge'), findsOneWidget);
  });
}

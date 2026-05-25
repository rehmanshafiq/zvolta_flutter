import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zvolta_flutter/presentation/widgets/app_loading_indicator.dart';

void main() {
  testWidgets('AppLoadingIndicator renders message', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppLoadingIndicator(message: 'Loading...'),
        ),
      ),
    );

    expect(find.text('Loading...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}

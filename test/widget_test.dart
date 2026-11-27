import 'package:flutter_test/flutter_test.dart';
import 'package:gaziz_6_week/main.dart';

void main() {
  testWidgets('SmartGreen app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartGreenApp());
    expect(find.byType(SmartGreenApp), findsOneWidget);
  });
}

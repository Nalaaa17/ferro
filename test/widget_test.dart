import 'package:flutter_test/flutter_test.dart';
import 'package:ferro/main.dart';

void main() {
  testWidgets('FerroApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FerroApp());
    expect(find.text('FERRO'), findsWidgets);
  });
}

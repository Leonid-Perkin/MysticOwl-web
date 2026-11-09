import 'package:flutter_test/flutter_test.dart';
import 'package:tarot_flutter/main.dart';

void main() {
  testWidgets('MysticOwlApp renders spreads catalog', (WidgetTester tester) async {
    await tester.pumpWidget(const MysticOwlApp());
    expect(find.textContaining('MYSTICOWL'), findsOneWidget);
    expect(find.text('Карта Дня'), findsOneWidget);
    expect(find.text('Кельтский Крест'), findsOneWidget);
  });
}

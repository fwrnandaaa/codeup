import 'package:flutter_test/flutter_test.dart';

import 'package:code_up/main.dart';

void main() {
  testWidgets('Splash -> Login -> Principal', (WidgetTester tester) async {
    await tester.pumpWidget(const CodeUpApp());

    expect(find.text('Começar'), findsOneWidget);
    await tester.tap(find.text('Começar'));
    await tester.pumpAndSettle();

    expect(find.text('Entrar'), findsOneWidget);
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('Olá, Juliana!'), findsOneWidget);
    expect(find.text('Trilhas'), findsOneWidget); // BottomNavigationBar
  });
}
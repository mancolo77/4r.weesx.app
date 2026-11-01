import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fr_weesx/screens/main_navigation_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MainNavigationScreen displays 3 tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainNavigationScreen(),
      ),
    );
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);
    expect(find.text('My Teams'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisater_mobile/modules/offline/pages/offline_home_page.dart';

void main() {
  group('OfflineHomePage Widget Tests', () {
    testWidgets('should display offline indicator in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: OfflineHomePage(),
        ),
      );

      // Check if the app bar contains the offline indicator
      expect(find.text('SISATER - Modo Offline'), findsOneWidget);
      expect(find.text('OFFLINE'), findsOneWidget);
    });

    testWidgets('should display offline mode title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: OfflineHomePage(),
        ),
      );

      // Check if the offline mode title is displayed
      expect(find.text('Modo Offline Ativo'), findsOneWidget);
    });

    testWidgets('should display offline mode header', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: OfflineHomePage(),
        ),
      );

      // Check if the offline mode header is displayed
      expect(find.text('Modo Offline Ativo'), findsOneWidget);
      expect(find.text('O aplicativo está funcionando offline. Os dados serão sincronizados quando a conexão for restaurada.'), findsOneWidget);
    });

    testWidgets('should display FATER menu option', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: OfflineHomePage(),
        ),
      );

      // Check if the FATER menu option is displayed
      expect(find.text('FATER - Cadastrar Beneficiário'), findsOneWidget);
    });

    testWidgets('should display connectivity check button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: OfflineHomePage(),
        ),
      );

      // Check if the connectivity check button is displayed
      expect(find.text('Verificar Conexão'), findsOneWidget);
    });

    testWidgets('should have proper layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: OfflineHomePage(),
        ),
      );

      // Check if the basic structure is present
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}

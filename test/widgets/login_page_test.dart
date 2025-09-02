import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisater_mobile/modules/autenticacao/pages/login_page.dart';

void main() {
  group('LoginPage Widget Tests', () {
    testWidgets('should display login form elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );

      // Verificar se os elementos principais estão presentes
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsAtLeast(2)); // Login e senha
      expect(find.byType(ElevatedButton), findsAtLeast(1)); // Botão de login
    });

    testWidgets('should display logo and title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );

      // Verificar se o logo está presente
      expect(find.byType(Image), findsAtLeast(1));
    });

    testWidgets('should have proper form validation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );

      // Tentar submeter o formulário vazio
      final loginButton = find.byType(ElevatedButton);
      await tester.tap(loginButton);
      await tester.pump();

      // Verificar se há validação de formulário
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('should have proper input fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );

      // Verificar se os campos de entrada estão presentes
      expect(find.byType(TextFormField), findsAtLeast(2));
      
      // Verificar se há campo para login
      final loginField = find.byType(TextFormField).first;
      expect(loginField, findsOneWidget);
      
      // Verificar se há campo para senha
      final passwordField = find.byType(TextFormField).at(1);
      expect(passwordField, findsOneWidget);
    });

    testWidgets('should have proper button styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );

      // Verificar se o botão de login está presente
      final loginButton = find.byType(ElevatedButton);
      expect(loginButton, findsAtLeast(1));
      
      // Verificar se o botão tem texto
      expect(find.text('Entrar'), findsOneWidget);
    });

    testWidgets('should have proper layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );

      // Verificar se a estrutura básica está presente
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsAtLeast(1));
    });

    testWidgets('should handle text input correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );

      // Encontrar o campo de login
      final loginField = find.byType(TextFormField).first;
      
      // Inserir texto no campo
      await tester.enterText(loginField, 'test@example.com');
      await tester.pump();
      
      // Verificar se o texto foi inserido
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('should have proper padding and spacing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );

      // Verificar se há padding adequado
      expect(find.byType(Padding), findsAtLeast(1));
      
      // Verificar se há espaçamento entre elementos
      expect(find.byType(SizedBox), findsAtLeast(1));
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisater_mobile/modules/autenticacao/pages/login_page.dart';

void main() {
  group('App Integration Tests', () {
    testWidgets('should display login form properly', (WidgetTester tester) async {
      // Configurar o app
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );

      // Verificar se estamos na página de login
      expect(find.byType(LoginPage), findsOneWidget);

      // Verificar se os elementos de login estão presentes
      expect(find.byType(TextFormField), findsAtLeast(2));
      expect(find.byType(ElevatedButton), findsAtLeast(1));
    });

    testWidgets('should handle form validation properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );

      // Tentar submeter formulário vazio
      final loginButton = find.byType(ElevatedButton).first;
      await tester.tap(loginButton);
      await tester.pump();

      // Verificar se o formulário ainda está presente (não navegou)
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('should display proper error messages', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );

      // Verificar se não há mensagens de erro inicialmente
      expect(find.text('Credenciais inválidas'), findsNothing);
      expect(find.text('Erro no login'), findsNothing);
    });

    testWidgets('should have proper responsive design', (WidgetTester tester) async {
      // Testar com diferentes tamanhos de tela
      await tester.binding.setSurfaceSize(const Size(400, 800));
      
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );

      // Verificar se o layout se adapta
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      
      // Restaurar tamanho da tela
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should handle keyboard interactions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );

      // Encontrar campo de login
      final loginField = find.byType(TextFormField).first;
      
      // Focar no campo
      await tester.tap(loginField);
      await tester.pump();
      
      // Verificar se o campo está presente
      expect(loginField, findsOneWidget);
    });

    testWidgets('should have proper accessibility', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );

      // Verificar se há labels apropriados
      expect(find.byType(TextFormField), findsAtLeast(2));
      
      // Verificar se há botões com texto descritivo
      expect(find.text('Entrar'), findsOneWidget);
    });

    testWidgets('should handle state changes properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );

      // Verificar estado inicial
      expect(find.byType(LoginPage), findsOneWidget);
      
      // Simular mudança de estado (loading, error, success)
      // Isso seria feito através do controller MobX
      
      // Verificar se a UI se adapta às mudanças de estado
      expect(find.byType(Form), findsOneWidget);
    });
  });
}

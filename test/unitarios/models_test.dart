import 'package:flutter_test/flutter_test.dart';
import 'package:sisater_mobile/models/autenticacao/login_response.dart';
import 'package:sisater_mobile/models/autenticacao/usuario_dados.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/municipio.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/comunidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/unidade_medida.dart';

void main() {
  group('LoginResponse Tests', () {
    test('should create LoginResponse with all fields', () {
      final loginResponse = LoginResponse(
        accessToken: 'test_token',
        tokenType: 'Bearer',
        expiresIn: 3600,
        refreshToken: 'refresh_token',
        scope: 'test_scope',
      );

      expect(loginResponse.accessToken, 'test_token');
      expect(loginResponse.tokenType, 'Bearer');
      expect(loginResponse.expiresIn, 3600);
      expect(loginResponse.refreshToken, 'refresh_token');
      expect(loginResponse.scope, 'test_scope');
    });

    test('should convert LoginResponse to JSON and back', () {
      final original = LoginResponse(
        accessToken: 'test_token',
        tokenType: 'Bearer',
        expiresIn: 3600,
        refreshToken: 'refresh_token',
        scope: 'test_scope',
      );

      final json = original.toJson();
      final restored = LoginResponse.fromJson(json);

      expect(restored.accessToken, equals(original.accessToken));
      expect(restored.tokenType, equals(original.tokenType));
      expect(restored.expiresIn, equals(original.expiresIn));
      expect(restored.refreshToken, equals(original.refreshToken));
      expect(restored.scope, equals(original.scope));
    });

    test('should handle null values in JSON', () {
      final json = {
        'accessToken': 'test_token',
        'tokenType': 'Bearer',
        'expiresIn': 3600,
        'refreshToken': null,
        'scope': null,
      };

      final loginResponse = LoginResponse.fromJson(json);
      expect(loginResponse.accessToken, 'test_token');
      expect(loginResponse.tokenType, 'Bearer');
      expect(loginResponse.expiresIn, 3600);
      expect(loginResponse.refreshToken, isNull);
      expect(loginResponse.scope, isNull);
    });
  });

  group('UsuarioDados Tests', () {
    test('should create UsuarioDados with all fields', () {
      final usuario = UsuarioDados(
        id: 1,
        name: 'Test User',
        document: '123.456.789-00',
        officeName: 'Test Office',
        perfil: 'admin',
      );

      expect(usuario.id, 1);
      expect(usuario.name, 'Test User');
      expect(usuario.document, '123.456.789-00');
      expect(usuario.officeName, 'Test Office');
      expect(usuario.perfil, 'admin');
    });

    test('should convert UsuarioDados to JSON and back', () {
      final original = UsuarioDados(
        id: 1,
        name: 'Test User',
        document: '123.456.789-00',
        officeName: 'Test Office',
        perfil: 'admin',
      );

      final json = original.toJson();
      final restored = UsuarioDados.fromJson(json);

      expect(restored.id, equals(original.id));
      expect(restored.name, equals(original.name));
      expect(restored.document, equals(original.document));
      expect(restored.officeName, equals(original.officeName));
      expect(restored.perfil, equals(original.perfil));
    });
  });

  group('Municipio Tests', () {
    test('should create Municipio with all fields', () {
      final municipio = Municipio(
        code: '12345',
        name: 'Test City',
        ufCode: 'SP',
      );

      expect(municipio.code, '12345');
      expect(municipio.name, 'Test City');
      expect(municipio.ufCode, 'SP');
    });

    test('should convert Municipio to JSON and back', () {
      final original = Municipio(
        code: '12345',
        name: 'Test City',
        ufCode: 'SP',
      );

      final json = original.toJson();
      final restored = Municipio.fromJson(json);

      expect(restored.code, equals(original.code));
      expect(restored.name, equals(original.name));
      expect(restored.ufCode, equals(original.ufCode));
    });
  });

  group('Comunidade Tests', () {
    test('should create Comunidade with all fields', () {
      final comunidade = Comunidade(
        id: 1,
        name: 'Test Community',
        cityCode: '12345',
      );

      expect(comunidade.id, 1);
      expect(comunidade.name, 'Test Community');
      expect(comunidade.cityCode, '12345');
    });

    test('should convert Comunidade to JSON and back', () {
      final original = Comunidade(
        id: 1,
        name: 'Test Community',
        cityCode: '12345',
      );

      final json = original.toJson();
      final restored = Comunidade.fromJson(json);

      expect(restored.id, equals(original.id));
      expect(restored.name, equals(original.name));
      expect(restored.cityCode, equals(original.cityCode));
    });
  });

  group('UnidadeMedida Tests', () {
    test('should create UnidadeMedida with all fields', () {
      final unidade = UnidadeMedida(
        id: 1,
        name: 'kg',
      );

      expect(unidade.id, 1);
      expect(unidade.name, 'kg');
    });

    test('should convert UnidadeMedida to JSON and back', () {
      final original = UnidadeMedida(
        id: 1,
        name: 'kg',
      );

      final json = original.toJson();
      final restored = UnidadeMedida.fromJson(json);

      expect(restored.id, equals(original.id));
      expect(restored.name, equals(original.name));
    });
  });

  group('BeneficiarioAter Tests', () {
    test('should create BeneficiarioAter with all fields', () {
      final beneficiario = BeneficiarioAter(
        id: 1,
        name: 'Test Beneficiary',
        document: '123.456.789-00',
        communityId: 1,
        officeId: 1,
      );

      expect(beneficiario.id, 1);
      expect(beneficiario.name, 'Test Beneficiary');
      expect(beneficiario.document, '123.456.789-00');
      expect(beneficiario.communityId, 1);
      expect(beneficiario.officeId, 1);
    });

    test('should convert BeneficiarioAter to JSON and back', () {
      final original = BeneficiarioAter(
        id: 1,
        name: 'Test Beneficiary',
        document: '123.456.789-00',
        communityId: 1,
        officeId: 1,
      );

      final json = original.toJson();
      final restored = BeneficiarioAter.fromJson(json);

      expect(restored.id, equals(original.id));
      expect(restored.name, equals(original.name));
      expect(restored.document, equals(original.document));
      expect(restored.communityId, equals(original.communityId));
      expect(restored.officeId, equals(original.officeId));
    });
  });
}

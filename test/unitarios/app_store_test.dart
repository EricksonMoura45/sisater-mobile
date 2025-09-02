import 'package:flutter_test/flutter_test.dart';
import 'package:sisater_mobile/models/offline/offline_data.dart';
import 'package:sisater_mobile/models/offline/offline_beneficiario_fater.dart';

void main() {
  group('Offline Models Tests', () {
    test('OfflineData should create and serialize correctly', () {
      final testData = OfflineData(
        municipios: ['Municipio 1', 'Municipio 2'],
        eslocs: ['ESLOC 1', 'ESLOC 2'],
        produtos: ['Produto 1', 'Produto 2'],
        metodos: ['Metodo 1', 'Metodo 2'],
        finalidadesAtendimento: ['Finalidade 1', 'Finalidade 2'],
        tecnicas: ['Tecnica 1', 'Tecnica 2'],
        politicas: ['Politica 1', 'Politica 2'],
        tecnicosEmater: ['Tecnico 1', 'Tecnico 2'],
        proater: ['Proater 1', 'Proater 2'],
        unidadesMedida: ['Unidade 1', 'Unidade 2'],
        lastUpdate: DateTime(2024, 1, 1),
      );
      
      expect(testData.municipios, hasLength(2));
      expect(testData.municipios, contains('Municipio 1'));
      expect(testData.eslocs, hasLength(2));
      expect(testData.produtos, hasLength(2));
      expect(testData.metodos, hasLength(2));
      expect(testData.finalidadesAtendimento, hasLength(2));
      expect(testData.tecnicas, hasLength(2));
      expect(testData.politicas, hasLength(2));
      expect(testData.tecnicosEmater, hasLength(2));
      expect(testData.proater, hasLength(2));
      expect(testData.unidadesMedida, hasLength(2));
      expect(testData.lastUpdate, DateTime(2024, 1, 1));
    });

    test('OfflineData should convert to JSON and back', () {
      final originalData = OfflineData(
        municipios: ['Municipio 1'],
        eslocs: ['ESLOC 1'],
        produtos: ['Produto 1'],
        metodos: ['Metodo 1'],
        finalidadesAtendimento: ['Finalidade 1'],
        tecnicas: ['Tecnica 1'],
        politicas: ['Politica 1'],
        tecnicosEmater: ['Tecnico 1'],
        proater: ['Proater 1'],
        unidadesMedida: ['Unidade 1'],
        lastUpdate: DateTime(2024, 1, 1),
      );
      
      final json = originalData.toJson();
      expect(json['municipios'], contains('Municipio 1'));
      expect(json['eslocs'], contains('ESLOC 1'));
      expect(json['produtos'], contains('Produto 1'));
      expect(json['metodos'], contains('Metodo 1'));
      expect(json['finalidadesAtendimento'], contains('Finalidade 1'));
      expect(json['tecnicas'], contains('Tecnica 1'));
      expect(json['politicas'], contains('Politica 1'));
      expect(json['tecnicosEmater'], contains('Tecnico 1'));
      expect(json['proater'], contains('Proater 1'));
      expect(json['unidadesMedida'], contains('Unidade 1'));
      expect(json['lastUpdate'], isNotEmpty);
      
      final restoredData = OfflineData.fromJson(json);
      expect(restoredData.municipios, equals(originalData.municipios));
      expect(restoredData.eslocs, equals(originalData.eslocs));
      expect(restoredData.produtos, equals(originalData.produtos));
      expect(restoredData.metodos, equals(originalData.metodos));
      expect(restoredData.finalidadesAtendimento, equals(originalData.finalidadesAtendimento));
      expect(restoredData.tecnicas, equals(originalData.tecnicas));
      expect(restoredData.politicas, equals(originalData.politicas));
      expect(restoredData.tecnicosEmater, equals(originalData.tecnicosEmater));
      expect(restoredData.proater, equals(originalData.proater));
      expect(restoredData.unidadesMedida, equals(originalData.unidadesMedida));
      expect(restoredData.lastUpdate.year, equals(originalData.lastUpdate.year));
      expect(restoredData.lastUpdate.month, equals(originalData.lastUpdate.month));
      expect(restoredData.lastUpdate.day, equals(originalData.lastUpdate.day));
    });

    test('OfflineBeneficiarioFater should create and serialize correctly', () {
      final testBeneficiario = OfflineBeneficiarioFater(
        id: 'test_id_123',
        data: {'nome': 'Test User', 'data': '2024-01-01', 'observacoes': 'Test observations'},
        createdAt: DateTime(2024, 1, 1, 12, 0, 0),
        isSynced: false,
      );
      
      expect(testBeneficiario.id, 'test_id_123');
      expect(testBeneficiario.data, contains('nome'));
      expect(testBeneficiario.data['nome'], 'Test User');
      expect(testBeneficiario.data['data'], '2024-01-01');
      expect(testBeneficiario.data['observacoes'], 'Test observations');
      expect(testBeneficiario.createdAt, DateTime(2024, 1, 1, 12, 0, 0));
      expect(testBeneficiario.isSynced, false);
    });

    test('OfflineBeneficiarioFater should convert to JSON and back', () {
      final originalBeneficiario = OfflineBeneficiarioFater(
        id: 'test_id_456',
        data: {'nome': 'Another User', 'idade': 30, 'ativo': true},
        createdAt: DateTime(2024, 1, 2, 15, 30, 0),
        isSynced: true,
      );
      
      final json = originalBeneficiario.toJson();
      expect(json['id'], 'test_id_456');
      expect(json['data'], contains('nome'));
      expect(json['data']['nome'], 'Another User');
      expect(json['data']['idade'], 30);
      expect(json['data']['ativo'], true);
      expect(json['createdAt'], isNotEmpty);
      expect(json['isSynced'], true);
      
      final restoredBeneficiario = OfflineBeneficiarioFater.fromJson(json);
      expect(restoredBeneficiario.id, equals(originalBeneficiario.id));
      expect(restoredBeneficiario.data, equals(originalBeneficiario.data));
      expect(restoredBeneficiario.createdAt.year, equals(originalBeneficiario.createdAt.year));
      expect(restoredBeneficiario.createdAt.month, equals(originalBeneficiario.createdAt.month));
      expect(restoredBeneficiario.createdAt.day, equals(originalBeneficiario.createdAt.day));
      expect(restoredBeneficiario.createdAt.hour, equals(originalBeneficiario.createdAt.hour));
      expect(restoredBeneficiario.createdAt.minute, equals(originalBeneficiario.createdAt.minute));
      expect(restoredBeneficiario.isSynced, equals(originalBeneficiario.isSynced));
    });

    test('OfflineBeneficiarioFater should handle default isSynced value', () {
      final beneficiario = OfflineBeneficiarioFater(
        id: 'test_id_default',
        data: {'test': 'data'},
        createdAt: DateTime.now(),
      );
      
      expect(beneficiario.isSynced, false); // Default value
    });

    test('OfflineData should handle empty data', () {
      final emptyData = OfflineData(
        municipios: [],
        eslocs: [],
        produtos: [],
        metodos: [],
        finalidadesAtendimento: [],
        tecnicas: [],
        politicas: [],
        tecnicosEmater: [],
        proater: [],
        unidadesMedida: [],
        lastUpdate: DateTime.now(),
      );
      
      expect(emptyData.municipios, isEmpty);
      expect(emptyData.eslocs, isEmpty);
      expect(emptyData.produtos, isEmpty);
      expect(emptyData.metodos, isEmpty);
      expect(emptyData.finalidadesAtendimento, isEmpty);
      expect(emptyData.tecnicas, isEmpty);
      expect(emptyData.politicas, isEmpty);
      expect(emptyData.tecnicosEmater, isEmpty);
      expect(emptyData.proater, isEmpty);
      expect(emptyData.unidadesMedida, isEmpty);
      
      final json = emptyData.toJson();
      final restored = OfflineData.fromJson(json);
      expect(restored.municipios, isEmpty);
      expect(restored.eslocs, isEmpty);
      expect(restored.produtos, isEmpty);
      expect(restored.metodos, isEmpty);
      expect(restored.finalidadesAtendimento, isEmpty);
      expect(restored.tecnicas, isEmpty);
      expect(restored.politicas, isEmpty);
      expect(restored.tecnicosEmater, isEmpty);
      expect(restored.proater, isEmpty);
      expect(restored.unidadesMedida, isEmpty);
    });
  });
}

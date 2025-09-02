import 'package:flutter_test/flutter_test.dart';
import 'package:sisater_mobile/models/offline/offline_data.dart';
import 'package:sisater_mobile/models/offline/offline_beneficiario_fater.dart';

void main() {
  group('OfflineData Tests', () {
    test('should create OfflineData with all required fields', () {
      final now = DateTime.now();
      final offlineData = OfflineData(
        municipios: [{'id': 1, 'name': 'Teste'}],
        eslocs: [{'id': 1, 'name': 'ESLOC Teste'}],
        produtos: [{'id': 1, 'name': 'Produto Teste'}],
        metodos: [{'id': 1, 'name': 'Método Teste'}],
        finalidadesAtendimento: [{'id': 1, 'name': 'Finalidade Teste'}],
        tecnicas: [{'id': 1, 'name': 'Técnica Teste'}],
        politicas: [{'id': 1, 'name': 'Política Teste'}],
        tecnicosEmater: [{'id': 1, 'name': 'Técnico Teste'}],
        proater: [{'id': 1, 'name': 'Proater Teste'}],
        unidadesMedida: [{'id': 1, 'name': 'Unidade Teste'}],
        lastUpdate: now,
      );

      expect(offlineData.municipios.length, 1);
      expect(offlineData.eslocs.length, 1);
      expect(offlineData.produtos.length, 1);
      expect(offlineData.metodos.length, 1);
      expect(offlineData.finalidadesAtendimento.length, 1);
      expect(offlineData.tecnicas.length, 1);
      expect(offlineData.politicas.length, 1);
      expect(offlineData.tecnicosEmater.length, 1);
      expect(offlineData.proater.length, 1);
      expect(offlineData.unidadesMedida.length, 1);
      expect(offlineData.lastUpdate, now);
    });

    test('should convert OfflineData to JSON and back', () {
      final now = DateTime.now();
      final originalData = OfflineData(
        municipios: [{'id': 1, 'name': 'Teste'}],
        eslocs: [{'id': 1, 'name': 'ESLOC Teste'}],
        produtos: [{'id': 1, 'name': 'Produto Teste'}],
        metodos: [{'id': 1, 'name': 'Método Teste'}],
        finalidadesAtendimento: [{'id': 1, 'name': 'Finalidade Teste'}],
        tecnicas: [{'id': 1, 'name': 'Técnica Teste'}],
        politicas: [{'id': 1, 'name': 'Política Teste'}],
        tecnicosEmater: [{'id': 1, 'name': 'Técnico Teste'}],
        proater: [{'id': 1, 'name': 'Proater Teste'}],
        unidadesMedida: [{'id': 1, 'name': 'Unidade Teste'}],
        lastUpdate: now,
      );

      final json = originalData.toJson();
      final restoredData = OfflineData.fromJson(json);

      expect(restoredData.municipios.length, originalData.municipios.length);
      expect(restoredData.eslocs.length, originalData.eslocs.length);
      expect(restoredData.produtos.length, originalData.produtos.length);
      expect(restoredData.metodos.length, originalData.metodos.length);
      expect(restoredData.finalidadesAtendimento.length, originalData.finalidadesAtendimento.length);
      expect(restoredData.tecnicas.length, originalData.tecnicas.length);
      expect(restoredData.politicas.length, originalData.politicas.length);
      expect(restoredData.tecnicosEmater.length, originalData.tecnicosEmater.length);
      expect(restoredData.proater.length, originalData.proater.length);
      expect(restoredData.unidadesMedida.length, originalData.unidadesMedida.length);
      expect(restoredData.lastUpdate.year, originalData.lastUpdate.year);
      expect(restoredData.lastUpdate.month, originalData.lastUpdate.month);
      expect(restoredData.lastUpdate.day, originalData.lastUpdate.day);
    });

    test('should handle empty data in OfflineData', () {
      final now = DateTime.now();
      final offlineData = OfflineData(
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
        lastUpdate: now,
      );

      expect(offlineData.municipios, isEmpty);
      expect(offlineData.eslocs, isEmpty);
      expect(offlineData.produtos, isEmpty);
      expect(offlineData.metodos, isEmpty);
      expect(offlineData.finalidadesAtendimento, isEmpty);
      expect(offlineData.tecnicas, isEmpty);
      expect(offlineData.politicas, isEmpty);
      expect(offlineData.tecnicosEmater, isEmpty);
      expect(offlineData.proater, isEmpty);
      expect(offlineData.unidadesMedida, isEmpty);
    });
  });

  group('OfflineBeneficiarioFater Tests', () {
    test('should create OfflineBeneficiarioFater with all required fields', () {
      final now = DateTime.now();
      final data = {'test': 'value', 'number': 123};
      
      final beneficiario = OfflineBeneficiarioFater(
        id: 'test_id_123',
        data: data,
        createdAt: now,
        isSynced: false,
      );

      expect(beneficiario.id, 'test_id_123');
      expect(beneficiario.data, data);
      expect(beneficiario.createdAt, now);
      expect(beneficiario.isSynced, false);
    });

    test('should create OfflineBeneficiarioFater with default isSynced value', () {
      final now = DateTime.now();
      final data = {'test': 'value'};
      
      final beneficiario = OfflineBeneficiarioFater(
        id: 'test_id',
        data: data,
        createdAt: now,
      );

      expect(beneficiario.isSynced, false); // Default value
    });

    test('should convert OfflineBeneficiarioFater to JSON and back', () {
      final now = DateTime.now();
      final data = {'test': 'value', 'number': 123};
      
      final originalBeneficiario = OfflineBeneficiarioFater(
        id: 'test_id_123',
        data: data,
        createdAt: now,
        isSynced: true,
      );

      final json = originalBeneficiario.toJson();
      final restoredBeneficiario = OfflineBeneficiarioFater.fromJson(json);

      expect(restoredBeneficiario.id, originalBeneficiario.id);
      expect(restoredBeneficiario.data, originalBeneficiario.data);
      expect(restoredBeneficiario.createdAt.year, originalBeneficiario.createdAt.year);
      expect(restoredBeneficiario.createdAt.month, originalBeneficiario.createdAt.month);
      expect(restoredBeneficiario.createdAt.day, originalBeneficiario.createdAt.day);
      expect(restoredBeneficiario.isSynced, originalBeneficiario.isSynced);
    });

    test('should handle complex data structures', () {
      final now = DateTime.now();
      final complexData = {
        'string': 'test',
        'number': 123,
        'boolean': true,
        'null': null,
        'list': [1, 2, 3],
        'map': {'nested': 'value'},
      };
      
      final beneficiario = OfflineBeneficiarioFater(
        id: 'complex_test',
        data: complexData,
        createdAt: now,
        isSynced: false,
      );

      final json = beneficiario.toJson();
      final restored = OfflineBeneficiarioFater.fromJson(json);

      expect(restored.data['string'], complexData['string']);
      expect(restored.data['number'], complexData['number']);
      expect(restored.data['boolean'], complexData['boolean']);
      expect(restored.data['null'], complexData['null']);
      expect(restored.data['list'], complexData['list']);
      expect(restored.data['map'], complexData['map']);
    });

    test('should handle empty data', () {
      final now = DateTime.now();
      
      final beneficiario = OfflineBeneficiarioFater(
        id: 'empty_test',
        data: {},
        createdAt: now,
        isSynced: false,
      );

      expect(beneficiario.data, isEmpty);
      
      final json = beneficiario.toJson();
      final restored = OfflineBeneficiarioFater.fromJson(json);
      
      expect(restored.data, isEmpty);
    });
  });
}

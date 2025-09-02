import 'package:dio/dio.dart';
import 'package:sisater_mobile/models/atividade_de_pesca/atividadePescaPost.dart';
import 'package:sisater_mobile/models/atividade_de_pesca/atividade_pesca.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater.dart';
import 'package:sisater_mobile/models/comunidades/comunidade_selecionavel.dart';

class AtividadeDePescaRepository {
  Dio dio;

  AtividadeDePescaRepository(this.dio);
   bool getAtividadePesca = false;
   bool carregaMunicipios = false;
   bool listaAter = false;
  bool listaAtividadePorNome = false;

  Future<List<AtividadePesca>> getAtividadeDePesca(int page) async {
    try {
      final response = await dio.get(
        '/production-unit',
        queryParameters: {
          'expand': 'fisherman',
          'pageSize': 20,
          'page': page,
          'sort': '-created_at',
          'is_fisherman': 1,
        }
        );

      if (response.statusCode != 200) {
        getAtividadePesca = false;
        throw Exception('Erro ao buscar atividades de pesca: ${response.statusMessage}');
      }

      List<AtividadePesca> atividades = (response.data as List)
          .map((item) => AtividadePesca.fromJson(item))
          .where((atividade) => atividade.fisherman != null)
          .toList();

      if (atividades.isNotEmpty) {
        getAtividadePesca = true;
      } else {
        getAtividadePesca = false;
      }

      return atividades;
      
    } catch (e) {
      getAtividadePesca = false;
      throw Exception('Erro ao buscar atividades de pesca: $e');
    }
  }

  Future<bool> atividadePescaPost(AtividadePescaPost atividadePesca) async {
    try {
      final response = await dio.post(
        '/production-unit/1/create',
        data: atividadePesca.toJson(),
      );

      if (response.statusCode == 201) {
        return true;

      } else {
        throw Exception('Erro ao criar atividade de pesca: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Erro ao criar atividade de pesca: $e');
    }

  }

  Future<bool> atividadePescaPut(AtividadePesca atividadePesca, int id) async {
    try {
      final response = await dio.put(
        '/production-unit/$id/update',
        data: atividadePesca.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;

      } else {
        throw Exception('Erro ao editar atividade de pesca: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Erro ao editar atividade de pesca: $e');
    }

  }

  Future<bool> atividadePescaDelete(int id) async {
    try {
      final response = await dio.delete(
        '/production-unit/$id',
      );

      if (response.statusCode == 200) {
        return true;

      } else {
        throw Exception('Erro ao deletar atividade de pesca: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar atividade de pesca: $e');
    }

  }

  Future<List<ComunidadeSelecionavel>> listaMunicipios() async{
    try {
      var response = await dio.get(
        '/v1/city/index',
        queryParameters: {
          'city_code': 'PA',
          'sort': 'name',
          'pageSize': 0
        }

         //apisisater.emater.pa.gov.br/v1/city/index?uf_code=PA&sort=name&pageSize=0
      );

      List<ComunidadeSelecionavel> listaComunidade = [];

      if(response.statusCode == 200 && response.data != null){
        (response.data as List).map((a) => listaComunidade.add(ComunidadeSelecionavel.fromJson(a))).toList();
        
        if (listaComunidade.isNotEmpty) {
          carregaMunicipios = true;
        } else {
          carregaMunicipios = false;
        }
      } else {
        carregaMunicipios = false;
      }

      return listaComunidade;
    } catch (e) {
      carregaMunicipios = false;
      throw Exception('Erro ao carregar municípios: $e');
    }
  }

  Future<List<AtividadePesca>> listaatividadePorNome(String nome) async {
    try {
      final response = await dio.get(
          '/production-unit',
          queryParameters: {
            'expand': 'fisherman',
            'pageSize': 20,
            'page': 0,
            'sort': '-created_at',
            'name': nome,
            'is_fisherman': 1,
          }
          );

      List<AtividadePesca> atividade = [];

      if(response.statusCode == 200 && response.data != null){
        atividade = (response.data as List).map((a) => AtividadePesca.fromJson(a)).toList();
        
        if (atividade.isNotEmpty) {
          listaAtividadePorNome = true;
        } else {
          listaAtividadePorNome = false;
        }
      } else {
        listaAtividadePorNome = false;
      }

      return atividade; 
    } catch (e) {
      listaAtividadePorNome = false;
      throw Exception('Erro ao buscar atividades por nome: $e');
    }
  }

  Future<List<BeneficiarioAter>> listaBeneficiariosAter(String cityCodeFater) async {
    var response = await dio.get(
      '/beneficiary',
      queryParameters: {
        'type': 1, //Para trazer todos os registros de beneficiários Ater
        //'pageSize': 20,
        'page': 0,
        'pageSize': 50,
        'sort': '-created_at',
        'city_code': cityCodeFater
      }
    );

    List<BeneficiarioAter> beneficiariosAter = [];

    (response.data as List).map((a) => beneficiariosAter.add(BeneficiarioAter.fromJson(a))).toList();

    return beneficiariosAter;
  }
}
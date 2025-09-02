// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/comunidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/municipio.dart';
import 'package:sisater_mobile/models/unidade_de_producao/abastecimento_agua.dart';
import 'package:sisater_mobile/models/unidade_de_producao/dominio.dart';
import 'package:sisater_mobile/models/unidade_de_producao/energia_eletrica.dart';
import 'package:sisater_mobile/models/unidade_de_producao/transicao_agroecologica.dart';
import 'package:sisater_mobile/models/unidade_de_producao/unidade_de_producao_list.dart';
import 'package:sisater_mobile/models/unidade_de_producao/unidade_de_producao_post.dart';
import 'package:sisater_mobile/modules/app_store.dart';

class UnidadeProducaoRepository {
  Dio dio;
  AppStore? appStore = Modular.get<AppStore>();
  
  UnidadeProducaoRepository({
    required this.dio,
  });

  Future<List<UnidadedeProducaoList>> getUnidadesDeProducao(int page) async {

    final response = await dio.get('/production-unit',
    queryParameters: {
      'expand': 'productionUnitNormal',
      'is_fisherman': 0,
      'pageSize': 20,
      'page': page,
      'city_code': appStore?.usuarioDados?.cityCode ?? 1508209,
    }
    );
    return (response.data as List).map((e) => UnidadedeProducaoList.fromJson(e)).toList();
  }

  Future<UnidadeDeProducaoPost> postUnidadeDeProducao(UnidadeDeProducaoPost unidadeDeProducao) async {
    final response = await dio.post('/production-unit/0/create', data: unidadeDeProducao);
    return UnidadeDeProducaoPost.fromJson(response.data);
 }

 Future<UnidadeDeProducaoPost> putUnidadeDeProducao(UnidadeDeProducaoPost unidadeDeProducao, int id) async {
    final response = await dio.put('/production-unit/$id/update', data: unidadeDeProducao);
    return UnidadeDeProducaoPost.fromJson(response.data);
 }

  Future<UnidadeDeProducaoPost> editarUnidadeDeProducao(UnidadeDeProducaoPost unidade, int id) async {

    final response = await dio.put('/production-unit/$id/update', data: unidade);
    
    return UnidadeDeProducaoPost.fromJson(response.data);
 }

  Future<bool> deleteUnidadeDeProducao(int id) async {
    try {
      final response = await dio.delete('/production-unit/$id');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<Municipio>> listaMunicipios(String? ufCode) async{
    var response = await dio.get(
      '/v1/city/index',
      queryParameters: {
        'uf_code': ufCode,
        'sort': 'name',
        'pageSize': 0
      }
      );

    List<Municipio> listaMunicipios = [];

    (response.data as List).map((a) => listaMunicipios.add(Municipio.fromJson(a))).toList();

    return listaMunicipios;
  }

  Future<List<Comunidade>> listaComunidade(int? cityCode) async{
    var response = await dio.get(
      '/v1/community/index',
      queryParameters: {
        'city_code': cityCode,
        'sort': 'name',
        'pageSize': 0
      }
    );

    List<Comunidade> listaComunidade = [];

    (response.data as List).map((a) => listaComunidade.add(Comunidade.fromJson(a))).toList();

    return listaComunidade;
  }

  Future<List<EnergiaEletrica>> listaEnergiaEletrica() async{
    var response = await dio.get('/electric-power');
    return (response.data as List).map((a) => EnergiaEletrica.fromJson(a)).toList();
  }

  Future<List<AbastecimentoAgua>> listaAbastecimentoAgua() async{
    var response = await dio.get('/water-supply');
    return (response.data as List).map((a) => AbastecimentoAgua.fromJson(a)).toList();
  }

  Future<List<Dominio>> listaDominio() async{
    var response = await dio.get('/domain');
    return (response.data as List).map((a) => Dominio.fromJson(a)).toList();
  }

  Future<List<TransicaoAgroecologica>> listaTransicaoAgroecologica() async{
    var response = await dio.get('/agroecological-transition');
    return (response.data as List).map((a) => TransicaoAgroecologica.fromJson(a)).toList();
  }

}
import 'package:dio/dio.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/categoria_atividade_produtiva.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/categoria_publico.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/comunidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/motivo_registro.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/municipio.dart';

import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/registro_status.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/uf.dart';
import 'package:sisater_mobile/models/comunidades/comunidade_selecionavel.dart';
import 'package:sisater_mobile/models/organizacoes_ater/campos_selecionaveis/tipo_organizacao.dart';
import 'package:sisater_mobile/models/organizacoes_ater/organizacao_ater_list.dart';
import 'package:sisater_mobile/models/organizacoes_ater/organizacao_ater_post.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/eslocs.dart';

class OrganizacoesAterRepository {
  Dio dio;
  
  OrganizacoesAterRepository(this.dio);

  bool? listaFaterbool = false; 

  bool? listaFaterPorNome = false;

  bool? listaAterMunicipiops = false;

  bool? listaComunidades = false;

  int? postOrganizacaoCode;

  int? putOrganizacaoCode;

  bool? deleteOrganizacaoCode;

  bool? getOrganizacaoCode;

  Response<dynamic>? responsePOST;  


  Future<bool> postOrganizacaoAter(OrganizacaoAterPost organizacao) async {
    var response = await dio.post(
      '/beneficiary/create',
      queryParameters: {
      'type': 2, //2 seria uma organização
    },
      data: organizacao.toJson()
    );

    if(response.statusCode == 201){
      postOrganizacaoCode = response.statusCode;
      return response.data['success'] ?? false;
    }
    else{
      throw Exception('Erro ao cadastrar organização ATER');
    }
  }

  Future<OrganizacaoAterPost> getOrganizacaoAter(int id) async {
    
    var response = await dio.get(
      '/beneficiary/$id',
      queryParameters: {
      'expand': 'socialOrganization, physicalPerson',

    },
    );

    if(response.statusCode == 200){

      getOrganizacaoCode = true;

      return OrganizacaoAterPost.fromJson(response.data);
      
    }
    else{
      throw Exception('Erro ao buscar organização ATER');
    }

  }

  Future<void> deleteOrganizacaoAter(int id) async {
    
    var response = await dio.delete(
      '/beneficiary/$id',
    );

    if(response.statusCode == 200){

      deleteOrganizacaoCode = true;
    }
    
    else{
      throw Exception('Erro ao buscar organização ATER');
    }

  }

  Future<bool> putOrganizacaoAter(OrganizacaoAterPost organizacao, int id) async {
    var response = await dio.put(
      '/beneficiary/$id/update',
      queryParameters: {
        'type': 2, 
      },
      data: organizacao.toJson()
    );

    if(response.statusCode == 200){
      putOrganizacaoCode = response.statusCode;
      return response.data['success'] ?? false;
    }
    else{
      throw Exception('Erro ao cadastrar organização ATER');
    }
  }

  Future<List<OrganizacaoAterList>> listaOrganizacoesFater(int page) async {
    var response = await dio.get(
      '/beneficiary',
      queryParameters: {
        'type': 2, //Para trazer todos os registros de organizacoess Ater
        'pageSize': 20,
        'page': page,
        'sort': '-created_at'
        
      }
      );

    List<OrganizacaoAterList> beneficiariosAter = [];

    (response.data as List).map((a) => beneficiariosAter.add(OrganizacaoAterList.fromJson(a))).toList();

    if(response.statusCode == 200){
      listaFaterbool = true;
      //print(response.statusCode);
    }
    return beneficiariosAter; 
  }

  Future<List<OrganizacaoAterList>> listaBeneficiariosAterPorNome(String nome) async {
    var response = await dio.get(
      '/beneficiary',
      queryParameters: {
        'type': 2, //Para trazer todos os registros de beneficiários Ater
        'name': nome
      }
      );

    List<OrganizacaoAterList> beneficiariosAter = [];

    (response.data as List).map((a) => beneficiariosAter.add(OrganizacaoAterList.fromJson(a))).toList();

    if(response.statusCode == 200){
      listaFaterPorNome = true;
    }
    else{
      //responseError = response.data;
    }

    return beneficiariosAter; 
  }

  Future<List<TipoOrganizacao>> tiposOrganizacao() async{
    var response = await dio.get('/organization-type');

    List<TipoOrganizacao> listaTiposOrganizacao = [];

    (response.data as List).map((a) => listaTiposOrganizacao.add(TipoOrganizacao.fromJson(a))).toList();

    return listaTiposOrganizacao;
  }

   Future<List<UF>> estadosUF() async {
    var response = await dio.get('/state');

    List<UF> listaUF = [];

    (response.data as List).map((a) => listaUF.add(UF.fromJson(a))).toList();

    return listaUF;
  }

  Future<List<Municipio>> listaMunicipios(String? ufCode) async{
    var response = await dio.get(
      '/city',
      queryParameters: {
        'uf_code': ufCode,
        'sort': 'name',
        'pageSize': 0
      }
      );

    List<Municipio> listaMunicipios = [];

    (response.data as List).map((a) => listaMunicipios.add(Municipio.fromJson(a))).toList();

    listaAterMunicipiops = true;

    return listaMunicipios;
  }

  Future<List<MotivoRegistro>> listaMotivoRegistro() async {
    var response = await dio.get('/reason-for-registration');

    List<MotivoRegistro> listaMotivoRegistro = [];

    (response.data as List).map((a) => listaMotivoRegistro.add(MotivoRegistro.fromJson(a))).toList();

    return listaMotivoRegistro;
  }

  Future<List<CategoriaPublico>> listaCategoriaPublico() async {
    var response = await dio.get('/target-public');

    List<CategoriaPublico> listaCategoriaPublico = [];

    (response.data as List).map((a) => listaCategoriaPublico.add(CategoriaPublico.fromJson(a))).toList();

    return listaCategoriaPublico;
  }

  Future<List<Eslocs>> listaEslocs() async {
    var response = await dio.get(
      '/office',
      queryParameters: {
        'sort': 'name',
        'pageSize': 0
      }
    );

    List<Eslocs> listaEslocs = [];

    (response.data as List).map((a) => listaEslocs.add(Eslocs.fromJson(a))).toList();

    // Filtra apenas os objetos cujo name contém "ESLOC"
    listaEslocs = listaEslocs.where((e) => (e.name ?? '').contains('ESLOC')).toList();

    return listaEslocs;
  }

  Future<List<CategoriaAtividadeProdutiva>> listaAtividadeProdutiva() async {
    var response = await dio.get(
      '/productive-activity',
      queryParameters: {
        'sort': 'name',
        'pageSize': 0
      }
      );

    List<CategoriaAtividadeProdutiva> listaCategoriaProdutiva = [];

    (response.data as List).map((a) => listaCategoriaProdutiva.add(CategoriaAtividadeProdutiva.fromJson(a))).toList();

    return listaCategoriaProdutiva;
  }

  



  Future<List<RegistroStatus>> listaRegistroStatus() async {
    var response = await dio.get('/registration-status');

    List<RegistroStatus> listaRegistroStatus = [];

    (response.data as List).map((a) => listaRegistroStatus.add(RegistroStatus.fromJson(a))).toList();

    return listaRegistroStatus;
  }

  Future<List<ComunidadeSelecionavel>> listaMunicipiosInfoGerais() async{
    var response = await dio.get(
      '/city',
      queryParameters: {
        'city_code': 'PA',
        'sort': 'name',
        'pageSize': 0
      }

       //apisisater.emater.pa.gov.br/v1/city/index?uf_code=PA&sort=name&pageSize=0
    );

    List<ComunidadeSelecionavel> listaComunidade = [];

    (response.data as List).map((a) => listaComunidade.add(ComunidadeSelecionavel.fromJson(a))).toList();

    return listaComunidade;
  }

  Future<List<Comunidade>> listaComunidade(int? cityCode) async{

    var response = await dio.get(
      '/community',
      queryParameters: {
        'city_code': cityCode,
        'sort': 'name',
        'pageSize': 0
      }
    );

    List<Comunidade> listaComunidade = [];

    (response.data as List).map((a) => listaComunidade.add(Comunidade.fromJson(a))).toList();

    if(response.statusCode == 200){
      listaComunidades = true;
    }

    return listaComunidade;
  }

  
}
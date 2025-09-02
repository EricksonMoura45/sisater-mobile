import 'package:dio/dio.dart';
import 'package:sisater_mobile/models/beneficiario_fater/beneficiario_fater_post.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/comunidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/produto.dart';
import 'package:sisater_mobile/models/comunidades/comunidade_selecionavel.dart';
import 'package:sisater_mobile/models/organizacoes_fater/organizacao_fater_list.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/eslocs.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/finalidade_atendimento.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/metodo_ater.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/politicas_publicas.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/tecnica_ater.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/tecnico_emater.dart';

class OrganizacoesFaterRepository {
  Dio dio;
  OrganizacoesFaterRepository(this.dio);

  bool? listaFaterbool = false;
  bool? carregaMunicipios = false;
  bool? listaAter = false; 

  Future<List<OrganizacaoFaterList>> listaOrganizacoesFater(int page) async {
    var response = await dio.get(
      '/ater',
      queryParameters: {
        'type': 2, // Para trazer todos os registros de organizações Fater
        'pageSize': 20,
        'page': page,
        //'expand': 'faterSocialOrganization'
      },
    );

    List<OrganizacaoFaterList> organizacoesFater = [];

    (response.data as List).map((a) => organizacoesFater.add(OrganizacaoFaterList.fromJson(a))).toList();

    if (response.statusCode == 200) {
      listaFaterbool = true;
    }
    return organizacoesFater;
  }

  Future<int> postBeneficiarioFater(BeneficiarioFaterPost beneficiario) async{
    var response = await dio.post(
      '/ater/create/1',
      data: beneficiario.toJson(),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      )
    );

    return response.statusCode ?? 0;
  }

  Future<List<ComunidadeSelecionavel>> listaMunicipios() async{
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

    if(response.statusCode == 200){
      carregaMunicipios = true;

      (response.data as List).map((a) => listaComunidade.add(ComunidadeSelecionavel.fromJson(a))).toList();
    }

    return listaComunidade;
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

  Future<List<OrganizacaoFaterList>> listaBeneficiariosAter(String cityCodeFater) async {
    var response = await dio.get(
      '/beneficiary',
      queryParameters: {
        'type': 1, //Para trazer todos os registros de beneficiários Ater
        //'pageSize': 20,
        'page': 0,
        'sort': '-created_at'
      }
    );

    List<OrganizacaoFaterList> beneficiariosAter = [];

    (response.data as List).map((a) => beneficiariosAter.add(OrganizacaoFaterList.fromJson(a))).toList();

    // Filtra apenas os objetos cujo cityCode seja igual ao cityCodeFater
    beneficiariosAter = beneficiariosAter.where((b) => (b.code ?? '') == cityCodeFater).toList();

    if(response.statusCode == 200){
      listaAter = true;
    }
    else{
      //responseError = response.data;
    }

    return beneficiariosAter;
  }

  //Buscar beneficiario por Municipio

  //Carregar comunidade pelo municipio

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

  Future<List<FinalidadeAtendimento>> listaFinalidadeAtendimento() async{
    var response = await dio.get(
      '/finality',
      queryParameters: {
        'sort': 'name',
        'pageSize': 0
      }
    );

    List<FinalidadeAtendimento> listaFinalidadeAtendimento = [];

    (response.data as List).map((a) => listaFinalidadeAtendimento.add(FinalidadeAtendimento.fromJson(a))).toList();

    return listaFinalidadeAtendimento;
  }

  Future<List<Produto>> listaProdutos() async {
    var response = await dio.get(
      '/v1/product/index',
      queryParameters: {
        'sort': 'name',
        'pageSize': 0
      }
      );

    List<Produto> listaProdutos = [];

    (response.data as List).map((a) => listaProdutos.add(Produto.fromJson(a))).toList();

    return listaProdutos;
  }

  Future<List<MetodoAter>> listaMetodos() async {
    var response = await dio.get(
      '/method',
      queryParameters: {
        'sort': 'name',
        'pageSize': 0
      }
      );

    List<MetodoAter> listaMetodos = [];

    (response.data as List).map((a) => listaMetodos.add(MetodoAter.fromJson(a))).toList();

    return listaMetodos;
  }

  Future<List<TecnicaAter>> listaTecnica() async {
    var response = await dio.get(
      '/technique',
      queryParameters: {
        'sort': 'name',
        'pageSize': 0
      }
      );

    List<TecnicaAter> listatecnicas = [];

    (response.data as List).map((a) => listatecnicas.add(TecnicaAter.fromJson(a))).toList();

    return listatecnicas;
  }

  Future<List<PoliticasPublicas>> listaPoliticas() async {
    var response = await dio.get(
      '/tool',
      queryParameters: {
        'sort': 'name',
        'pageSize': 0
      }
      );

    List<PoliticasPublicas> listaPoliticas = [];

    (response.data as List).map((a) => listaPoliticas.add(PoliticasPublicas.fromJson(a))).toList();

    return listaPoliticas;
  }

  Future<List<TecnicoEmater>> listaTecnicoEmater() async {
    var response = await dio.get(
      '/user',
      queryParameters: {
        'sort': 'name',
        'pageSize': 0
      }
      );

    List<TecnicoEmater> listaTecnicoEmater = [];

    (response.data as List).map((a) => listaTecnicoEmater.add(TecnicoEmater.fromJson(a))).toList();

    return listaTecnicoEmater;
  }

}
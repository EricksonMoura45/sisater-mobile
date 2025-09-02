import 'package:dio/dio.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater_post.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/categoria_atividade_produtiva.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/categoria_publico.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/municipio.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/comunidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/enq_caf.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/entidade_caf.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/escolaridade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/motivo_registro.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/nacionalidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/naturalidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/produto.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/programas_governamentais.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/registro_status.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/subproduto.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/uf.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/membro_familiar/campos_selecionaveis/parentesco.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/membro_familiar/membro_familiar.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/membro_familiar/membro_familiar_post.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/membro_familiar/membro_familiar_put.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/prontuario/prontuario.dart';

class BeneficiarioAterRepository {

  Dio dio;
  bool? listaAter = false; 

  bool? listaAterMaisbeneficiarios = false;

  bool? listaAterPorNome = false;

  bool? listaAterMunicipiops;

  int? postBeneficiarioCode;

  int? postFamiliarCode;

  int? putBeneficiarioCode;

  int? putFamiliarCode;

  int? editBeneficiarioCode;

  bool? listaFamiliaresbool;

  int? editFamiliarCode;

  Response<dynamic>? responsePOST;

  var responseError;


  BeneficiarioAterRepository(this.dio);
  

  Future<List<BeneficiarioAter>> listaBeneficiariosAter(int page) async {
    var response = await dio.get(
      '/beneficiary',
      queryParameters: {
        'type': 1, //Para trazer todos os registros de beneficiários Ater
        'pageSize': 20,
        'page': page,
        'sort': '-created_at'
      }
      );

    List<BeneficiarioAter> beneficiariosAter = [];

    (response.data as List).map((a) => beneficiariosAter.add(BeneficiarioAter.fromJson(a))).toList();

    if(response.statusCode == 200){
      listaAter = true;
    }
    else{
      responseError = response.data;
    }

    return beneficiariosAter; 
  }

  Future<List<BeneficiarioAter>> listaBeneficiariosAterPorNome(String nome) async {
    var response = await dio.get(
      '/beneficiary',
      queryParameters: {
        'type': 1, //Para trazer todos os registros de beneficiários Ater
        'name': nome
      }
      );

    List<BeneficiarioAter> beneficiariosAter = [];

    (response.data as List).map((a) => beneficiariosAter.add(BeneficiarioAter.fromJson(a))).toList();

    if(response.statusCode == 200){
      listaAterPorNome = true;
    }
    else{
      responseError = response.data;
    }

    return beneficiariosAter; 
  }

  Future<List<UF>> estadosUF() async {
    var response = await dio.get(
      '/v1/state/index',
      queryParameters: {
        'sort': 'name',
        'pageSize': 0
      }
    );

    List<UF> listaUF = [];

    (response.data as List).map((a) => listaUF.add(UF.fromJson(a))).toList();

    return listaUF;
  }

  Future<List<Naturalidade>> listaNaturalidade() async {
    var response = await dio.get(
      '/v1/naturalness/index',
      queryParameters: {
        'sort': 'name',
        'pageSize': 0
      }
    );

    List<Naturalidade> listaNaturalidade = [];

    (response.data as List).map((a) => listaNaturalidade.add(Naturalidade.fromJson(a))).toList();

    return listaNaturalidade;
  }

  Future<List<Nacionalidade>> listaNacionalidade() async {
    var response = await dio.get(
      '/v1/nationality/index',
      queryParameters: {
        'sort': 'name',
        'pageSize': 0
      }
      );

    List<Nacionalidade> listaNacionalidade = [];

    (response.data as List).map((a) => listaNacionalidade.add(Nacionalidade.fromJson(a))).toList();

    return listaNacionalidade;
  }

  Future<List<Escolaridade>> listaEscolaridade() async {
    var response = await dio.get(
      '/v1//scholarity/index',
      queryParameters: {
        'sort': 'name',
        'pageSize': 0
      }
      );

    List<Escolaridade> listaEscolaridade = [];

    (response.data as List).map((a) => listaEscolaridade.add(Escolaridade.fromJson(a))).toList();

    return listaEscolaridade;
  }

  Future<List<CategoriaPublico>> listaCategoriaPublico() async {
    var response = await dio.get(
      '/v1/target-public/index',
      queryParameters: {
        'sort': 'name',
        'pageSize': 0
      }
      );

    List<CategoriaPublico> listaCategoriaPublico = [];

    (response.data as List).map((a) => listaCategoriaPublico.add(CategoriaPublico.fromJson(a))).toList();

    return listaCategoriaPublico;
  }

  Future<List<MotivoRegistro>> listaMotivoRegistro() async {
    var response = await dio.get(
      '/v1/reason-for-registration/index',
      queryParameters: {
        'sort': 'name',
        'pageSize': 0
      }
      );

    List<MotivoRegistro> listaMotivoRegistro = [];

    (response.data as List).map((a) => listaMotivoRegistro.add(MotivoRegistro.fromJson(a))).toList();

    return listaMotivoRegistro;
  }

  Future<List<CategoriaAtividadeProdutiva>> listaAtividadeProdutiva() async {
    var response = await dio.get(
      '/v1/productive-activity/index',
      queryParameters: {
        'sort': 'name',
        'pageSize': 0
      }
      );

    List<CategoriaAtividadeProdutiva> listaCategoriaProdutiva = [];

    (response.data as List).map((a) => listaCategoriaProdutiva.add(CategoriaAtividadeProdutiva.fromJson(a))).toList();

    return listaCategoriaProdutiva;
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

  Future<List<SubProduto>> listaSubprodutos() async {
    var response = await dio.get(
      '/v1/derivatives/index',
      queryParameters: {
        'sort': 'name',
        'pageSize': 0
      }
      );

    List<SubProduto> listaSubprodutos = [];

    (response.data as List).map((a) => listaSubprodutos.add(SubProduto.fromJson(a))).toList();

    return listaSubprodutos;
  }

  Future<List<EnqCaf>> listaEnqCaf() async {
    var response = await dio.get(
      '/v1/dap/index',
      queryParameters: {
        'sort': 'name',
        'pageSize': 0
      }
      );

    List<EnqCaf> listaEnqCaf = [];

    (response.data as List).map((a) => listaEnqCaf.add(EnqCaf.fromJson(a))).toList();

    return listaEnqCaf;
  }

  Future<List<EntidadeCaf>> listaEntidadeCaf() async {
    var response = await dio.get(
      '/v1/dap-origin/index',
      queryParameters: {
        'sort': 'name',
        'pageSize': 0
      }
      );

    List<EntidadeCaf> listaEnqCaf = [];

    (response.data as List).map((a) => listaEnqCaf.add(EntidadeCaf.fromJson(a))).toList();

    return listaEnqCaf;
  }

  Future<List<RegistroStatus>> listaRegistroStatus() async {
    var response = await dio.get('/v1/registration-status/index');

    List<RegistroStatus> listaRegistroStatus = [];

    (response.data as List).map((a) => listaRegistroStatus.add(RegistroStatus.fromJson(a))).toList();

    return listaRegistroStatus;
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

    listaAterMunicipiops = true;

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

  Future<List<ProgramasGovernamentais>> listaProgGovernamentais() async{
    var response = await dio.get('/v1/government-programs/index');

    List<ProgramasGovernamentais> listaProgramasGovernamentais= [];

    (response.data as List).map((a) => listaProgramasGovernamentais.add(ProgramasGovernamentais.fromJson(a))).toList();

    return listaProgramasGovernamentais;
  }

  Future<List<Parentesco>> listaParentesco() async{
    var response = await dio.get(
      '/v1/relatedness/index',
      queryParameters: {
        'sort': 'name',
        'pageSize': -1
      }
      );

    List<Parentesco> listaParentesco= [];

    (response.data as List).map((a) => listaParentesco.add(Parentesco.fromJson(a))).toList();

    return listaParentesco;
  }


  //BENEFICIARIO

  Future postBeneficiario(BeneficiarioAterPost beneficiarioAterPost) async{
    var response = await dio.post('/beneficiary/create', 
    queryParameters: {
      'type': 1, //O /1 é para indicar que é um beneficiário Ater, caso fosse /2 seria uma organização
    },
    data: beneficiarioAterPost.toJson());

    if(response.statusCode != 201){
      responsePOST = response;
    }

    postBeneficiarioCode = response.statusCode;
  }

  Future<bool?> deleteBeneficiario(int? id) async{
    var response = await dio.delete('/beneficiary/$id');
    bool? sucess = response.data["sucess"];
    
    return sucess;
  }

  Future putBeneficiario(int? id, BeneficiarioAterPost beneficiarioAterPost) async{
    var response = await dio.put('/beneficiary/$id/update',
    data: beneficiarioAterPost.toJson());

    putBeneficiarioCode = response.statusCode;
  }
  
  //Aqui usamos o mesmo modelo de BeneficiarioAterPost, pois a resposta é a mesma
  Future<BeneficiarioAterPost> getBeneficiario(int? id) async{
    var response = await dio.get('/beneficiary/$id',
    queryParameters: {
      'expand': 'physicalPerson',
    }
    );

    BeneficiarioAterPost beneficiarioAter = BeneficiarioAterPost.fromJson(response.data);

    editBeneficiarioCode = response.statusCode;

    return beneficiarioAter;
  }

  /* Requisicoes do Integrante familiar */
  
  Future<List<MembroFamiliar>> listaFamiliares(int id) async {
    var response = await dio.get(
      '/beneficiary/$id/family-member',
      queryParameters: {
        'pageSize': 10, 
        'page': 0
      }
      );

    List<MembroFamiliar> membroFamiliar = [];

    (response.data as List).map((a) => membroFamiliar.add(MembroFamiliar.fromJson(a))).toList();

    if(response.statusCode == 200){
      listaFamiliaresbool = true;
    }
    else{
      responseError = response.data;
    }

    return membroFamiliar; 
  }

  Future<MembroFamiliar> getFamiliar(int id) async {
    var response = await dio.get(
      '/family-member/$id',
      );

    MembroFamiliar membroFamiliar = MembroFamiliar.fromJson(response.data);

    editFamiliarCode = response.statusCode;

    return membroFamiliar;
 
  }
  
  Future postFamiliar(int id, MembroFamiliarPost membroFamiliarPost) async{

    var response = await dio.post('/beneficiary/$id/family-member/create', 
    data: membroFamiliarPost.toJson());

    postFamiliarCode = response.statusCode;
    
  }

  Future<bool?> deleteFamiliar(int? id) async{
    var response = await dio.delete('/family-member/$id');

    bool? sucess = response.data["sucess"];
    
    return sucess;
  }

  Future putFamiliar(int? id, MembroFamiliarPut membroFamiliarPut) async{
    var response = await dio.put('/family-member/$id/update',
    data: membroFamiliarPut.toJson());

    putFamiliarCode = response.statusCode;
  }

  Future<Prontuario> prontuarioBeneficiarioAter(int id) async {

    var response = await dio.get('/report/prontuario-beneficiario/$id');

    Prontuario prontuario = Prontuario.fromJson(response.data);

    return prontuario;
  }
}  

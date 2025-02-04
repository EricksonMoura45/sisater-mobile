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

class BeneficiarioAterRepository {

  Dio dio;
  bool? listaAter = false; 

  int? postBeneficiarioCode;

  int? putBeneficiarioCode;

  Response<dynamic>? responsePOST;


  BeneficiarioAterRepository(this.dio);
  

  Future<List<BeneficiarioAter>> listaBeneficiariosAter() async {
    var response = await dio.get(
      '/beneficiary',
      queryParameters: {
        'pagination': -1, //Para trazer todos os registros
      }
      );

    List<BeneficiarioAter> beneficiariosAter = [];

    (response.data as List).map((a) => beneficiariosAter.add(BeneficiarioAter.fromJson(a))).toList();

    if(response.statusCode == 200){
      listaAter = true;
      print(response.statusCode);
    }

    return beneficiariosAter; 
  }

  Future<List<UF>> estadosUF() async {
    var response = await dio.get('/v1/state/index');

    List<UF> listaUF = [];

    (response.data as List).map((a) => listaUF.add(UF.fromJson(a))).toList();

    return listaUF;
  }

  Future<List<Naturalidade>> listaNaturalidade() async {
    var response = await dio.get('/v1/naturalness/index');

    List<Naturalidade> listaNaturalidade = [];

    (response.data as List).map((a) => listaNaturalidade.add(Naturalidade.fromJson(a))).toList();

    return listaNaturalidade;
  }

  Future<List<Nacionalidade>> listaNacionalidade() async {
    var response = await dio.get('/v1/nationality/index');

    List<Nacionalidade> listaNacionalidade = [];

    (response.data as List).map((a) => listaNacionalidade.add(Nacionalidade.fromJson(a))).toList();

    return listaNacionalidade;
  }

  Future<List<Escolaridade>> listaEscolaridade() async {
    var response = await dio.get('/v1//scholarity/index');

    List<Escolaridade> listaEscolaridade = [];

    (response.data as List).map((a) => listaEscolaridade.add(Escolaridade.fromJson(a))).toList();

    return listaEscolaridade;
  }

  Future<List<CategoriaPublico>> listaCategoriaPublico() async {
    var response = await dio.get('/v1/target-public/index');

    List<CategoriaPublico> listaCategoriaPublico = [];

    (response.data as List).map((a) => listaCategoriaPublico.add(CategoriaPublico.fromJson(a))).toList();

    return listaCategoriaPublico;
  }

  Future<List<MotivoRegistro>> listaMotivoRegistro() async {
    var response = await dio.get('/v1/reason-for-registration/index');

    List<MotivoRegistro> listaMotivoRegistro = [];

    (response.data as List).map((a) => listaMotivoRegistro.add(MotivoRegistro.fromJson(a))).toList();

    return listaMotivoRegistro;
  }

  Future<List<CategoriaAtividadeProdutiva>> listaAtividadeProdutiva() async {
    var response = await dio.get('/v1/productive-activity/index');

    List<CategoriaAtividadeProdutiva> listaCategoriaProdutiva = [];

    (response.data as List).map((a) => listaCategoriaProdutiva.add(CategoriaAtividadeProdutiva.fromJson(a))).toList();

    return listaCategoriaProdutiva;
  }

  Future<List<Produto>> listaProdutos() async {
    var response = await dio.get('/v1/product/index');

    List<Produto> listaProdutos = [];

    (response.data as List).map((a) => listaProdutos.add(Produto.fromJson(a))).toList();

    return listaProdutos;
  }

  Future<List<SubProduto>> listaSubprodutos() async {
    var response = await dio.get('/v1/derivatives/index');

    List<SubProduto> listaSubprodutos = [];

    (response.data as List).map((a) => listaSubprodutos.add(SubProduto.fromJson(a))).toList();

    return listaSubprodutos;
  }

  Future<List<EnqCaf>> listaEnqCaf() async {
    var response = await dio.get('/v1/dap/index');

    List<EnqCaf> listaEnqCaf = [];

    (response.data as List).map((a) => listaEnqCaf.add(EnqCaf.fromJson(a))).toList();

    return listaEnqCaf;
  }

  Future<List<EntidadeCaf>> listaEntidadeCaf() async {
    var response = await dio.get('/v1/dap-origin/index');

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

  Future<List<Municipio>> listaMunicipios() async{
    var response = await dio.get('/v1/city/index');

    List<Municipio> listaMunicipios = [];

    (response.data as List).map((a) => listaMunicipios.add(Municipio.fromJson(a))).toList();

    return listaMunicipios;
  }

  Future<List<Comunidade>> listaComunidade() async{
    var response = await dio.get('/v1/community/index');

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


  //BENEFICIARIO

  Future postBeneficiario(BeneficiarioAterPost beneficiarioAterPost) async{
    var response = await dio.post('/beneficiary/create',
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
    var response = await dio.get('/beneficiary/$id');

    BeneficiarioAterPost beneficiarioAter = BeneficiarioAterPost.fromJson(response.data);

    putBeneficiarioCode = response.statusCode;

    return beneficiarioAter;
  }
  }

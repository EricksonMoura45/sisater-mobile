import 'package:dio/dio.dart';
import 'package:sisater_mobile/models/comunidades/comunidade_selecionavel.dart';
import 'package:sisater_mobile/models/comunidades/comunidades_list.dart';
import 'package:sisater_mobile/models/comunidades/comunidades_post.dart';

class ComunidadesRepository {

  Dio dio;
  ComunidadesRepository(this.dio);
  
  bool? listaComunidadesbool = false;
  bool? postComunidadeCode = false;
  bool? putComunidadeCode = false;
  bool? carregaComunidadeCode = false;
  bool? listaAterPorNome = false;

   Future<List<ComunidadesList>> listaComunidades(int page) async {
    var response = await dio.get(
    '/community',
      queryParameters: {
        'type': 2, // Para trazer todos os registros de organizações Fater
        'pageSize': 20,
        'page': page,
        'expand': 'cityCode,accessTypeText',
        'sort': '-created_at'
      },
    );

    List<ComunidadesList> listaComunidades = [];

    (response.data as List).map((a) => listaComunidades.add(ComunidadesList.fromJson(a))).toList();

    if (response.statusCode == 200) {
      listaComunidadesbool = true;
    }
    return listaComunidades;
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

    (response.data as List).map((a) => listaComunidade.add(ComunidadeSelecionavel.fromJson(a))).toList();

    return listaComunidade;
  }

  Future postComunidade(ComunidadesPost comunidade) async{
    final data = comunidade.toJson();
    data.remove('id'); // Remove o campo 'id' do JSON, se existir

    var response = await dio.post('/community/create', 
    data: data);

    if(response.statusCode == 200){
      postComunidadeCode = true;
    }

  }

  Future putComunidade(ComunidadesPost comunidade, int id) async {
  final data = comunidade.toJson();
  data.remove('id'); // Remove o campo 'id' do JSON, se existir

  var response = await dio.put('/community/$id/update', data: data);

  if (response.statusCode == 200) {
    putComunidadeCode = true;
  }
}

  Future<int> deleteComunidade(int id) async{

    var response = await dio.delete('/community/$id');

    return response.statusCode ?? 0;

  }

  Future<List<ComunidadesList>> listaComunidadePorNome(String nome) async {
    var response = await dio.get(
      '/beneficiary',
      queryParameters: {
        'type': 1, //Para trazer todos os registros de beneficiários Ater
        'name': nome
      }
      );

    List<ComunidadesList> comunidade = [];

    (response.data as List).map((a) => comunidade.add(ComunidadesList.fromJson(a))).toList();

    if(response.statusCode == 200){
      listaAterPorNome = true;
    }
    else{
      //responseError = response.data;
    }

    return comunidade; 
  }

}
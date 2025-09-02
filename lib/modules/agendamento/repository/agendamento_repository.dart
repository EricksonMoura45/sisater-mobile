import 'package:dio/dio.dart';
import 'package:sisater_mobile/models/agendamento/agendamento_lista.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater.dart';

class AgendamentoRepository {

  final Dio dio;

  AgendamentoRepository(this.dio);

  Future<List<AgendamentoLista>> listaAgendamentos() async {
    var response = await dio.get('/agenda',
      queryParameters: {
        'expand': 'beneficiaries',
         'sort': 'created_at',
         'page': 0,
         'pageSize': 20
      }
    );
    
    List<AgendamentoLista> listaAgendamentos = [];

    (response.data as List).map((a) => listaAgendamentos.add(AgendamentoLista.fromJson(a))).toList();

    return listaAgendamentos;
  }

  Future<bool> agendarVisita(AgendamentoLista agendamento) async {
    
    
    var response = await dio.post('/agenda/create', data: agendamento.toJson());
    
    
    if (response.statusCode == 201) { //aqui eh 201 pois é o status de criação de um novo agendamento
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editarAgendamento(int id, AgendamentoLista agendamento) async {
    
    var response = await dio.put('/agenda/$id/update', data: agendamento.toJson());

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
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

  Future<bool> deleteAgendamento(int id) async {
    var response = await dio.delete('/agenda/$id');

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

}
import 'package:dio/dio.dart';
import 'package:sisater_mobile/models/atendimento/chat_card.dart';
import 'package:sisater_mobile/models/atendimento/mensagem.dart';
import 'package:sisater_mobile/models/agendamento/agendamento_lista.dart';
import 'package:sisater_mobile/models/autenticacao/usuario_dados.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/prontuario/prontuario.dart';

class BeneficiarioRepository {
  Dio dio;

  BeneficiarioRepository({required this.dio});

  // --- AGENDAMENTOS ---
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
    if (response.statusCode == 200) {
      if (response.data['success'] == true) {
        return true;
      }
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
        'type': 1,
        'page': 0,
        'pageSize': 50,
        'sort': '-created_at'
      }
    );
    List<BeneficiarioAter> beneficiariosAter = [];
    (response.data as List).map((a) => beneficiariosAter.add(BeneficiarioAter.fromJson(a))).toList();
    beneficiariosAter = beneficiariosAter.where((b) => (b.cityCode ?? '') == cityCodeFater).toList();
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

  // --- CHATS ---
  Future<List<ChatCard>> getChats() async {
    try {
      
      final response = await dio.get('/chat/my-chats',
      queryParameters: {
      "expand":"beneficiario,tecnico,ultimaMensagem"
      }
      );
      
      if (response.data == null) {
      
        return [];
      }
      if (response.data is! List) {
        
        throw Exception('Resposta da API não é uma lista: \\${response.data}');
      }
      final List<dynamic> dataList = response.data as List<dynamic>;
      List<ChatCard> chats = [];
      for (int i = 0; i < dataList.length; i++) {
        try {
          final item = dataList[i];
          if (item is Map<String, dynamic>) {
            final chat = ChatCard.fromJson(item);
            chats.add(chat);
          } else {
          }
        } catch (e) {
        }
      }
    
      return chats;
    } catch (e) {
      
      throw Exception('Erro ao buscar chats: $e');
    }
  }

  Future<List<Mensagem>> getMensagens(int chatId) async {
    try {
      final response = await dio.get('/chat/messages/$chatId');
      
      if (response.data == null) {
        return [];
      }
      
      // Verifica se é uma lista
      if (response.data is! List) {
        throw Exception('Resposta da API não é uma lista: ${response.data}');
      }
      
      final List<dynamic> dataList = response.data as List<dynamic>;
      
      List<Mensagem> mensagens = [];
      
      for (int i = 0; i < dataList.length; i++) {
        try {
          final item = dataList[i];
          
          if (item is Map<String, dynamic>) {
            final mensagem = Mensagem.fromJson(item);
            mensagens.add(mensagem);
          } else {
          }
        } catch (e) {
          // Continua processando outros itens
        }
      }
      
      return mensagens;
    } catch (e) {
      throw Exception('Erro ao carregar mensagens: $e');
    }
  }

  Future<bool> enviarMensagem(int chatId, String texto) async {
    try {
      final response = await dio.post(
        '/chat/send-message/$chatId',
        data: {
          'message': texto,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Erro ao enviar mensagem: $e');
    }
  }

  Future<bool> criarChat(String titulo) async {
    try {
      final response = await dio.post('/chat/create',
      data: {
        'title': titulo,
      },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Erro ao criar chat: $e');
    }
  }

  Future<Prontuario> getProntuario() async {

    var response = await dio.get('/report/meu-prontuario');

    if (response.statusCode == 200) {
      return Prontuario.fromJson(response.data);
    } else {
      throw Exception('Erro ao buscar prontuário');
    }

  }

  Future<bool> ImagemUsuario(String base64) async {
    var response = await dio.post('/me/mudar-avatar', data: {
      'foto': 'data:image/png;base64,$base64',
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  
  Future<UsuarioDados?> dadosUsuario()async{

    var response = await dio.get('/me');

    if(response.statusCode == 200){
      return UsuarioDados.fromJson(response.data);
    }

    return null;
  }
}
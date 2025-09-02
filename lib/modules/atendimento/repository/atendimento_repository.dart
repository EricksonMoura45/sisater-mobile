import 'package:dio/dio.dart';
import 'package:sisater_mobile/models/atendimento/chat_card.dart';
import 'package:sisater_mobile/models/atendimento/mensagem.dart';
import 'dart:developer' as developer;

import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/metodo_ater.dart';

class AtendimentoRepository {

  Dio dio;

  AtendimentoRepository({required this.dio});

  Future<List<ChatCard>> getChats() async {
    try {
      developer.log('=== INÍCIO getChats ===');
      developer.log('Fazendo requisição para /chat/my-chats');
      
      final response = await dio.get('/chat/my-chats',
      queryParameters: {
        'expand': 'beneficiario,tecnico,ultimaMensagem'
      }
      );
      
      developer.log('Resposta recebida: ${response.statusCode}');
      developer.log('Tipo da resposta: ${response.data.runtimeType}');
      developer.log('Conteúdo da resposta: ${response.data}');
      
      if (response.data == null) {
        developer.log('Resposta é null, retornando lista vazia');
        return [];
      }
      
      // Verifica se é uma lista
      if (response.data is! List) {
        developer.log('ERRO: Resposta não é uma lista: ${response.data}');
        throw Exception('Resposta da API não é uma lista: ${response.data}');
      }
      
      final List<dynamic> dataList = response.data as List<dynamic>;
      developer.log('Número de itens na lista: ${dataList.length}');
      
      List<ChatCard> chats = [];
      
      for (int i = 0; i < dataList.length; i++) {
        try {
          final item = dataList[i];
          developer.log('Processando item $i: $item');
          
          if (item is Map<String, dynamic>) {
            final chat = ChatCard.fromJson(item);
            chats.add(chat);
            developer.log('Item $i processado com sucesso');
          } else {
            developer.log('ERRO: Item $i não é um Map válido: $item');
          }
        } catch (e) {
          developer.log('ERRO ao processar item $i: $e');
          // Continua processando outros itens
        }
      }
      
      developer.log('Chats processados com sucesso: ${chats.length}');
      developer.log('=== FIM getChats ===');
      return chats;
    } catch (e) {
      developer.log('ERRO CRÍTICO ao buscar chats: $e');
      developer.log('=== FIM getChats com ERRO ===');
      throw Exception('Erro ao buscar chats: $e');
    }
  }

   Future<List<ChatCard>> getOpenChats() async {
    try {
      developer.log('=== INÍCIO getChats ===');
      developer.log('Fazendo requisição para /chat/my-chats');
      
      final response = await dio.get('/chat/open-chats',
      queryParameters: {
        'expand': 'beneficiario,tecnico,ultimaMensagem'
      }
      );
      
      developer.log('Resposta recebida: ${response.statusCode}');
      developer.log('Tipo da resposta: ${response.data.runtimeType}');
      developer.log('Conteúdo da resposta: ${response.data}');
      
      if (response.data == null) {
        developer.log('Resposta é null, retornando lista vazia');
        return [];
      }
      
      // Verifica se é uma lista
      if (response.data is! List) {
        developer.log('ERRO: Resposta não é uma lista: ${response.data}');
        throw Exception('Resposta da API não é uma lista: ${response.data}');
      }
      
      final List<dynamic> dataList = response.data as List<dynamic>;
      developer.log('Número de itens na lista: ${dataList.length}');
      
      List<ChatCard> chats = [];
      
      for (int i = 0; i < dataList.length; i++) {
        try {
          final item = dataList[i];
          developer.log('Processando item $i: $item');
          
          if (item is Map<String, dynamic>) {
            final chat = ChatCard.fromJson(item);
            chats.add(chat);
            developer.log('Item $i processado com sucesso');
          } else {
            developer.log('ERRO: Item $i não é um Map válido: $item');
          }
        } catch (e) {
          developer.log('ERRO ao processar item $i: $e');
          // Continua processando outros itens
        }
      }
      
      developer.log('Chats processados com sucesso: ${chats.length}');
      developer.log('=== FIM getChats ===');
      return chats;
    } catch (e) {
      developer.log('ERRO CRÍTICO ao buscar chats: $e');
      developer.log('=== FIM getChats com ERRO ===');
      throw Exception('Erro ao buscar chats: $e');
    }
  }

  Future<List<Mensagem>> getMensagens(int chatId) async {
    try {
      developer.log('=== INÍCIO getMensagens ===');
      developer.log('Fazendo requisição para /chat/messages/$chatId');
      
      final response = await dio.get('/chat/messages/$chatId');
      
      developer.log('Resposta recebida: ${response.statusCode}');
      developer.log('Tipo da resposta: ${response.data.runtimeType}');
      developer.log('Conteúdo da resposta: ${response.data}');
      
      if (response.data == null) {
        developer.log('Resposta é null, retornando lista vazia');
        return [];
      }
      
      // Verifica se é uma lista
      if (response.data is! List) {
        developer.log('ERRO: Resposta não é uma lista: ${response.data}');
        throw Exception('Resposta da API não é uma lista: ${response.data}');
      }
      
      final List<dynamic> dataList = response.data as List<dynamic>;
      developer.log('Número de itens na lista: ${dataList.length}');
      
      List<Mensagem> mensagens = [];
      
      for (int i = 0; i < dataList.length; i++) {
        try {
          final item = dataList[i];
          developer.log('Processando item $i: $item');
          
          if (item is Map<String, dynamic>) {
            final mensagem = Mensagem.fromJson(item);
            mensagens.add(mensagem);
            developer.log('Item $i processado com sucesso');
          } else {
            developer.log('ERRO: Item $i não é um Map válido: $item');
          }
        } catch (e) {
          developer.log('ERRO ao processar item $i: $e');
          // Continua processando outros itens
        }
      }
      
      developer.log('Mensagens processadas com sucesso: ${mensagens.length}');
      developer.log('=== FIM getMensagens ===');
      return mensagens;
    } catch (e) {
      developer.log('ERRO CRÍTICO ao buscar mensagens: $e');
      developer.log('=== FIM getMensagens com ERRO ===');
      throw Exception('Erro ao buscar mensagens: $e');
    }
  }

  Future<bool> enviarMensagem(int chatId, String mensagem) async {

    final response = await dio.post('/chat/send-message/$chatId', data: {
      'message': mensagem,    
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } 

  Future<bool> iniciarChat(String titulo) async {

    final response = await dio.post('/chat/create',
      data: {
        'title': titulo,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
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

  Future<bool> finalizarChat(int id,int method) async {

    final response = await dio.post('/chat/close/$id',
      data: {
        'method': method,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> joinChat(int id) async {
    final response = await dio.post('/chat/join/$id');

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
  
}
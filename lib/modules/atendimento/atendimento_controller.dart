import 'package:esig_utils/status.dart';
import 'package:mobx/mobx.dart';
import 'package:sisater_mobile/models/atendimento/chat_card.dart';
import 'package:sisater_mobile/models/atendimento/mensagem.dart';
import 'package:sisater_mobile/modules/atendimento/repository/atendimento_repository.dart';
part 'atendimento_controller.g.dart';

class AtendimentoController = _AtendimentoControllerBase with _$AtendimentoController;

abstract class _AtendimentoControllerBase with Store {

  final AtendimentoRepository atendimentoRepository;

  _AtendimentoControllerBase({required this.atendimentoRepository});
  
  @observable
  List<ChatCard> chats = [];

  @observable
  List<Mensagem> mensagens = [];

  @observable
  Status statusCarregaChats = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaMensagens = Status.NAO_CARREGADO;

  @observable
  Status statusEnviarMensagem = Status.NAO_CARREGADO;

  @observable
  Status statusIniciarChat = Status.NAO_CARREGADO;

  @observable
  String mensagemError = '';

  @observable
  ChatCard? chatSelecionado;

  @action
  Future<void> getChats() async {
    try {
      statusCarregaChats = Status.AGUARDANDO;

      chats = await atendimentoRepository.getChats();
      chats.addAll(await atendimentoRepository.getOpenChats());

      statusCarregaChats = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaChats = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @action
  Future<void> getMensagens(int chatId) async {
    try {
      statusCarregaMensagens = Status.AGUARDANDO;
      mensagens = await atendimentoRepository.getMensagens(chatId);
      statusCarregaMensagens = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaMensagens = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @action
  Future<bool> enviarMensagem(int chatId, String mensagem) async {
    try {
      statusEnviarMensagem = Status.AGUARDANDO;
      bool sucesso = await atendimentoRepository.enviarMensagem(chatId, mensagem);
      
      if (sucesso) {
        statusEnviarMensagem = Status.CONCLUIDO;
        // Recarrega as mensagens após enviar
        await getMensagens(chatId);
        return true;
      } else {
        statusEnviarMensagem = Status.ERRO;
        mensagemError = 'Erro ao enviar mensagem';
        return false;
      }
    } catch (e) {
      statusEnviarMensagem = Status.ERRO;
      mensagemError = e.toString();
      return false;
    }
  }

  @action
  Future<bool> iniciarChat(String titulo) async {
    try {
      statusIniciarChat = Status.AGUARDANDO;
      bool sucesso = await atendimentoRepository.iniciarChat(titulo);
      
      if (sucesso) {
        statusIniciarChat = Status.CONCLUIDO;
        // Recarrega a lista de chats após criar um novo
        await getChats();
        return true;
      } else {
        statusIniciarChat = Status.ERRO;
        mensagemError = 'Erro ao criar conversa';
        return false;
      }
    } catch (e) {
      statusIniciarChat = Status.ERRO;
      mensagemError = e.toString();
      return false;
    }
  }

  @action
  Future<bool> joinChat(int id) async {
    try {
      return await atendimentoRepository.joinChat(id);
    } catch (e) {
      return false;
    }
  }

  @action
  void setChatSelecionado(ChatCard? chat) {
    chatSelecionado = chat;
  }

  @action
  void limparMensagens() {
    mensagens.clear();
    statusCarregaMensagens = Status.NAO_CARREGADO;
  }

  @action
  void limparErros() {
    mensagemError = '';
  }
}
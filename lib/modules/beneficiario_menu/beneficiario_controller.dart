import 'package:mobx/mobx.dart';
import 'package:esig_utils/status.dart';
import 'package:sisater_mobile/modules/beneficiario_menu/repository/beneficiario_repository.dart';
import 'package:sisater_mobile/models/atendimento/chat_card.dart';
import 'package:sisater_mobile/models/atendimento/mensagem.dart';
import 'package:sisater_mobile/models/agendamento/agendamento_lista.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/prontuario/prontuario.dart';
import 'package:sisater_mobile/models/autenticacao/usuario_dados.dart';

part 'beneficiario_controller.g.dart';

class BeneficiarioController = _BeneficiarioControllerBase with _$BeneficiarioController;

abstract class _BeneficiarioControllerBase with Store {
  final BeneficiarioRepository _beneficiarioRepository;

  _BeneficiarioControllerBase({required BeneficiarioRepository beneficiarioRepository}) : _beneficiarioRepository = beneficiarioRepository;

  BeneficiarioRepository get repository => _beneficiarioRepository;

  // --- AGENDAMENTOS ---
  @observable
  List<AgendamentoLista> agendamentos = [];

  @observable
  Status statusCarregaAgendamentos = Status.NAO_CARREGADO;

  @observable
  Status statusAgendarVisita = Status.NAO_CARREGADO;

  @observable
  Status statusEditarAgendamento = Status.NAO_CARREGADO;

  @observable
  List<BeneficiarioAter> beneficiariosAterEsloc = [];

  @observable
  Status statusCarregaBeneficiarios = Status.NAO_CARREGADO;

  @observable
  String? errorMessage;

  @action
  Future<void> getAgendamentos() async {
    try {
      statusCarregaAgendamentos = Status.AGUARDANDO;
      errorMessage = null;
      agendamentos = await _beneficiarioRepository.listaAgendamentos();
      statusCarregaAgendamentos = Status.CONCLUIDO;
    } catch (e) {
      errorMessage = 'Erro ao carregar agendamentos';
      statusCarregaAgendamentos = Status.ERRO;
    }
  }

  @action
  Future<void> agendarVisita(AgendamentoLista agendamento, void Function() onSuccess, void Function(String) onError) async {
    statusAgendarVisita = Status.AGUARDANDO;
    try {
      final sucesso = await _beneficiarioRepository.agendarVisita(agendamento);
      if (sucesso == true) {
        statusAgendarVisita = Status.CONCLUIDO;
        onSuccess();
      } else {
        statusAgendarVisita = Status.ERRO;
        onError('Erro ao agendar visita');
      }
    } catch (e) {
      statusAgendarVisita = Status.ERRO;
      onError('Erro ao agendar visita');
    }
  }

  @action
  Future<void> editarAgendamento(int id, AgendamentoLista agendamento, void Function() onSuccess, void Function(String) onError) async {
    statusEditarAgendamento = Status.AGUARDANDO;
    try {
      await _beneficiarioRepository.editarAgendamento(id, agendamento);
      statusEditarAgendamento = Status.CONCLUIDO;
      onSuccess();
    } catch (e) {
      statusEditarAgendamento = Status.ERRO;
      onError('Erro ao editar agendamento');
    }
  }

  @action
  Future<void> deletarAgendamento(int id, void Function() onSuccess, void Function(String) onError) async {
    try {
      final sucesso = await _beneficiarioRepository.deleteAgendamento(id);
      if (sucesso) {
        onSuccess();
      } else {
        onError('Erro ao deletar agendamento');
      }
    } catch (e) {
      onError('Erro ao deletar agendamento');
    }
  }

  // --- CHATS ---
  @observable
  Status statusCarregaChats = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaMensagens = Status.NAO_CARREGADO;

  @observable
  Status statusEnviarMensagem = Status.NAO_CARREGADO;

  @observable
  ObservableList<ChatCard> chats = <ChatCard>[].asObservable();

  @observable
  List<Mensagem> mensagens = [];

  @observable
  ChatCard? chatSelecionado;

  @observable
  String mensagemError = '';

  @action
  void setChatSelecionado(ChatCard? chat) {
    chatSelecionado = chat;
  }

  @action
  Future<void> getChats() async {
    try {
      print('BeneficiarioController: Iniciando carregamento de chats');
      statusCarregaChats = Status.AGUARDANDO;
      mensagemError = '';

      print('BeneficiarioController: Chamando repository.getChats()');
      final chatsList = await _beneficiarioRepository.getChats();
      print('BeneficiarioController: Chats recebidos: ${chatsList.length}');
      
      chats.clear();
      chats.addAll(chatsList);

      statusCarregaChats = Status.CONCLUIDO;
      print('BeneficiarioController: Chats carregados com sucesso');
    } catch (e) {
      print('BeneficiarioController: Erro ao carregar chats: $e');
      statusCarregaChats = Status.ERRO;
      mensagemError = 'Erro ao carregar conversas: $e';
    }
  }

  @action
  Future<void> getMensagens(int chatId) async {
    try {
      print('=== DEBUG BENEFICIARIO CONTROLLER: Iniciando carregamento de mensagens para chat $chatId ===');
      statusCarregaMensagens = Status.AGUARDANDO;
      mensagemError = '';

      mensagens = await _beneficiarioRepository.getMensagens(chatId);
      print('=== DEBUG BENEFICIARIO CONTROLLER: Mensagens recebidas: ${mensagens.length} ===');
      
      statusCarregaMensagens = Status.CONCLUIDO;
      print('=== DEBUG BENEFICIARIO CONTROLLER: Mensagens carregadas com sucesso ===');
    } catch (e) {
      print('=== DEBUG BENEFICIARIO CONTROLLER: Erro ao carregar mensagens: $e ===');
      statusCarregaMensagens = Status.ERRO;
      mensagemError = 'Erro ao carregar mensagens: $e';
    }
  }

  @action
  Future<bool> enviarMensagem(int chatId, String texto) async {
    try {
      print('=== DEBUG BENEFICIARIO CONTROLLER: Iniciando envio de mensagem para chat $chatId ===');
      statusEnviarMensagem = Status.AGUARDANDO;
      mensagemError = '';

      bool sucesso = await _beneficiarioRepository.enviarMensagem(chatId, texto);
      print('=== DEBUG BENEFICIARIO CONTROLLER: Resultado do envio: $sucesso ===');
      
      if (sucesso) {
        statusEnviarMensagem = Status.CONCLUIDO;
        // Recarrega as mensagens após enviar
        print('=== DEBUG BENEFICIARIO CONTROLLER: Recarregando mensagens após envio ===');
        await getMensagens(chatId);
        return true;
      } else {
        print('=== DEBUG BENEFICIARIO CONTROLLER: Falha no envio ===');
        statusEnviarMensagem = Status.ERRO;
        mensagemError = 'Erro ao enviar mensagem';
        return false;
      }
    } catch (e) {
      print('=== DEBUG BENEFICIARIO CONTROLLER: Exceção no envio: $e ===');
      statusEnviarMensagem = Status.ERRO;
      mensagemError = 'Erro ao enviar mensagem: $e';
      return false;
    }
  }

  // --- PRONTUÁRIO ---
  @observable
  Status statusCarregaProntuario = Status.NAO_CARREGADO;

  @observable
  Prontuario? prontuario;

  @observable
  String? prontuarioError;

  @action
  Future<void> carregarProntuario() async {
    try {
      print('=== DEBUG BENEFICIARIO CONTROLLER: Iniciando carregamento do prontuário ===');
      statusCarregaProntuario = Status.AGUARDANDO;
      prontuarioError = null;

      final prontuarioData = await _beneficiarioRepository.getProntuario();
      print('=== DEBUG BENEFICIARIO CONTROLLER: Prontuário carregado com sucesso ===');
      
      prontuario = prontuarioData;
      statusCarregaProntuario = Status.CONCLUIDO;
    } catch (e) {
      print('=== DEBUG BENEFICIARIO CONTROLLER: Erro ao carregar prontuário: $e ===');
      statusCarregaProntuario = Status.ERRO;
      prontuarioError = 'Erro ao carregar prontuário: $e';
    }
  }

  @action
  String? getProntuarioPdfBase64() {
    return prontuario?.data?.pdf_base64;
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

  // --- PERFIL ---
  @observable
  Status statusAlterarFoto = Status.NAO_CARREGADO;

  @observable
  Status statusCarregarDadosUsuario = Status.NAO_CARREGADO;

  @observable
  String? fotoError;

  @action
  Future<bool> alterarFoto(String base64Image) async {
    try {
      statusAlterarFoto = Status.AGUARDANDO;
      fotoError = null;

      final sucesso = await _beneficiarioRepository.ImagemUsuario(base64Image);
      
      if (sucesso) {
        statusAlterarFoto = Status.CONCLUIDO;
        return true;
      } else {
        statusAlterarFoto = Status.ERRO;
        fotoError = 'Erro ao alterar foto';
        return false;
      }
    } catch (e) {
      statusAlterarFoto = Status.ERRO;
      fotoError = 'Erro ao alterar foto: $e';
      return false;
    }
  }

  @action
  Future<UsuarioDados?> carregarDadosUsuario() async {
    try {
      statusCarregarDadosUsuario = Status.AGUARDANDO;
      
      final dadosUsuario = await _beneficiarioRepository.dadosUsuario();
      
      if (dadosUsuario != null) {
        statusCarregarDadosUsuario = Status.CONCLUIDO;
        return dadosUsuario;
      } else {
        statusCarregarDadosUsuario = Status.ERRO;
        return null;
      }
    } catch (e) {
      statusCarregarDadosUsuario = Status.ERRO;
      return null;
    }
  }
}
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beneficiario_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BeneficiarioController on _BeneficiarioControllerBase, Store {
  late final _$agendamentosAtom =
      Atom(name: '_BeneficiarioControllerBase.agendamentos', context: context);

  @override
  List<AgendamentoLista> get agendamentos {
    _$agendamentosAtom.reportRead();
    return super.agendamentos;
  }

  @override
  set agendamentos(List<AgendamentoLista> value) {
    _$agendamentosAtom.reportWrite(value, super.agendamentos, () {
      super.agendamentos = value;
    });
  }

  late final _$statusCarregaAgendamentosAtom = Atom(
      name: '_BeneficiarioControllerBase.statusCarregaAgendamentos',
      context: context);

  @override
  Status get statusCarregaAgendamentos {
    _$statusCarregaAgendamentosAtom.reportRead();
    return super.statusCarregaAgendamentos;
  }

  @override
  set statusCarregaAgendamentos(Status value) {
    _$statusCarregaAgendamentosAtom
        .reportWrite(value, super.statusCarregaAgendamentos, () {
      super.statusCarregaAgendamentos = value;
    });
  }

  late final _$statusAgendarVisitaAtom = Atom(
      name: '_BeneficiarioControllerBase.statusAgendarVisita',
      context: context);

  @override
  Status get statusAgendarVisita {
    _$statusAgendarVisitaAtom.reportRead();
    return super.statusAgendarVisita;
  }

  @override
  set statusAgendarVisita(Status value) {
    _$statusAgendarVisitaAtom.reportWrite(value, super.statusAgendarVisita, () {
      super.statusAgendarVisita = value;
    });
  }

  late final _$statusEditarAgendamentoAtom = Atom(
      name: '_BeneficiarioControllerBase.statusEditarAgendamento',
      context: context);

  @override
  Status get statusEditarAgendamento {
    _$statusEditarAgendamentoAtom.reportRead();
    return super.statusEditarAgendamento;
  }

  @override
  set statusEditarAgendamento(Status value) {
    _$statusEditarAgendamentoAtom
        .reportWrite(value, super.statusEditarAgendamento, () {
      super.statusEditarAgendamento = value;
    });
  }

  late final _$beneficiariosAterEslocAtom = Atom(
      name: '_BeneficiarioControllerBase.beneficiariosAterEsloc',
      context: context);

  @override
  List<BeneficiarioAter> get beneficiariosAterEsloc {
    _$beneficiariosAterEslocAtom.reportRead();
    return super.beneficiariosAterEsloc;
  }

  @override
  set beneficiariosAterEsloc(List<BeneficiarioAter> value) {
    _$beneficiariosAterEslocAtom
        .reportWrite(value, super.beneficiariosAterEsloc, () {
      super.beneficiariosAterEsloc = value;
    });
  }

  late final _$statusCarregaBeneficiariosAtom = Atom(
      name: '_BeneficiarioControllerBase.statusCarregaBeneficiarios',
      context: context);

  @override
  Status get statusCarregaBeneficiarios {
    _$statusCarregaBeneficiariosAtom.reportRead();
    return super.statusCarregaBeneficiarios;
  }

  @override
  set statusCarregaBeneficiarios(Status value) {
    _$statusCarregaBeneficiariosAtom
        .reportWrite(value, super.statusCarregaBeneficiarios, () {
      super.statusCarregaBeneficiarios = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_BeneficiarioControllerBase.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$statusCarregaChatsAtom = Atom(
      name: '_BeneficiarioControllerBase.statusCarregaChats', context: context);

  @override
  Status get statusCarregaChats {
    _$statusCarregaChatsAtom.reportRead();
    return super.statusCarregaChats;
  }

  @override
  set statusCarregaChats(Status value) {
    _$statusCarregaChatsAtom.reportWrite(value, super.statusCarregaChats, () {
      super.statusCarregaChats = value;
    });
  }

  late final _$statusCarregaMensagensAtom = Atom(
      name: '_BeneficiarioControllerBase.statusCarregaMensagens',
      context: context);

  @override
  Status get statusCarregaMensagens {
    _$statusCarregaMensagensAtom.reportRead();
    return super.statusCarregaMensagens;
  }

  @override
  set statusCarregaMensagens(Status value) {
    _$statusCarregaMensagensAtom
        .reportWrite(value, super.statusCarregaMensagens, () {
      super.statusCarregaMensagens = value;
    });
  }

  late final _$statusEnviarMensagemAtom = Atom(
      name: '_BeneficiarioControllerBase.statusEnviarMensagem',
      context: context);

  @override
  Status get statusEnviarMensagem {
    _$statusEnviarMensagemAtom.reportRead();
    return super.statusEnviarMensagem;
  }

  @override
  set statusEnviarMensagem(Status value) {
    _$statusEnviarMensagemAtom.reportWrite(value, super.statusEnviarMensagem,
        () {
      super.statusEnviarMensagem = value;
    });
  }

  late final _$chatsAtom =
      Atom(name: '_BeneficiarioControllerBase.chats', context: context);

  @override
  ObservableList<ChatCard> get chats {
    _$chatsAtom.reportRead();
    return super.chats;
  }

  @override
  set chats(ObservableList<ChatCard> value) {
    _$chatsAtom.reportWrite(value, super.chats, () {
      super.chats = value;
    });
  }

  late final _$mensagensAtom =
      Atom(name: '_BeneficiarioControllerBase.mensagens', context: context);

  @override
  List<Mensagem> get mensagens {
    _$mensagensAtom.reportRead();
    return super.mensagens;
  }

  @override
  set mensagens(List<Mensagem> value) {
    _$mensagensAtom.reportWrite(value, super.mensagens, () {
      super.mensagens = value;
    });
  }

  late final _$chatSelecionadoAtom = Atom(
      name: '_BeneficiarioControllerBase.chatSelecionado', context: context);

  @override
  ChatCard? get chatSelecionado {
    _$chatSelecionadoAtom.reportRead();
    return super.chatSelecionado;
  }

  @override
  set chatSelecionado(ChatCard? value) {
    _$chatSelecionadoAtom.reportWrite(value, super.chatSelecionado, () {
      super.chatSelecionado = value;
    });
  }

  late final _$mensagemErrorAtom =
      Atom(name: '_BeneficiarioControllerBase.mensagemError', context: context);

  @override
  String get mensagemError {
    _$mensagemErrorAtom.reportRead();
    return super.mensagemError;
  }

  @override
  set mensagemError(String value) {
    _$mensagemErrorAtom.reportWrite(value, super.mensagemError, () {
      super.mensagemError = value;
    });
  }

  late final _$statusCarregaProntuarioAtom = Atom(
      name: '_BeneficiarioControllerBase.statusCarregaProntuario',
      context: context);

  @override
  Status get statusCarregaProntuario {
    _$statusCarregaProntuarioAtom.reportRead();
    return super.statusCarregaProntuario;
  }

  @override
  set statusCarregaProntuario(Status value) {
    _$statusCarregaProntuarioAtom
        .reportWrite(value, super.statusCarregaProntuario, () {
      super.statusCarregaProntuario = value;
    });
  }

  late final _$prontuarioAtom =
      Atom(name: '_BeneficiarioControllerBase.prontuario', context: context);

  @override
  Prontuario? get prontuario {
    _$prontuarioAtom.reportRead();
    return super.prontuario;
  }

  @override
  set prontuario(Prontuario? value) {
    _$prontuarioAtom.reportWrite(value, super.prontuario, () {
      super.prontuario = value;
    });
  }

  late final _$prontuarioErrorAtom = Atom(
      name: '_BeneficiarioControllerBase.prontuarioError', context: context);

  @override
  String? get prontuarioError {
    _$prontuarioErrorAtom.reportRead();
    return super.prontuarioError;
  }

  @override
  set prontuarioError(String? value) {
    _$prontuarioErrorAtom.reportWrite(value, super.prontuarioError, () {
      super.prontuarioError = value;
    });
  }

  late final _$statusAlterarFotoAtom = Atom(
      name: '_BeneficiarioControllerBase.statusAlterarFoto', context: context);

  @override
  Status get statusAlterarFoto {
    _$statusAlterarFotoAtom.reportRead();
    return super.statusAlterarFoto;
  }

  @override
  set statusAlterarFoto(Status value) {
    _$statusAlterarFotoAtom.reportWrite(value, super.statusAlterarFoto, () {
      super.statusAlterarFoto = value;
    });
  }

  late final _$statusCarregarDadosUsuarioAtom = Atom(
      name: '_BeneficiarioControllerBase.statusCarregarDadosUsuario',
      context: context);

  @override
  Status get statusCarregarDadosUsuario {
    _$statusCarregarDadosUsuarioAtom.reportRead();
    return super.statusCarregarDadosUsuario;
  }

  @override
  set statusCarregarDadosUsuario(Status value) {
    _$statusCarregarDadosUsuarioAtom
        .reportWrite(value, super.statusCarregarDadosUsuario, () {
      super.statusCarregarDadosUsuario = value;
    });
  }

  late final _$fotoErrorAtom =
      Atom(name: '_BeneficiarioControllerBase.fotoError', context: context);

  @override
  String? get fotoError {
    _$fotoErrorAtom.reportRead();
    return super.fotoError;
  }

  @override
  set fotoError(String? value) {
    _$fotoErrorAtom.reportWrite(value, super.fotoError, () {
      super.fotoError = value;
    });
  }

  late final _$getAgendamentosAsyncAction = AsyncAction(
      '_BeneficiarioControllerBase.getAgendamentos',
      context: context);

  @override
  Future<void> getAgendamentos() {
    return _$getAgendamentosAsyncAction.run(() => super.getAgendamentos());
  }

  late final _$agendarVisitaAsyncAction = AsyncAction(
      '_BeneficiarioControllerBase.agendarVisita',
      context: context);

  @override
  Future<void> agendarVisita(AgendamentoLista agendamento,
      void Function() onSuccess, void Function(String) onError) {
    return _$agendarVisitaAsyncAction
        .run(() => super.agendarVisita(agendamento, onSuccess, onError));
  }

  late final _$editarAgendamentoAsyncAction = AsyncAction(
      '_BeneficiarioControllerBase.editarAgendamento',
      context: context);

  @override
  Future<void> editarAgendamento(int id, AgendamentoLista agendamento,
      void Function() onSuccess, void Function(String) onError) {
    return _$editarAgendamentoAsyncAction.run(
        () => super.editarAgendamento(id, agendamento, onSuccess, onError));
  }

  late final _$deletarAgendamentoAsyncAction = AsyncAction(
      '_BeneficiarioControllerBase.deletarAgendamento',
      context: context);

  @override
  Future<void> deletarAgendamento(
      int id, void Function() onSuccess, void Function(String) onError) {
    return _$deletarAgendamentoAsyncAction
        .run(() => super.deletarAgendamento(id, onSuccess, onError));
  }

  late final _$getChatsAsyncAction =
      AsyncAction('_BeneficiarioControllerBase.getChats', context: context);

  @override
  Future<void> getChats() {
    return _$getChatsAsyncAction.run(() => super.getChats());
  }

  late final _$getMensagensAsyncAction =
      AsyncAction('_BeneficiarioControllerBase.getMensagens', context: context);

  @override
  Future<void> getMensagens(int chatId) {
    return _$getMensagensAsyncAction.run(() => super.getMensagens(chatId));
  }

  late final _$enviarMensagemAsyncAction = AsyncAction(
      '_BeneficiarioControllerBase.enviarMensagem',
      context: context);

  @override
  Future<bool> enviarMensagem(int chatId, String texto) {
    return _$enviarMensagemAsyncAction
        .run(() => super.enviarMensagem(chatId, texto));
  }

  late final _$carregarProntuarioAsyncAction = AsyncAction(
      '_BeneficiarioControllerBase.carregarProntuario',
      context: context);

  @override
  Future<void> carregarProntuario() {
    return _$carregarProntuarioAsyncAction
        .run(() => super.carregarProntuario());
  }

  late final _$alterarFotoAsyncAction =
      AsyncAction('_BeneficiarioControllerBase.alterarFoto', context: context);

  @override
  Future<bool> alterarFoto(String base64Image) {
    return _$alterarFotoAsyncAction.run(() => super.alterarFoto(base64Image));
  }

  late final _$carregarDadosUsuarioAsyncAction = AsyncAction(
      '_BeneficiarioControllerBase.carregarDadosUsuario',
      context: context);

  @override
  Future<UsuarioDados?> carregarDadosUsuario() {
    return _$carregarDadosUsuarioAsyncAction
        .run(() => super.carregarDadosUsuario());
  }

  late final _$_BeneficiarioControllerBaseActionController =
      ActionController(name: '_BeneficiarioControllerBase', context: context);

  @override
  void setChatSelecionado(ChatCard? chat) {
    final _$actionInfo = _$_BeneficiarioControllerBaseActionController
        .startAction(name: '_BeneficiarioControllerBase.setChatSelecionado');
    try {
      return super.setChatSelecionado(chat);
    } finally {
      _$_BeneficiarioControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String? getProntuarioPdfBase64() {
    final _$actionInfo =
        _$_BeneficiarioControllerBaseActionController.startAction(
            name: '_BeneficiarioControllerBase.getProntuarioPdfBase64');
    try {
      return super.getProntuarioPdfBase64();
    } finally {
      _$_BeneficiarioControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparMensagens() {
    final _$actionInfo = _$_BeneficiarioControllerBaseActionController
        .startAction(name: '_BeneficiarioControllerBase.limparMensagens');
    try {
      return super.limparMensagens();
    } finally {
      _$_BeneficiarioControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparErros() {
    final _$actionInfo = _$_BeneficiarioControllerBaseActionController
        .startAction(name: '_BeneficiarioControllerBase.limparErros');
    try {
      return super.limparErros();
    } finally {
      _$_BeneficiarioControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
agendamentos: ${agendamentos},
statusCarregaAgendamentos: ${statusCarregaAgendamentos},
statusAgendarVisita: ${statusAgendarVisita},
statusEditarAgendamento: ${statusEditarAgendamento},
beneficiariosAterEsloc: ${beneficiariosAterEsloc},
statusCarregaBeneficiarios: ${statusCarregaBeneficiarios},
errorMessage: ${errorMessage},
statusCarregaChats: ${statusCarregaChats},
statusCarregaMensagens: ${statusCarregaMensagens},
statusEnviarMensagem: ${statusEnviarMensagem},
chats: ${chats},
mensagens: ${mensagens},
chatSelecionado: ${chatSelecionado},
mensagemError: ${mensagemError},
statusCarregaProntuario: ${statusCarregaProntuario},
prontuario: ${prontuario},
prontuarioError: ${prontuarioError},
statusAlterarFoto: ${statusAlterarFoto},
statusCarregarDadosUsuario: ${statusCarregarDadosUsuario},
fotoError: ${fotoError}
    ''';
  }
}

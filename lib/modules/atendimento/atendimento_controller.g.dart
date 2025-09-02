// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atendimento_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AtendimentoController on _AtendimentoControllerBase, Store {
  late final _$chatsAtom =
      Atom(name: '_AtendimentoControllerBase.chats', context: context);

  @override
  List<ChatCard> get chats {
    _$chatsAtom.reportRead();
    return super.chats;
  }

  @override
  set chats(List<ChatCard> value) {
    _$chatsAtom.reportWrite(value, super.chats, () {
      super.chats = value;
    });
  }

  late final _$mensagensAtom =
      Atom(name: '_AtendimentoControllerBase.mensagens', context: context);

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

  late final _$statusCarregaChatsAtom = Atom(
      name: '_AtendimentoControllerBase.statusCarregaChats', context: context);

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
      name: '_AtendimentoControllerBase.statusCarregaMensagens',
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
      name: '_AtendimentoControllerBase.statusEnviarMensagem',
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

  late final _$statusIniciarChatAtom = Atom(
      name: '_AtendimentoControllerBase.statusIniciarChat', context: context);

  @override
  Status get statusIniciarChat {
    _$statusIniciarChatAtom.reportRead();
    return super.statusIniciarChat;
  }

  @override
  set statusIniciarChat(Status value) {
    _$statusIniciarChatAtom.reportWrite(value, super.statusIniciarChat, () {
      super.statusIniciarChat = value;
    });
  }

  late final _$mensagemErrorAtom =
      Atom(name: '_AtendimentoControllerBase.mensagemError', context: context);

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

  late final _$chatSelecionadoAtom = Atom(
      name: '_AtendimentoControllerBase.chatSelecionado', context: context);

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

  late final _$getChatsAsyncAction =
      AsyncAction('_AtendimentoControllerBase.getChats', context: context);

  @override
  Future<void> getChats() {
    return _$getChatsAsyncAction.run(() => super.getChats());
  }

  late final _$getMensagensAsyncAction =
      AsyncAction('_AtendimentoControllerBase.getMensagens', context: context);

  @override
  Future<void> getMensagens(int chatId) {
    return _$getMensagensAsyncAction.run(() => super.getMensagens(chatId));
  }

  late final _$enviarMensagemAsyncAction = AsyncAction(
      '_AtendimentoControllerBase.enviarMensagem',
      context: context);

  @override
  Future<bool> enviarMensagem(int chatId, String mensagem) {
    return _$enviarMensagemAsyncAction
        .run(() => super.enviarMensagem(chatId, mensagem));
  }

  late final _$iniciarChatAsyncAction =
      AsyncAction('_AtendimentoControllerBase.iniciarChat', context: context);

  @override
  Future<bool> iniciarChat(String titulo) {
    return _$iniciarChatAsyncAction.run(() => super.iniciarChat(titulo));
  }

  late final _$joinChatAsyncAction =
      AsyncAction('_AtendimentoControllerBase.joinChat', context: context);

  @override
  Future<bool> joinChat(int id) {
    return _$joinChatAsyncAction.run(() => super.joinChat(id));
  }

  late final _$_AtendimentoControllerBaseActionController =
      ActionController(name: '_AtendimentoControllerBase', context: context);

  @override
  void setChatSelecionado(ChatCard? chat) {
    final _$actionInfo = _$_AtendimentoControllerBaseActionController
        .startAction(name: '_AtendimentoControllerBase.setChatSelecionado');
    try {
      return super.setChatSelecionado(chat);
    } finally {
      _$_AtendimentoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparMensagens() {
    final _$actionInfo = _$_AtendimentoControllerBaseActionController
        .startAction(name: '_AtendimentoControllerBase.limparMensagens');
    try {
      return super.limparMensagens();
    } finally {
      _$_AtendimentoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparErros() {
    final _$actionInfo = _$_AtendimentoControllerBaseActionController
        .startAction(name: '_AtendimentoControllerBase.limparErros');
    try {
      return super.limparErros();
    } finally {
      _$_AtendimentoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
chats: ${chats},
mensagens: ${mensagens},
statusCarregaChats: ${statusCarregaChats},
statusCarregaMensagens: ${statusCarregaMensagens},
statusEnviarMensagem: ${statusEnviarMensagem},
statusIniciarChat: ${statusIniciarChat},
mensagemError: ${mensagemError},
chatSelecionado: ${chatSelecionado}
    ''';
  }
}

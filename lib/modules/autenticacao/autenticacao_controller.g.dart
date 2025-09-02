// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autenticacao_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AutenticacaoController on _AutenticacaoControllerBase, Store {
  late final _$statusLoginAtom =
      Atom(name: '_AutenticacaoControllerBase.statusLogin', context: context);

  @override
  StatusLogin get statusLogin {
    _$statusLoginAtom.reportRead();
    return super.statusLogin;
  }

  @override
  set statusLogin(StatusLogin value) {
    _$statusLoginAtom.reportWrite(value, super.statusLogin, () {
      super.statusLogin = value;
    });
  }

  late final _$statusCarregaUsuarioAtom = Atom(
      name: '_AutenticacaoControllerBase.statusCarregaUsuario',
      context: context);

  @override
  Status get statusCarregaUsuario {
    _$statusCarregaUsuarioAtom.reportRead();
    return super.statusCarregaUsuario;
  }

  @override
  set statusCarregaUsuario(Status value) {
    _$statusCarregaUsuarioAtom.reportWrite(value, super.statusCarregaUsuario,
        () {
      super.statusCarregaUsuario = value;
    });
  }

  late final _$statusEmailEsqueciSenhaAtom = Atom(
      name: '_AutenticacaoControllerBase.statusEmailEsqueciSenha',
      context: context);

  @override
  Status get statusEmailEsqueciSenha {
    _$statusEmailEsqueciSenhaAtom.reportRead();
    return super.statusEmailEsqueciSenha;
  }

  @override
  set statusEmailEsqueciSenha(Status value) {
    _$statusEmailEsqueciSenhaAtom
        .reportWrite(value, super.statusEmailEsqueciSenha, () {
      super.statusEmailEsqueciSenha = value;
    });
  }

  late final _$statusEmailRedefinirSenhaAtom = Atom(
      name: '_AutenticacaoControllerBase.statusEmailRedefinirSenha',
      context: context);

  @override
  Status get statusEmailRedefinirSenha {
    _$statusEmailRedefinirSenhaAtom.reportRead();
    return super.statusEmailRedefinirSenha;
  }

  @override
  set statusEmailRedefinirSenha(Status value) {
    _$statusEmailRedefinirSenhaAtom
        .reportWrite(value, super.statusEmailRedefinirSenha, () {
      super.statusEmailRedefinirSenha = value;
    });
  }

  late final _$manterLogadoAtom =
      Atom(name: '_AutenticacaoControllerBase.manterLogado', context: context);

  @override
  bool get manterLogado {
    _$manterLogadoAtom.reportRead();
    return super.manterLogado;
  }

  @override
  set manterLogado(bool value) {
    _$manterLogadoAtom.reportWrite(value, super.manterLogado, () {
      super.manterLogado = value;
    });
  }

  late final _$loginPostAtom =
      Atom(name: '_AutenticacaoControllerBase.loginPost', context: context);

  @override
  LoginPost? get loginPost {
    _$loginPostAtom.reportRead();
    return super.loginPost;
  }

  @override
  set loginPost(LoginPost? value) {
    _$loginPostAtom.reportWrite(value, super.loginPost, () {
      super.loginPost = value;
    });
  }

  late final _$usuarioDadosAtom =
      Atom(name: '_AutenticacaoControllerBase.usuarioDados', context: context);

  @override
  UsuarioDados? get usuarioDados {
    _$usuarioDadosAtom.reportRead();
    return super.usuarioDados;
  }

  @override
  set usuarioDados(UsuarioDados? value) {
    _$usuarioDadosAtom.reportWrite(value, super.usuarioDados, () {
      super.usuarioDados = value;
    });
  }

  late final _$mensagemErroLoginAtom = Atom(
      name: '_AutenticacaoControllerBase.mensagemErroLogin', context: context);

  @override
  String get mensagemErroLogin {
    _$mensagemErroLoginAtom.reportRead();
    return super.mensagemErroLogin;
  }

  @override
  set mensagemErroLogin(String value) {
    _$mensagemErroLoginAtom.reportWrite(value, super.mensagemErroLogin, () {
      super.mensagemErroLogin = value;
    });
  }

  late final _$loginAsyncAction =
      AsyncAction('_AutenticacaoControllerBase.login', context: context);

  @override
  Future<dynamic> login(String cpf, String senha) {
    return _$loginAsyncAction.run(() => super.login(cpf, senha));
  }

  late final _$logoutAsyncAction =
      AsyncAction('_AutenticacaoControllerBase.logout', context: context);

  @override
  Future<dynamic> logout([StatusLogin? status]) {
    return _$logoutAsyncAction.run(() => super.logout(status));
  }

  @override
  String toString() {
    return '''
statusLogin: ${statusLogin},
statusCarregaUsuario: ${statusCarregaUsuario},
statusEmailEsqueciSenha: ${statusEmailEsqueciSenha},
statusEmailRedefinirSenha: ${statusEmailRedefinirSenha},
manterLogado: ${manterLogado},
loginPost: ${loginPost},
usuarioDados: ${usuarioDados},
mensagemErroLogin: ${mensagemErroLogin}
    ''';
  }
}

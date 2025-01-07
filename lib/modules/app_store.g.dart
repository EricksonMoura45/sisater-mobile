// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStoreBase, Store {
  Computed<dynamic>? _$isLogadoComputed;

  @override
  dynamic get isLogado =>
      (_$isLogadoComputed ??= Computed<dynamic>(() => super.isLogado,
              name: '_AppStoreBase.isLogado'))
          .value;

  late final _$loginResponseAtom =
      Atom(name: '_AppStoreBase.loginResponse', context: context);

  @override
  LoginResponse? get loginResponse {
    _$loginResponseAtom.reportRead();
    return super.loginResponse;
  }

  @override
  set loginResponse(LoginResponse? value) {
    _$loginResponseAtom.reportWrite(value, super.loginResponse, () {
      super.loginResponse = value;
    });
  }

  late final _$usuarioDadosAtom =
      Atom(name: '_AppStoreBase.usuarioDados', context: context);

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

  late final _$carregarDadosAsyncAction =
      AsyncAction('_AppStoreBase.carregarDados', context: context);

  @override
  Future<dynamic> carregarDados() {
    return _$carregarDadosAsyncAction.run(() => super.carregarDados());
  }

  late final _$logoutAsyncAction =
      AsyncAction('_AppStoreBase.logout', context: context);

  @override
  Future<dynamic> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  @override
  String toString() {
    return '''
loginResponse: ${loginResponse},
usuarioDados: ${usuarioDados},
isLogado: ${isLogado}
    ''';
  }
}

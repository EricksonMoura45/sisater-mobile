import 'package:enviroment_flavor/enviroment_flavor.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:loading_empty_error/snackbar.dart';
import 'package:mobx/mobx.dart';
import 'package:one_context/one_context.dart';
import 'package:sisater_mobile/models/autenticacao/login_response.dart';
import 'package:sisater_mobile/models/autenticacao/usuario_dados.dart';
import 'package:sisater_mobile/modules/autenticacao/exceptions/login_nao_persistido.dart';
import 'package:sisater_mobile/shared/utils/crashlytics_handler.dart';
import 'package:sisater_mobile/shared/utils/shared_prefs.dart';
import 'dart:developer' as developer;

part 'app_store.g.dart';

class AppStore = _AppStoreBase with _$AppStore;

abstract class _AppStoreBase with Store {

  final prefs = SharedPrefs();
  late final String appVersion;

  _AppStoreBase() {
    final envFlavor = EnvironmentFlavor();
    final appVersion = envFlavor.getProperty('appVersion');
    final buildNumber = envFlavor.getProperty('buildNumber');
    this.appVersion = 'v$appVersion+$buildNumber';
  }
  
  @observable
  LoginResponse? loginResponse;

  @observable
  UsuarioDados? usuarioDados;

  @computed
  get isLogado => loginResponse != null;


  void updateLoginResponse(LoginResponse newValue) {
    loginResponse?.accessToken = newValue.accessToken;
  }


  void persistirDadosLogin() async {
    try {
      final loginSalvo = await prefs.save(
        SharedPrefs.loginResponseKey,
        loginResponse,
      );

      final usuarioSalvo = await prefs.save(
        SharedPrefs.dashboardResponseKey, 
        usuarioDados
        );

      if (!loginSalvo) {
        throw LoginNaoPersistidoException();
      }

      if (!usuarioSalvo) {
        throw Exception();
      }
    } on LoginNaoPersistidoException catch (e) {
      getEsigSnackBar(
        e.msg,
        context: OneContext().context,
        duracao: 3,
      );
      CrashlyticsHandler.reportException(
        e,
        key: 'app_store.dart',
        value: 'SharedPrefsError',
      );
    }
  }

   @action
  Future carregarDados() async {
    final isloginSalvo = await prefs.contem(SharedPrefs.loginResponseKey);
    final isUsuarioSalvo = await prefs.contem(SharedPrefs.dashboardResponseKey);
  
    loginResponse = isloginSalvo
        ? LoginResponse.fromJson(
            await prefs.read(SharedPrefs.loginResponseKey),
          )
        : null;

    usuarioDados = isUsuarioSalvo
        ? UsuarioDados.fromJson(
            await prefs.read(SharedPrefs.loginResponseKey),
          )
        : null;    
  }

  @action
  Future logout() async {
    final storedKeys = await prefs.getKeys();
    final removedKeys = <String, bool>{};

    for (var key in storedKeys) {
      removedKeys[key] = await prefs.remove(key);
    }
    developer.log('removedKeys: $removedKeys');

    loginResponse = null;
    //permissoes = null;
    Modular.to.pushReplacementNamed('/login_page');
    return removedKeys;
  }

}
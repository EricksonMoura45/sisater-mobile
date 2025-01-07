import 'package:dio/dio.dart';
import 'package:esig_utils/status.dart';
import 'package:esig_utils/status_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
import 'package:sisater_mobile/models/autenticacao/login_post.dart';
import 'package:sisater_mobile/models/autenticacao/usuario_dados.dart';
import 'package:sisater_mobile/modules/app_store.dart';
import 'package:sisater_mobile/modules/autenticacao/repositories/autenticacao_repository.dart';
import 'package:sisater_mobile/shared/utils/Themes.dart';
import 'package:sisater_mobile/shared/utils/shared_prefs.dart';
part 'autenticacao_controller.g.dart';

class AutenticacaoController = _AutenticacaoControllerBase with _$AutenticacaoController;

abstract class _AutenticacaoControllerBase with Store {
  final AutenticacaoRepository _authRepository;
  _AutenticacaoControllerBase(this._authRepository);
  
  final AppStore appStore = Modular.get();

  @observable
  StatusLogin statusLogin = StatusLogin.DESLOGADO;

  @observable
  Status statusCarregaUsuario = Status.NAO_CARREGADO;

  int? esqueciSenhaCode;

  String? emailUsuario;

  @observable
  Status statusEmailEsqueciSenha = Status.NAO_CARREGADO;

  @observable
  Status statusEmailRedefinirSenha = Status.NAO_CARREGADO;

  @observable
  bool manterLogado = false;

  @observable
  LoginPost? loginPost;

  @observable
  UsuarioDados? usuarioDados;

  @action
  Future login(String cpf, String senha) async {
    try {

      loginPost = LoginPost(
        grantType: 'user_credentials',
        document: cpf,
        password: senha,
        clientId: '8d980c9b7b1060f2e0d9265d588e9f23',
        clientSecret: 'c61f0c4b13f86e7dd928bcd143ef2864'
      );
      
      statusLogin = StatusLogin.AGUARDANDO;
      appStore.loginResponse = await _authRepository.login(loginPost!);
      
       await appStore.prefs.saveSenha(senha);
       await carregaUsuario();
       //TODO arrumar 'lembrar-me'
      if(manterLogado){
        appStore.persistirDadosLogin();
      }
      
      
      if (_authRepository.statusLogin == true) {
        statusLogin = StatusLogin.LOGADO;
        Modular.to.pushReplacementNamed('/home');
        print(appStore.usuarioDados);

      } else {
        Fluttertoast.showToast(
            //TODO Colocar toast numa função global
            msg: "Erro ao realizar login, tente novamente.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Themes.corBaseApp.withOpacity(.5),
            textColor: Colors.red.withOpacity(.5),
            fontSize: 16.0);
      }
    } on DioException catch (e) {
      print(e);
      if (e.type == DioExceptionType.connectionTimeout) {
        statusLogin.mensagem =
            'Tempo de espera excedido. Tente novamente mais tarde.';
      } else if (e.type == DioExceptionType.unknown) {
        statusLogin.mensagem =
            'Por favor, verifique sua conexão com a internet e tente novamente.';
      } else {
        statusLogin.mensagem =
            'Login ou senha incorreta. Verifique suas credenciais e tente novamente. Cód: ${e.response?.statusCode}';
      }
      statusLogin = StatusLogin.ERRO;
    }
  }

  Future carregaUsuario() async{
    try {
      statusCarregaUsuario = Status.AGUARDANDO;
      usuarioDados = await _authRepository.dadosUsuario();

      if(_authRepository.statusDadosUsuario == true){
        statusCarregaUsuario = Status.CONCLUIDO;

      }
    } catch (e) {
      statusCarregaUsuario = Status.ERRO;
      statusCarregaUsuario.mensagem = 'Erro ao carregar dados do usuário.';
    }
  }


  Future verificarDadoPersistidos() async {
    try {
      
      await appStore.carregarDados();

       final isloginSalvo = appStore.loginResponse != null;

       if (!isloginSalvo) {
        
        //await appStore.prefs.remove(SharedPrefs.dashboardResponseKey);
        await appStore.prefs.remove(SharedPrefs.loginResponseKey);

        Modular.to.navigate('/login_page');

       } else {

          Modular.to.navigate('/home');

       }
    } catch (e) {
       appStore.logout();
    }
  }

  @action
  Future logout([StatusLogin? status]) async {
    AppStore appStore = Modular.get();
     await appStore.logout();
    statusLogin = status ?? StatusLogin.DESLOGADO;
  }

  // Future<void> esqueciSenha(String email) async {
  //   try {
  //     await _authRepository.esqueciSenha(email);
  //     statusEmailEsqueciSenha = Status.AGUARDANDO;
  //     if (_authRepository.statusEsqueciSenha == true) {
  //       statusEmailEsqueciSenha = Status.CONCLUIDO;
  //       Fluttertoast.showToast(
  //           msg: "Um código foi enviado para seu email.",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.CENTER,
  //           timeInSecForIosWeb: 3,
  //           backgroundColor: Themes.corBaseApp.withOpacity(.5),
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       Modular.to.navigate('/recuperar_senha');
  //     } else {
  //       Fluttertoast.showToast(
  //           //TODO Colocar toast numa função global
  //           msg: "Email não encontrado, tente novamente.",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.CENTER,
  //           timeInSecForIosWeb: 3,
  //           backgroundColor: Themes.corBaseApp.withOpacity(.5),
  //           textColor: Colors.red.withOpacity(.5),
  //           fontSize: 16.0);
  //     }
  //   } catch (e) {
  //     statusEmailEsqueciSenha = Status.ERRO;
  //     Fluttertoast.showToast(
  //         msg: "Email Inválido.",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 3,
  //         backgroundColor: Themes.corBaseApp.withOpacity(.5),
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }

  // Future<void> RedefinirSenha(String email, String codigo, String senha) async {
  //   try {
  //     await _authRepository.redefinirSenha(email, codigo, senha);
  //     statusEmailRedefinirSenha = Status.AGUARDANDO;
  //     if (_authRepository.statusRedefinirSenha == true) {
  //       Fluttertoast.showToast(
  //           msg: "Senha redefinida com sucesso!",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.CENTER,
  //           timeInSecForIosWeb: 3,
  //           backgroundColor: Themes.corBaseApp.withOpacity(.5),
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       statusEmailRedefinirSenha = Status.CONCLUIDO;
  //       Modular.to.navigate('/login_page');
  //     } else {
  //       Fluttertoast.showToast(
  //           //TODO Colocar toast numa função global
  //           msg: "Não foi possível redefinir a senha, tente novamente.",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.CENTER,
  //           timeInSecForIosWeb: 3,
  //           backgroundColor: Themes.corBaseApp.withOpacity(.5),
  //           textColor: Colors.red.withOpacity(.5),
  //           fontSize: 16.0);
  //     }
  //   } catch (e) {
  //     statusEmailRedefinirSenha = Status.ERRO;
  //     Fluttertoast.showToast(
  //         msg: "Não foi possível redefinir sua senha, tente mais tarde.",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 3,
  //         backgroundColor: Themes.corBaseApp.withOpacity(.5),
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }
}
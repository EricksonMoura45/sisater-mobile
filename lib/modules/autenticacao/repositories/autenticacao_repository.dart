import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/models/autenticacao/login_post.dart';
import 'package:sisater_mobile/models/autenticacao/login_response.dart';
import 'package:sisater_mobile/models/autenticacao/usuario_dados.dart';
import 'package:sisater_mobile/modules/app_store.dart';

class AutenticacaoRepository {
  final Dio _dioBase;
  AppStore appStore = Modular.get();
  bool? statusLogin = false;
  bool? statusDadosUsuario = false;

  AutenticacaoRepository(this._dioBase);

  Future<LoginResponse?> login(LoginPost loginPost) async{
    var response = await _dioBase.post(
      '/oauth2/token',
      data: loginPost.toJson()
    );
    if(response.statusCode == 200){
      statusLogin = true;
    }
    return LoginResponse.fromJson(response.data);
  }

  Future<UsuarioDados?> dadosUsuario()async{

    var response = await _dioBase.get('/me');

    if(response.statusCode == 200){
      statusDadosUsuario = true;
    }

    return UsuarioDados.fromJson(response.data);
  }
}
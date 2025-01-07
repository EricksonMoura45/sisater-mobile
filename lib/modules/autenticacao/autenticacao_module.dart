import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/autenticacao/autenticacao_controller.dart';
import 'package:sisater_mobile/modules/autenticacao/pages/login_page.dart';
import 'package:sisater_mobile/modules/autenticacao/pages/splashscreen_page.dart';
import 'package:sisater_mobile/modules/autenticacao/repositories/autenticacao_repository.dart';
import 'package:sisater_mobile/shared/utils/custom_dio.dart';

class AutenticacaoModule extends Module{
  @override
  List<Bind> get binds => [
        Bind<AutenticacaoRepository>(
          (i) => AutenticacaoRepository(i.get<CustomDio>().dio),
        ),
        Bind(
          (i) => AutenticacaoController(i.get<AutenticacaoRepository>()),
        ),
      ];
   @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, args) => const SplashScreenPage(),
          transition: TransitionType.leftToRight
        ),
        ChildRoute(
          '/login_page',
          child: (_, args) => const LoginPage(),
          transition: TransitionType.downToUp,
        ),
        // ModuleRoute(
        //   '/autocadastro',
        //   module: AutoCadastroModule(),
        //   transition: TransitionType.fadeIn,
        // ),
        // ModuleRoute(
        //   '/home',
        //   module: HomeModule(),
        //   transition: TransitionType.fadeIn,
        // ),
        // ChildRoute(
        //   '/esqueci_senha',
        //   child: (_, args) => const EsqueciSenhaPage(),
        //   transition: TransitionType.fadeIn,
        // ),
        // ChildRoute(
        //   '/recuperar_senha',
        //   child: (_, args) => const RecuperarSenhaPage(),
        //   transition: TransitionType.fadeIn,
        // ),
        // ChildRoute(
        //   '/politicas_privacidade',
        //   child: (_, args) => const PoliticasPrivacidadePage(),
        //   transition: TransitionType.fadeIn,
        // ),
      ];   
}
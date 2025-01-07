import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/autenticacao/autenticacao_controller.dart';
import 'package:sisater_mobile/modules/autenticacao/repositories/autenticacao_repository.dart';
import 'package:sisater_mobile/modules/home/home_controller.dart';
import 'package:sisater_mobile/modules/home/pages/home_page.dart';
import 'package:sisater_mobile/modules/home/repository/home_repository.dart';
import 'package:sisater_mobile/shared/utils/custom_dio.dart';

class HomeModule extends Module{
   @override
  List<Bind> get binds => [
        Bind<AutenticacaoRepository>(
          (i) => AutenticacaoRepository(i.get<CustomDio>().dio),
        ),
        Bind<AutenticacaoController>(
          (i) => AutenticacaoController(i.get<AutenticacaoRepository>()),
        ),
        Bind<HomeRepository>(
          (i) => HomeRepository(i.get<CustomDio>().dio),
        ),
        Bind(
          (i) => HomeController(i.get<HomeRepository>()),
        ),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(
      Modular.initialRoute, 
      child: (_, args) => HomePage(),
          transition: TransitionType.fadeIn 
      )
  ];
}
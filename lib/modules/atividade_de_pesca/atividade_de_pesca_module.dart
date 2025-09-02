import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/atividade_de_pesca/atividade_de_pesca_controller.dart';
import 'package:sisater_mobile/modules/atividade_de_pesca/pages/atividade_de_pesca_page.dart';
import 'package:sisater_mobile/modules/atividade_de_pesca/pages/cadastrar_atividade_pesca_page.dart';
import 'package:sisater_mobile/modules/atividade_de_pesca/pages/editar_atividade_pesca_page.dart';
import 'package:sisater_mobile/modules/atividade_de_pesca/pages/visualizar_atividade_pesca_page.dart';
import 'package:sisater_mobile/modules/atividade_de_pesca/repository/atividade_de_pesca_repository.dart';
import 'package:sisater_mobile/shared/utils/custom_dio.dart';

class AtividadeDePescaModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => AtividadeDePescaRepository(i.get<CustomDio>().dio)),
        Bind((i) => AtividadeDePescaController(i.get<AtividadeDePescaRepository>())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (context, args) => const AtividadeDePescaPage(),
          transition: TransitionType.downToUp,
        ),
        ChildRoute(
          '/cadastrar_atividade_de_pesca',
          child: (context, args) => const CadastrarAtividadePescaPage(),
          transition: TransitionType.downToUp,
        ),
        ChildRoute(
          '/editar_atividade_de_pesca',
          child: (context, args) => const EditarAtividadePescaPage(),
          transition: TransitionType.downToUp,
        ),
        ChildRoute(
          '/visualizar_atividade_de_pesca',
          child: (context, args) => const VisualizarAtividadePescaPage(),
          transition: TransitionType.leftToRight,
        ),
      ];
}
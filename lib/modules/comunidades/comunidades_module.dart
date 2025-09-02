import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/comunidades/comunidades_controller.dart';
import 'package:sisater_mobile/modules/comunidades/pages/cadastrar_comunidade_page.dart';
import 'package:sisater_mobile/modules/comunidades/pages/comunidades_page.dart';
import 'package:sisater_mobile/modules/comunidades/pages/editar_comunidade_page.dart';
import 'package:sisater_mobile/modules/comunidades/pages/visualizar_comunidade_page.dart';
import 'package:sisater_mobile/modules/comunidades/repository/comunidades_repository.dart';
import 'package:sisater_mobile/shared/utils/custom_dio.dart';

class ComunidadesModule extends Module {
  @override
  List<Bind> get binds => [
        Bind<ComunidadesRepository>(
          (i) => ComunidadesRepository(i.get<CustomDio>().dio),
        ),
        Bind(
          (i) => ComunidadesController(
            comunidadesRepository: i.get<ComunidadesRepository>(),
          ),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (context, args) => const ComunidadesPage(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/cadastrar_comunidade',
          child: (context, args) => const CadastrarComunidadePage(),
          transition: TransitionType.downToUp,
        ),
        ChildRoute(
          '/editar_comunidade',
          child: (context, args) => EditarComunidadePage(
            comunidade: args.data,
          ),
        ),
        ChildRoute(
          '/visualizar_comunidade',
          child: (context, args) => const VisualizarComunidadePage(),
          transition: TransitionType.leftToRight,
        ),
      ];
}
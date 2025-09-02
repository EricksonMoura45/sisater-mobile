import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/unidade_de_producao/pages/cadastrar_unidade_producao.dart';
import 'package:sisater_mobile/modules/unidade_de_producao/pages/editar_unidade_producao.dart';
import 'package:sisater_mobile/modules/unidade_de_producao/pages/visualizar_unidade_producao.dart';
import 'package:sisater_mobile/modules/unidade_de_producao/pages/unidade_producao_page.dart';
import 'package:sisater_mobile/modules/unidade_de_producao/repository/unidade_producao_repository.dart';
import 'package:sisater_mobile/modules/unidade_de_producao/unidade_producao_controller.dart';
import 'package:sisater_mobile/shared/utils/custom_dio.dart';

class UnidadeProducaoModule extends Module{

  @override
  List<Bind> get binds => [
        Bind<UnidadeProducaoRepository>(
          (i) => UnidadeProducaoRepository(dio: i.get<CustomDio>().dio),
        ),
        Bind(
          (i) => UnidadeProducaoController(unidadeProducaoRepository:i.get<UnidadeProducaoRepository>()),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (context, args) => const UnidadeProducaoPage(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/cadastrar',
          child: (context, args) => const CadastrarUnidadeProducao(),
          transition: TransitionType.downToUp,
        ),
        ChildRoute(
          '/editar',
          child: (context, args) => EditarUnidadeProducao(unidade: args.data),
          transition: TransitionType.downToUp,
        ),
        ChildRoute(
          '/visualizar',
          child: (context, args) => VisualizarUnidadeProducao(unidade: args.data),
          transition: TransitionType.downToUp,
        ),
      ];
}
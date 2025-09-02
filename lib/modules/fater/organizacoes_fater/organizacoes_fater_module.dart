import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/fater/organizacoes_fater/organizacoes_fater_controller.dart';
import 'package:sisater_mobile/modules/fater/organizacoes_fater/pages/cadastrar_organizacao_fater_page.dart';
import 'package:sisater_mobile/modules/fater/organizacoes_fater/pages/editar_organizacao_fater_page.dart';
import 'package:sisater_mobile/modules/fater/organizacoes_fater/pages/organizacoes_fater_page.dart';
import 'package:sisater_mobile/modules/fater/organizacoes_fater/pages/visualizar_organizacao_fater_page.dart';
import 'package:sisater_mobile/modules/fater/organizacoes_fater/repository/organizacoes_fater_repository.dart';
import 'package:sisater_mobile/shared/utils/custom_dio.dart';

class OrganizacoesFaterModule extends Module{
  @override
  final List<Bind> binds = [
    Bind<OrganizacoesFaterRepository>(
          (i) => OrganizacoesFaterRepository(i.get<CustomDio>().dio),
        ),
    Bind((i) => OrganizacoesFaterController(organizacoesFaterRepository: i.get<OrganizacoesFaterRepository>(),)),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (context, args) => const OrganizacoesFaterPage()),
    ChildRoute('/cadastrar_organizacao_fater', child: (context, args) => const CadastrarOrganizacaoFaterPage()),
    ChildRoute(
          '/visualizar_organizacao_fater',
          child: (context, args) => const VisualizarOrganizacaoFaterPage(),
          transition: TransitionType.leftToRight,
        ),
    ChildRoute(
          '/editar_organizacao_fater',
          child: (context, args) => const EditarOrganizacaoFaterPage(),
          transition: TransitionType.leftToRight,
        ),
  ];
}
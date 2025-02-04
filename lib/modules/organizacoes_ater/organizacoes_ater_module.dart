import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/organizacoes_ater/organizacoes_ater_controller.dart';
import 'package:sisater_mobile/modules/organizacoes_ater/pages/cadastrar_organizacao_ater.dart';
import 'package:sisater_mobile/modules/organizacoes_ater/pages/cadastro_sucesso_organizacao_ater_page.dart';
import 'package:sisater_mobile/modules/organizacoes_ater/pages/editar_organizacao_ater.dart';
import 'package:sisater_mobile/modules/organizacoes_ater/pages/organizacoes_ater_page.dart';
import 'package:sisater_mobile/modules/organizacoes_ater/repository/organizacoes_ater_repository.dart';
import 'package:sisater_mobile/shared/utils/custom_dio.dart';

class OrganizacoesAterModule extends Module{
  @override
  List<Bind> get binds => [
        Bind<OrganizacoesAterRepository>(
          (i) => OrganizacoesAterRepository(i.get<CustomDio>().dio),
        ),
        Bind(
          (i) => OrganizacoesAterController(
            organizacoesAterRepository: i.get<OrganizacoesAterRepository>(),
          ),
        ),
      ];

   @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, args) => const OrganizacoesAterPage(),
          transition: TransitionType.leftToRight
        ),
        ChildRoute(
          '/cadastro_ater_organizacao',
          child: (_, args) => const CadastrarOrganizacaoAter(),
          transition: TransitionType.defaultTransition,
        ),
         ChildRoute(
          '/sucesso_cadastro_ater_organizacao',
          child: (_, args) => const CadastroSucessoOrganizacaoAterPage(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/editar_ater_organizacao',
          child: (_, args) => const EditarOrganizacaoAter(),
          transition: TransitionType.leftToRight,
        ),
  ];   

}
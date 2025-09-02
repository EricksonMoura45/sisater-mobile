import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/fater/beneficiario_fater/beneficiario_fater_controller.dart';
import 'package:sisater_mobile/modules/fater/beneficiario_fater/pages/beneficiarios_fater_page.dart';
import 'package:sisater_mobile/modules/fater/beneficiario_fater/pages/cadastrar_beneficiario_fater_page.dart';
import 'package:sisater_mobile/modules/fater/beneficiario_fater/pages/visualizar_beneficiario_fater_page.dart';
import 'package:sisater_mobile/modules/fater/beneficiario_fater/repository/beneficiario_fater_repository.dart';
import 'package:sisater_mobile/modules/unidade_de_producao/pages/cadastrar_unidade_producao.dart';
import 'package:sisater_mobile/modules/app_store.dart';

import '../../../shared/utils/custom_dio.dart';

class BeneficiarioFaterModule extends Module{
  @override
  final List<Bind> binds = [
    Bind<BeneficiarioFaterRepository>(
          (i) => BeneficiarioFaterRepository(i.get<CustomDio>().dio),
        ),
        Bind(
          (i) => BeneficiarioFaterController(
            beneficiarioFaterRepository: i.get<BeneficiarioFaterRepository>(),
            appStore: i.get<AppStore>(),
          ),
        ),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (context, args) => const BeneficiariosFaterPage()),
    ChildRoute('/cadastro_beneficiario_fater', child: (context, args) => const CadastrarBeneficiarioFaterPage()),
    ChildRoute(
          '/cadastrar_unidade_producao',
          child: (context, args) => const CadastrarUnidadeProducao(),
          transition: TransitionType.downToUp,
        ),
    ChildRoute(
          '/visualizar_beneficiario_fater',
          child: (context, args) => const VisualizarBeneficiarioFaterPage(),
          transition: TransitionType.leftToRight,
        ),
  ];
}
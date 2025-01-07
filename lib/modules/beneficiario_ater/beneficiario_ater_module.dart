import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/beneficiario_ater/beneficiario_ater_controller.dart';
import 'package:sisater_mobile/modules/beneficiario_ater/pages/beneficiarios_ater_page.dart';
import 'package:sisater_mobile/modules/beneficiario_ater/pages/cadastrar_beneficiario_ater_page.dart';
import 'package:sisater_mobile/modules/beneficiario_ater/pages/cadastro_sucesso_ater_page.dart';
import 'package:sisater_mobile/modules/beneficiario_ater/repository/beneficiario_ater_repository.dart';
import 'package:sisater_mobile/shared/utils/custom_dio.dart';

class BeneficiarioaterModule extends Module{
   @override
  List<Bind> get binds => [
        Bind<BeneficiarioAterRepository>(
          (i) => BeneficiarioAterRepository(i.get<CustomDio>().dio),
        ),
        Bind(
          (i) => BeneficiarioAterController(i.get<BeneficiarioAterRepository>()),
        ),
      ];
   @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, args) => const BeneficiariosAterPage(),
          transition: TransitionType.leftToRight
        ),
        ChildRoute(
          '/cadastro_ater',
          child: (_, args) => const CadastrarBeneficiarioAterPage(),
          transition: TransitionType.defaultTransition,
        ),
         ChildRoute(
          '/sucesso_cadastro_ater',
          child: (_, args) => const CadastroSucessoPage(),
          transition: TransitionType.fadeIn,
        ),
  ];
}
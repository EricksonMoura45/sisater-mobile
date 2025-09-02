import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/beneficiario_ater_controller.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/pages/beneficiarios_ater_page.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/pages/cadastrar_beneficiario_ater_page.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/pages/cadastro_sucesso_ater_page.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/pages/editar_beneficiario_page.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/pages/integrante_familiar/cadastrar_integrante_familiar_page.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/pages/integrante_familiar/editar_integrante_familiar_page.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/pages/integrante_familiar/integrantes_familia_page.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/pages/prontuario_page.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/pages/visualizar_prontuario_page.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/pages/visualizar_beneficiario_ater_page.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/repository/beneficiario_ater_repository.dart';
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
          transition: TransitionType.fadeIn
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
        ChildRoute(
          '/editar_ater',
          child: (_, args) => const EditarBeneficiarioPage(),
          transition: TransitionType.fadeIn,
        ),
         ChildRoute(
          '/integrantes_familia',
          child: (_, args) => const IntegranteFamiliaPage(),
          transition: TransitionType.fadeIn,
        ),
         ChildRoute(
          '/novo_integrantes_familia',
          child: (_, args) => const CadastrarIntegranteFamiliarPage(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/editar_integrantes_familia',
          child: (_, args) => const EditarIntegranteFamiliarPage(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/prontuario',
          child: (_, args) => const ProntuarioPage(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/visualizar_prontuario',
          child: (_, args) => const VisualizarProntuarioPage(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/visualizar',
          child: (_, args) => VisualizarBeneficiarioAterPage(beneficiario: args.data),
          transition: TransitionType.fadeIn,
        ),
  ];
}
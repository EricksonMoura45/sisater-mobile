import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/agendamento/agendamento_module.dart';
import 'package:sisater_mobile/modules/app_store.dart';
import 'package:sisater_mobile/modules/atendimento/atendimento_module.dart';
import 'package:sisater_mobile/modules/atividade_de_pesca/atividade_de_pesca_module.dart';
import 'package:sisater_mobile/modules/autenticacao/autenticacao_module.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/beneficiario_ater_module.dart';
import 'package:sisater_mobile/modules/beneficiario_menu/beneficiario_module.dart';
import 'package:sisater_mobile/modules/comunidades/comunidades_module.dart';
import 'package:sisater_mobile/modules/fater/beneficiario_fater/beneficiario_fater_module.dart';
import 'package:sisater_mobile/modules/fater/organizacoes_fater/organizacoes_fater_module.dart';
import 'package:sisater_mobile/modules/home/home_module.dart';
import 'package:sisater_mobile/modules/ater/organizacoes_ater/organizacoes_ater_module.dart';
import 'package:sisater_mobile/modules/unidade_de_producao/unidade_producao_module.dart';
import 'package:sisater_mobile/modules/offline/offline_module.dart';
import 'package:sisater_mobile/shared/utils/custom_dio.dart';
import 'package:sisater_mobile/modules/autenticacao/autenticacao_controller.dart';
import 'package:sisater_mobile/modules/autenticacao/repositories/autenticacao_repository.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton((i) => CustomDio()),
        Bind.lazySingleton((i) => AppStore()),
        //Bind.lazySingleton((i) => LocationService()),
        Bind((i) => AppStore()),
        Bind.lazySingleton((i) => AutenticacaoRepository(i<CustomDio>().dio)),
        Bind.singleton((i) => AutenticacaoController(i<AutenticacaoRepository>())),
      ];
  
  @override
  List<ModularRoute> get routes => [
        ModuleRoute(
          Modular.initialRoute,
          module: AutenticacaoModule(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/home',
          module: HomeModule(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/offline',
          module: OfflineModule(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/beneficiarios_ater',
          module: BeneficiarioaterModule(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/organizacoes_ater',
          module: OrganizacoesAterModule(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/organizacoes_fater',
          module: OrganizacoesFaterModule(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/beneficiarios_fater',
          module: BeneficiarioFaterModule(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/comunidades',
          module: ComunidadesModule(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/atividade_de_pesca',
          module: AtividadeDePescaModule(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/unidades_producao',
          module: UnidadeProducaoModule(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/atendimento',
          module: AtendimentoModule(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/beneficiario',
          module: BeneficiarioModule(),
          transition: TransitionType.fadeIn,
        ),
        ModuleRoute(
          '/agendamentos',
          module: AgendamentoModule(),
          transition: TransitionType.fadeIn,
        ),
      ];
}
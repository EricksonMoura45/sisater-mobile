import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/app_store.dart';
import 'package:sisater_mobile/modules/autenticacao/autenticacao_module.dart';
import 'package:sisater_mobile/modules/beneficiario_ater/beneficiario_ater_module.dart';
import 'package:sisater_mobile/modules/home/home_module.dart';
import 'package:sisater_mobile/shared/utils/custom_dio.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton((i) => CustomDio()),
        Bind.lazySingleton((i) => AppStore()),
        //Bind.lazySingleton((i) => LocationService()),
        Bind((i) => AppStore()),
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
          '/beneficiarios_ater',
          module: BeneficiarioaterModule(),
          transition: TransitionType.fadeIn,
        ),
      ];
}
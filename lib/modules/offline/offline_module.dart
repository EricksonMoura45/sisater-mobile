import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/offline/pages/offline_home_page.dart';
import 'package:sisater_mobile/modules/offline/pages/offline_cadastrar_beneficiario_fater_page.dart';

class OfflineModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (context, args) => const OfflineHomePage()),
    ChildRoute('/cadastrar_beneficiario_fater', child: (context, args) => const OfflineCadastrarBeneficiarioFaterPage()),
  ];
}

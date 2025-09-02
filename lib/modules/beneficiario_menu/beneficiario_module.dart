import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/beneficiario_menu/agendamentos/agendamentos_beneficiario_page.dart';
import 'package:sisater_mobile/modules/beneficiario_menu/beneficiario_controller.dart';
import 'package:sisater_mobile/modules/beneficiario_menu/home/beneficiario_home_page.dart';
import 'package:sisater_mobile/modules/beneficiario_menu/chat/beneficiario_chat_page.dart';
import 'package:sisater_mobile/modules/beneficiario_menu/chat/beneficiario_lista_chats_page.dart';
import 'package:sisater_mobile/modules/beneficiario_menu/perfil/beneficiario_perfil_page.dart';
import 'package:sisater_mobile/modules/beneficiario_menu/prontuario/beneficiario_prontuario_page.dart';
import 'package:sisater_mobile/modules/beneficiario_menu/prontuario/beneficiario_visualizar_prontuario_page.dart';
import 'package:sisater_mobile/modules/beneficiario_menu/repository/beneficiario_repository.dart';
import 'package:sisater_mobile/shared/utils/custom_dio.dart';

class BeneficiarioModule extends Module {

  CustomDio dio = CustomDio();

  BeneficiarioModule();

  @override
  List<Bind> get binds => [
    Bind<BeneficiarioRepository>(
      (i) => BeneficiarioRepository(dio: i.get<CustomDio>().dio),
    ),
    Bind(
      (i) => BeneficiarioController(
        beneficiarioRepository: i.get<BeneficiarioRepository>(),
      ),
    ),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(
      Modular.initialRoute,
      child: (_, args) => const BeneficiarioHomePage(),
      transition: TransitionType.fadeIn,
    ),
    ChildRoute(
      '/chat',
      child: (_, args) => const BeneficiarioListaChatsPage(),
      transition: TransitionType.fadeIn,
    ),
    ChildRoute(
      '/chat_detalhes',
      child: (_, args) => BeneficiarioChatPage(chat: args.data),
      transition: TransitionType.fadeIn,
    ),
    ChildRoute(
      '/agendamentos_beneficiario',
      child: (_, args) => const AgendamentosBeneficiarioPage(),
      transition: TransitionType.fadeIn,
    ),
    ChildRoute(
      '/prontuario',
      child: (_, args) => const BeneficiarioProntuarioPage(),
      transition: TransitionType.fadeIn,
    ),
    ChildRoute(
      '/visualizar_prontuario',
      child: (_, args) => const BeneficiarioVisualizarProntuarioPage(),
      transition: TransitionType.fadeIn,
    ),
    ChildRoute(
      '/perfil',
      child: (_, args) => const BeneficiarioPerfilPage(),
      transition: TransitionType.fadeIn,
    ),
  ];
}
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/atendimento/atendimento_controller.dart';
import 'package:sisater_mobile/modules/atendimento/pages/chat_page.dart';
import 'package:sisater_mobile/modules/atendimento/pages/finalizar_atendimento_page.dart';
import 'package:sisater_mobile/modules/atendimento/pages/lista_chats_page.dart';
import 'package:sisater_mobile/modules/atendimento/pages/novo_chat_page.dart';
import 'package:sisater_mobile/modules/atendimento/repository/atendimento_repository.dart';
import 'package:sisater_mobile/shared/utils/custom_dio.dart';

class AtendimentoModule extends Module {
  @override
  List<Bind> get binds => [
    Bind<AtendimentoRepository>(
      (i) => AtendimentoRepository(dio: i.get<CustomDio>().dio),
    ),
    Bind(
      (i) => AtendimentoController(atendimentoRepository: i.get<AtendimentoRepository>()),
    ),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(Modular.initialRoute, child: (context, args) => ListaChatsPage()),
    ChildRoute('/chat', child: (context, args) => ChatPage()),
    ChildRoute('/novo_chat', child: (context, args) => NovoChatPage()),
    ChildRoute('/finalizar_atendimento', child: (context, args) => FinalizarAtendimentoPage()),
  ];

}
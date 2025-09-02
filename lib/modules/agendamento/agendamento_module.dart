import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/agendamento/agendamento_controller.dart';
import 'package:sisater_mobile/modules/agendamento/pages/agendamentos_page.dart';
import 'package:sisater_mobile/modules/agendamento/pages/agendar_visita.dart';
import 'package:sisater_mobile/modules/agendamento/pages/editar_agendamento_page.dart';
import 'package:sisater_mobile/modules/agendamento/pages/visualizar_agendamento_page.dart';
import 'package:sisater_mobile/modules/agendamento/repository/agendamento_repository.dart';
import 'package:sisater_mobile/shared/utils/custom_dio.dart';

class AgendamentoModule extends Module {
  
  @override
  List<Bind> get binds => [
    Bind.lazySingleton((i) => AgendamentoRepository(i<CustomDio>().dio)),
    Bind.lazySingleton((i) => AgendamentoController(i<AgendamentoRepository>())),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (context, args) => AgendamentosPage()),
    ChildRoute('/agendar_visita', child: (context, args) => AgendarVisita()),
    ChildRoute('/editar_agendamento', child: (context, args) => EditarAgendamentoPage()),
    ChildRoute('/visualizar', child: (context, args) => VisualizarAgendamentoPage()),
  ];
}
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:sisater_mobile/models/agendamento/agendamento_lista.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater.dart';
import 'package:sisater_mobile/modules/agendamento/repository/agendamento_repository.dart';
import 'package:esig_utils/status.dart';
import 'package:sisater_mobile/modules/app_store.dart';
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_erro.dart';
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_sucesso.dart';
part 'agendamento_controller.g.dart';

class AgendamentoController = _AgendamentoControllerBase with _$AgendamentoController;

abstract class _AgendamentoControllerBase with Store {
  final AgendamentoRepository agendamentoRepository;

  _AgendamentoControllerBase(this.agendamentoRepository);

  @observable
  List<AgendamentoLista> agendamentos = [];

  AppStore appStore = Modular.get();

  @observable
  Status statusCarregaAgendamentos = Status.NAO_CARREGADO;

  @observable
  Status statusAgendarVisita = Status.NAO_CARREGADO;

  @observable
  Status statusEditarAgendamento = Status.NAO_CARREGADO;

  @observable
  List<BeneficiarioAter> beneficiariosAterEsloc = [];

  @observable
  Status statusCarregaBeneficiarios = Status.NAO_CARREGADO;

  @observable
  String? errorMessage;

  @action
  Future<void> getAgendamentos() async {
    try {
      statusCarregaAgendamentos = Status.AGUARDANDO;
      errorMessage = null;
      agendamentos = await agendamentoRepository.listaAgendamentos();
      statusCarregaAgendamentos = Status.CONCLUIDO;
    } catch (e) {
      errorMessage = 'Erro ao carregar agendamentos';
      statusCarregaAgendamentos = Status.ERRO;
    }
  }

  @action
  Future<bool> agendarVisita(AgendamentoLista agendamento, {bool veioDoChat = false}) async {
    
    try {
      statusAgendarVisita = Status.AGUARDANDO;

      bool? sucesso = await agendamentoRepository.agendarVisita(agendamento);

      if (sucesso == true) {

        statusAgendarVisita = Status.CONCLUIDO;
        ToastAvisosSucesso('Visita agendada com sucesso!');
        
        // Se veio do chat, não navegar automaticamente, deixar a página de agendamento decidir
        if (!veioDoChat) {
          Modular.to.pushReplacementNamed('/agendamentos');
        }
        
        //getAgendamentos();
        statusAgendarVisita = Status.NAO_CARREGADO;
        return true;
        
      } 

      statusAgendarVisita = Status.NAO_CARREGADO;
      return false;
      
    } catch (e) {
      statusAgendarVisita = Status.ERRO;
      ToastAvisosErro('Erro ao agendar visita');
      return false;
    }
  }

  @action
  Future<void> editarAgendamento(int id, AgendamentoLista agendamento, void Function() onSuccess, void Function(String) onError) async {
    statusEditarAgendamento = Status.AGUARDANDO;
    try {
      await agendamentoRepository.editarAgendamento(id, agendamento);
      statusEditarAgendamento = Status.CONCLUIDO;
      onSuccess();
    } catch (e) {
      statusEditarAgendamento = Status.ERRO;
      onError('Erro ao editar agendamento');
    }
  }

  @action
  Future<void> deletarAgendamento(int id, void Function() onSuccess, void Function(String) onError) async {
    try {
      final sucesso = await agendamentoRepository.deleteAgendamento(id);
      if (sucesso) {
        onSuccess();
      } else {
        onError('Erro ao deletar agendamento');
      }
    } catch (e) {
      onError('Erro ao deletar agendamento');
    }
  }

  @action
  Future<void> getBeneficiariosAterEsloc() async {
    try {
      statusCarregaBeneficiarios = Status.AGUARDANDO;

      beneficiariosAterEsloc = await agendamentoRepository.listaBeneficiariosAter(appStore.usuarioDados?.cityCode ?? '');
      
      statusCarregaBeneficiarios = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaBeneficiarios = Status.ERRO;
      errorMessage = 'Erro ao carregar beneficiários';
    }
  }
}
import 'package:mobx/mobx.dart';
import 'package:esig_utils/status.dart';
import 'package:sisater_mobile/modules/unidade_de_producao/repository/unidade_producao_repository.dart';
import 'package:sisater_mobile/models/unidade_de_producao/unidade_de_producao_list.dart';
import 'package:sisater_mobile/models/unidade_de_producao/unidade_de_producao_post.dart';

part 'unidade_producao_controller.g.dart';

class UnidadeProducaoController = _UnidadeProducaoControllerBase with _$UnidadeProducaoController;

abstract class _UnidadeProducaoControllerBase with Store {
  final UnidadeProducaoRepository unidadeProducaoRepository;
  
  _UnidadeProducaoControllerBase({
    required this.unidadeProducaoRepository,
  });

  @observable
  Status statusCarregaUnidades = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaMaisUnidades = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaUnidadesPorNome = Status.NAO_CARREGADO;

  @observable
  Status statusPostUnidade = Status.NAO_CARREGADO;

  @observable
  Status statusPutUnidade = Status.NAO_CARREGADO;

  @observable
  Status statusDeleteUnidade = Status.NAO_CARREGADO;

  @observable
  List<UnidadedeProducaoList> unidades = [];

  @observable
  List<UnidadedeProducaoList> unidadesFiltradas = [];

  @observable
  List<UnidadedeProducaoList> maisUnidadesFiltradas = [];

  @observable
  String mensagemErro = '';

  @observable
  int pageCounter = 1;

  @action
  Future<void> carregarUnidades() async {
    try {
      statusCarregaUnidades = Status.AGUARDANDO;
      unidades = await unidadeProducaoRepository.getUnidadesDeProducao(1);
      unidadesFiltradas = List.from(unidades);
      statusCarregaUnidades = Status.CONCLUIDO;
      pageCounter = 1;
    } catch (e) {
      mensagemErro = e.toString();
      statusCarregaUnidades = Status.ERRO;
    }
  }

  @action
  Future<void> carregarMaisUnidades() async {
    try {
      statusCarregaMaisUnidades = Status.AGUARDANDO;
      pageCounter++;
      maisUnidadesFiltradas = await unidadeProducaoRepository.getUnidadesDeProducao(pageCounter);
      
      if (maisUnidadesFiltradas.isNotEmpty) {
        unidades.addAll(maisUnidadesFiltradas);
        unidadesFiltradas = List.from(unidades);
        statusCarregaMaisUnidades = Status.CONCLUIDO;
      } else {
        statusCarregaMaisUnidades = Status.CONCLUIDO;
      }
    } catch (e) {
      mensagemErro = e.toString();
      statusCarregaMaisUnidades = Status.ERRO;
      pageCounter--; // Reverte o incremento em caso de erro
    }
  }

  @action
  Future<void> carregarUnidadesPorNome(String nome) async {
    try {
      statusCarregaUnidadesPorNome = Status.AGUARDANDO;
      
      if (nome.isEmpty) {
        unidadesFiltradas = List.from(unidades);
        statusCarregaUnidadesPorNome = Status.CONCLUIDO;
        return;
      }

      // Filtra as unidades existentes por nome
      unidadesFiltradas = unidades.where((unidade) {
        final nomeUnidade = unidade.productionUnitNormal?.name?.toLowerCase() ?? '';
        final nomeBusca = nome.toLowerCase();
        return nomeUnidade.contains(nomeBusca);
      }).toList();

      statusCarregaUnidadesPorNome = Status.CONCLUIDO;
    } catch (e) {
      mensagemErro = e.toString();
      statusCarregaUnidadesPorNome = Status.ERRO;
    }
  }

  @action
  Future<void> postUnidadeDeProducao(UnidadeDeProducaoPost unidade) async {
    try {
      statusPostUnidade = Status.AGUARDANDO;
      await unidadeProducaoRepository.postUnidadeDeProducao(unidade);
      statusPostUnidade = Status.CONCLUIDO;
      await carregarUnidades(); // Recarrega a lista
    } catch (e) {
      mensagemErro = e.toString();
      statusPostUnidade = Status.ERRO;
    }
  }

  @action
  Future<void> putUnidadeDeProducao(UnidadeDeProducaoPost unidade, int id) async {
    try {
      statusPutUnidade = Status.AGUARDANDO;
      await unidadeProducaoRepository.editarUnidadeDeProducao(unidade, id);
      statusPutUnidade = Status.CONCLUIDO;
      await carregarUnidades(); // Recarrega a lista
    } catch (e) {
      mensagemErro = e.toString();
      statusPutUnidade = Status.ERRO;
    }
  }

  @action
  Future<void> deleteUnidadeDeProducao(int id) async {
    try {
      statusDeleteUnidade = Status.AGUARDANDO;
      final success = await unidadeProducaoRepository.deleteUnidadeDeProducao(id);
      
      if (success) {
        statusDeleteUnidade = Status.CONCLUIDO;
        await carregarUnidades(); // Recarrega a lista
      } else {
        statusDeleteUnidade = Status.ERRO;
        mensagemErro = 'Erro ao excluir unidade de produção';
      }
    } catch (e) {
      mensagemErro = e.toString();
      statusDeleteUnidade = Status.ERRO;
    }
  }

  void limparMensagemErro() {
    mensagemErro = '';
  }

  void resetarStatuses() {
    statusPostUnidade = Status.NAO_CARREGADO;
    statusPutUnidade = Status.NAO_CARREGADO;
    statusDeleteUnidade = Status.NAO_CARREGADO;
  }
}
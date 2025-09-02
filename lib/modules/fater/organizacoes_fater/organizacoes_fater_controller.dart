import 'package:esig_utils/status.dart';
import 'package:mobx/mobx.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/comunidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/produto.dart';
import 'package:sisater_mobile/models/comunidades/comunidade_selecionavel.dart';
import 'package:sisater_mobile/models/organizacoes_fater/organizacao_fater_list.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/eslocs.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/finalidade_atendimento.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/metodo_ater.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/politicas_publicas.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/tecnica_ater.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/tecnico_emater.dart';
import 'package:sisater_mobile/modules/fater/organizacoes_fater/repository/organizacoes_fater_repository.dart';

part 'organizacoes_fater_controller.g.dart';

class OrganizacoesFaterController = _OrganizacoesFaterControllerBase with _$OrganizacoesFaterController;

abstract class _OrganizacoesFaterControllerBase with Store {
  final OrganizacoesFaterRepository organizacoesFaterRepository;

  _OrganizacoesFaterControllerBase({
    required this.organizacoesFaterRepository,
  });

  @observable
  Status statusCarregaOrganizacoes = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaMaisOrganizacoes = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaComunidadesSel = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaEslocs = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaTecnicas = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaPoliticas = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaDadosPagina = Status.NAO_CARREGADO;

  @observable
  Status cadastraOrganizacaoStatus = Status.NAO_CARREGADO;

  @observable
  String mensagemError = '';

  @observable
  DateTime dataAtendimento = DateTime.now();

  @observable
  int pageCounter = 0;

  @observable
  List<OrganizacaoFaterList> listaOrganizacoes = [];

  @observable
  List<OrganizacaoFaterList> organizacoesFiltradas = [];

  @observable
  List<OrganizacaoFaterList> maisOrganizacoesFiltradas = [];

  @observable
  List<ComunidadeSelecionavel> municipiosSelecionaveis = [];

  @observable
  List<Eslocs> listaEslocs = [];

  @observable
  List<TecnicaAter> listaTecnica = [];

  @observable
  List<TecnicoEmater> listaTecnicoEmater = [];

  @observable
  List<PoliticasPublicas> listaPoliticas = [];

  @observable
  Status statusCarregaOrganizacoesAter = Status.NAO_CARREGADO;

  @observable
  List<OrganizacaoFaterList> listaOrganizacoesAter = [];

  @observable
  Status statusCarregaMunicipios = Status.NAO_CARREGADO;

  @observable
  List<ComunidadeSelecionavel> listaMunicipios = [];

  @observable
  Status statusCarregaComunidades = Status.NAO_CARREGADO;

  @observable
  List<Comunidade> listaComunidades = [];

  @observable
  Status statusCarregaFinalidadeAtendimento = Status.NAO_CARREGADO;

  @observable
  List<FinalidadeAtendimento> listaFinalidadeAtendimento = [];

  @observable
  Status statusCarregaProdutos = Status.NAO_CARREGADO;

  @observable
  List<Produto> listaProdutos = [];

  @observable
  Status statusCarregaMetodos = Status.NAO_CARREGADO;

  @observable
  List<MetodoAter> listaMetodos = [];

  @observable
  ComunidadeSelecionavel? municipioSelecionado;

  @observable
  Eslocs? eslocSelecionado;

  @observable
  Produto? produtoSelecionado;

  @observable
  MetodoAter? metodoSelecionado;

  @observable
  OrganizacaoFaterList? organizacaoFaterSelecionada;

  @observable
  List<OrganizacaoFaterList> listaOrganizacoesAterSelecionadas = [];

  @observable
  List<FinalidadeAtendimento> listaFinalidadeAtendimentoSelecionados = [];

  @observable
  List<Produto> listaProdutosSelecionados = [];

  @observable
  List<TecnicaAter> listaTecnicasSelecionadas = [];

  @observable
  List<PoliticasPublicas> listaPoliticasSelecionadas = [];

  @observable
  List<TecnicoEmater> listaTecnicosEmaterSelecionados = [];

  @observable
  FinalidadeAtendimento? finalidadeAtendimentoSelecionada;

  @observable
  TecnicaAter? tecnicaSelecionada;

  @observable
  PoliticasPublicas? politicaSelecionada;

  @observable
  TecnicoEmater? tecnicoEmaterSelecionado;

  @observable
  Comunidade? comunidadeSelecionada;

  @action
  Future<void> carregaMunicipios() async {
    try {
      statusCarregaMunicipios = Status.AGUARDANDO;
      listaMunicipios = await organizacoesFaterRepository.listaMunicipios();
      statusCarregaMunicipios = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaMunicipios = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @action
  Future<void> carregaComunidades(int? cityCode) async {
    try {
      statusCarregaComunidades = Status.AGUARDANDO;
      listaComunidades = await organizacoesFaterRepository.listaComunidade(cityCode);
      statusCarregaComunidades = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaComunidades = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @action
  Future<void> carregaFinalidadeAtendimento() async {
    try {
      statusCarregaFinalidadeAtendimento = Status.AGUARDANDO;
      listaFinalidadeAtendimento = await organizacoesFaterRepository.listaFinalidadeAtendimento();
      statusCarregaFinalidadeAtendimento = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaFinalidadeAtendimento = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @action
  Future<void> carregaProdutos() async {
    try {
      statusCarregaProdutos = Status.AGUARDANDO;
      listaProdutos = await organizacoesFaterRepository.listaProdutos();
      statusCarregaProdutos = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaProdutos = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @action
  Future<void> carregaMetodos() async {
    try {
      statusCarregaMetodos = Status.AGUARDANDO;
      listaMetodos = await organizacoesFaterRepository.listaMetodos();
      statusCarregaMetodos = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaMetodos = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  Future carregaOrganizacoes() async {
    try {
      statusCarregaOrganizacoes = Status.AGUARDANDO;
      organizacoesFiltradas = await organizacoesFaterRepository.listaOrganizacoesFater(1);

      if (organizacoesFaterRepository.listaFaterbool == true) {
        listaOrganizacoes = organizacoesFiltradas;
        statusCarregaOrganizacoes = Status.CONCLUIDO;
      }
    } catch (e) {
      statusCarregaOrganizacoes = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  Future carregaMaisOrganizacoes() async {
    try {
      statusCarregaMaisOrganizacoes = Status.AGUARDANDO;
      maisOrganizacoesFiltradas = await organizacoesFaterRepository.listaOrganizacoesFater(pageCounter);

      if (organizacoesFaterRepository.listaFaterbool == true) {
        organizacoesFiltradas.addAll(maisOrganizacoesFiltradas);
        listaOrganizacoes = organizacoesFiltradas;
        statusCarregaMaisOrganizacoes = Status.CONCLUIDO;
      } else {
        statusCarregaMaisOrganizacoes = Status.ERRO;
        mensagemError = 'Erro ao carregar mais organizações.';
      }

      pageCounter++;
    } catch (e) {
      statusCarregaMaisOrganizacoes = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @action
  Future<void> carregaOrganizacoesAter(String cityCodeFater) async {
    try {
      statusCarregaOrganizacoesAter = Status.AGUARDANDO;
      listaOrganizacoesAter = await organizacoesFaterRepository.listaBeneficiariosAter(cityCodeFater);
      statusCarregaOrganizacoesAter = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaOrganizacoesAter = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @action
  Future<void> carregaEslocs() async {
    try {
      statusCarregaEslocs = Status.AGUARDANDO;
      listaEslocs = await organizacoesFaterRepository.listaEslocs();
      statusCarregaEslocs = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaEslocs = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @action
  Future<void> carregaTenicas() async {
    try {
      statusCarregaTecnicas = Status.AGUARDANDO;
      listaTecnica = await organizacoesFaterRepository.listaTecnica();
      statusCarregaTecnicas = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaTecnicas = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @action
  Future<void> carregaPoliticas() async {
    try {
      statusCarregaPoliticas = Status.AGUARDANDO;
      listaPoliticas = await organizacoesFaterRepository.listaPoliticas();
      statusCarregaPoliticas = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaPoliticas = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @action
  Future<void> carregaTecnicoEmater() async {
    try {
      statusCarregaTecnicas = Status.AGUARDANDO;
      listaTecnicoEmater = await organizacoesFaterRepository.listaTecnicoEmater();
      statusCarregaTecnicas = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaTecnicas = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @action
  Future<void> carregaDadosPagina() async {
    try {
      statusCarregaDadosPagina = Status.AGUARDANDO;
      await carregaOrganizacoes();
      await carregaMunicipios();
      await carregaEslocs();
      await carregaProdutos();
      await carregaMetodos();
      await carregaFinalidadeAtendimento();
      await carregaTenicas();
      await carregaPoliticas();
      await carregaTecnicoEmater();
      statusCarregaDadosPagina = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaComunidadesSel = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @action
  Future<void> changeMunicipioSelecionado(ComunidadeSelecionavel? value) async {
    municipioSelecionado = value;
    if (municipioSelecionado != null) {
      await carregaComunidades(int.tryParse(municipioSelecionado!.code ?? '1500107'));
      await carregaOrganizacoesAter(municipioSelecionado!.code ?? '1500107');
    } else {
      listaComunidades = [];
    }
  }

  @action
  void changeEslocSelecionado(Eslocs? value) {
    eslocSelecionado = value;
  }

  @action
  void changeProdutoSelecionado(Produto? value) {
    produtoSelecionado = value;
    addProdutoSelecionado(value);
  }

  @action
  void changeMetodoSelecionado(MetodoAter? value) {
    metodoSelecionado = value;
  }

  @action
  void changeFinalidadeAtendimentoSelecionada(FinalidadeAtendimento? value) {
    finalidadeAtendimentoSelecionada = value;
    addFinalidadeAtendimentoSelecionada(value);
  }

  @action
  void changeOrganizacaoFaterSelecionada(OrganizacaoFaterList? value) {
    organizacaoFaterSelecionada = value;
    addOrganizacaoFaterSelecionada(value);
  }

  @action
  void changeComunidadeSelecionada(Comunidade? value) {
    comunidadeSelecionada = value;
  }

  @action
  void changeTecnicaSelecionada(TecnicaAter? value) {
    tecnicaSelecionada = value;
    addTecnicaSelecionada(value);
  }

  @action
  void changePoliticaSelecionada(PoliticasPublicas? value) {
    politicaSelecionada = value;
    addPoliticaSelecionada(value);
  }

  @action
  void changeTecnicoEmaterSelecionado(TecnicoEmater? value) {
    tecnicoEmaterSelecionado = value;
    addTecnicoEmaterSelecionado(value);
  }

  @action
  void addOrganizacaoFaterSelecionada(OrganizacaoFaterList? e) {
    if (e == null) return;
    if (!listaOrganizacoesAterSelecionadas.contains(e)) {
      listaOrganizacoesAterSelecionadas.add(e);
    }
  }

  @action
  void deleteOrganizacaoFaterSelecionada(OrganizacaoFaterList? e) {
    if (e == null) return;
    listaOrganizacoesAterSelecionadas.remove(e);
  }

  @action
  void addProdutoSelecionado(Produto? e) {
    if (e == null) return;
    if (!listaProdutosSelecionados.contains(e)) {
      listaProdutosSelecionados.add(e);
    }
  }

  @action
  void deleteProdutoSelecionado(Produto? e) {
    if (e == null) return;
    listaProdutosSelecionados.remove(e);
  }

  @action
  void addFinalidadeAtendimentoSelecionada(FinalidadeAtendimento? e) {
    if (e == null) return;
    if (!listaFinalidadeAtendimentoSelecionados.contains(e)) {
      listaFinalidadeAtendimentoSelecionados.add(e);
    }
  }

  @action
  void deleteFinalidadeAtendimentoSelecionada(FinalidadeAtendimento? e) {
    if (e == null) return;
    listaFinalidadeAtendimentoSelecionados.remove(e);
  }

  @action
  void addTecnicaSelecionada(TecnicaAter? e) {
    if (e == null) return;
    if (!listaTecnicasSelecionadas.contains(e)) {
      listaTecnicasSelecionadas.add(e);
    }
  }

  @action
  void deleteTecnicaSelecionada(TecnicaAter? e) {
    if (e == null) return;
    listaTecnicasSelecionadas.remove(e);
  }

  @action
  void addPoliticaSelecionada(PoliticasPublicas? e) {
    if (e == null) return;
    if (!listaPoliticasSelecionadas.contains(e)) {
      listaPoliticasSelecionadas.add(e);
    }
  }

  @action
  void deletePoliticaSelecionada(PoliticasPublicas? e) {
    if (e == null) return;
    listaPoliticasSelecionadas.remove(e);
  }

  @action
  void addTecnicoEmaterSelecionado(TecnicoEmater? e) {
    if (e == null) return;
    if (!listaTecnicosEmaterSelecionados.contains(e)) {
      listaTecnicosEmaterSelecionados.add(e);
    }
  }

  @action
  void deleteTecnicoEmaterSelecionado(TecnicoEmater? e) {
    if (e == null) return;
    listaTecnicosEmaterSelecionados.remove(e);
  }

  @action
  void limparFormulario() {
    municipioSelecionado = null;
    eslocSelecionado = null;
    produtoSelecionado = null;
    metodoSelecionado = null;
    finalidadeAtendimentoSelecionada = null;
  }
}
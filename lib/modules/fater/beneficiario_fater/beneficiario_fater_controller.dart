import 'package:esig_utils/status.dart';
import 'package:mobx/mobx.dart';
import 'package:sisater_mobile/models/beneficiario_fater/beneficiario_fater_list.dart';
import 'package:sisater_mobile/models/beneficiario_fater/proater.dart';
import 'package:sisater_mobile/models/beneficiario_fater/insumo.dart';
import 'package:sisater_mobile/models/beneficiario_fater/atividade.dart';
import 'package:sisater_mobile/models/beneficiario_fater/foto.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/comunidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/produto.dart';
import 'package:sisater_mobile/models/comunidades/comunidade_selecionavel.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/eslocs.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/finalidade_atendimento.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/metodo_ater.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/politicas_publicas.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/tecnica_ater.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/tecnico_emater.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/unidade_medida.dart';
import 'package:sisater_mobile/modules/fater/beneficiario_fater/repository/beneficiario_fater_repository.dart';
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_sucesso.dart';
import 'package:sisater_mobile/modules/app_store.dart';
import 'package:sisater_mobile/models/offline/offline_data.dart';
part 'beneficiario_fater_controller.g.dart';

class BeneficiarioFaterController = _BeneficiarioFaterControllerBase with _$BeneficiarioFaterController;

abstract class _BeneficiarioFaterControllerBase with Store {
   final BeneficiarioFaterRepository beneficiarioFaterRepository;
   final AppStore? appStore;

  _BeneficiarioFaterControllerBase({
    required this.beneficiarioFaterRepository,
    this.appStore,
  });

  @observable
  Status statusCarregaBeneficiarios = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaMaisBeneficiarios = Status.NAO_CARREGADO;

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
  Status cadastraBeneficiarioStatus = Status.NAO_CARREGADO;

  @observable
  String mensagemError = '';

  @observable
  DateTime dataAtendimento = DateTime.now();

  @observable
  int pageCounter = 0;

  @observable
  List<BeneficiarioFaterList> listaBeneficiarios = [];

  @observable
  List<BeneficiarioFaterList> beneficiariosFiltrados = [];

  @observable
  List<BeneficiarioFaterList> maisBeneficiariosFiltrados = [];

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
  List<Proater> listaProater = [];

  @observable
  List<Proater> listaProaterNamed = [];

  @observable
  Status statusCarregaBeneficiariosAter = Status.NAO_CARREGADO;

  @observable
  List<BeneficiarioAter> listaBeneficiariosAter = [];

  @observable
  Status statusCarregaMunicipios = Status.NAO_CARREGADO;

  @observable
  List<ComunidadeSelecionavel> listaMunicipios = [];

  @action
  Future<void> carregaMunicipios() async {
    try {
      statusCarregaMunicipios = Status.AGUARDANDO;
      listaMunicipios = await beneficiarioFaterRepository.listaMunicipios();
      statusCarregaMunicipios = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaMunicipios = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @observable
  Status statusCarregaComunidades = Status.NAO_CARREGADO;

  @observable
  List<Comunidade> listaComunidades = [];

  @action
  Future<void> carregaComunidades(int? cityCode) async {
    try {
      statusCarregaComunidades = Status.AGUARDANDO;
      listaComunidades = await beneficiarioFaterRepository.listaComunidade(cityCode);
      statusCarregaComunidades = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaComunidades = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @observable
  Status statusCarregaFinalidadeAtendimento = Status.NAO_CARREGADO;

  @observable
  List<FinalidadeAtendimento> listaFinalidadeAtendimento = [];

  @action
  Future<void> carregaFinalidadeAtendimento() async {
    try {
      statusCarregaFinalidadeAtendimento = Status.AGUARDANDO;
      listaFinalidadeAtendimento = await beneficiarioFaterRepository.listaFinalidadeAtendimento();
      statusCarregaFinalidadeAtendimento = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaFinalidadeAtendimento = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @observable
  Status statusCarregaProdutos = Status.NAO_CARREGADO;

  @observable
  List<Produto> listaProdutos = [];

  @action
  Future<void> carregaProdutos() async {
    try {
      statusCarregaProdutos = Status.AGUARDANDO;
      listaProdutos = await beneficiarioFaterRepository.listaProdutos();
      statusCarregaProdutos = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaProdutos = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @observable
  Status statusCarregaMetodos = Status.NAO_CARREGADO;

  @observable
  List<MetodoAter> listaMetodos = [];

  @action
  Future<void> carregaMetodos() async {
    try {
      statusCarregaMetodos = Status.AGUARDANDO;
      listaMetodos = await beneficiarioFaterRepository.listaMetodos();
      statusCarregaMetodos = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaMetodos = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @action
  Future<void> carregaProater() async{
    try {
      statusCarregaBeneficiarios = Status.AGUARDANDO;
      listaProater = await beneficiarioFaterRepository.listaProater();
      statusCarregaBeneficiarios = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaBeneficiarios = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  Future carregaBeneficiarios() async {
    try {
      statusCarregaBeneficiarios = Status.AGUARDANDO;
      carregaMunicipios();
      beneficiariosFiltrados = await beneficiarioFaterRepository.listaBeneficiariosFater(1);

      if (beneficiarioFaterRepository.listaFaterbool == true) {
        listaBeneficiarios = beneficiariosFiltrados;
        statusCarregaBeneficiarios = Status.CONCLUIDO;
      }
    } catch (e) {
      statusCarregaBeneficiarios = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  Future carregaMaisBeneficiarios() async {
    try {
      statusCarregaMaisBeneficiarios = Status.AGUARDANDO;

      maisBeneficiariosFiltrados = await beneficiarioFaterRepository.listaBeneficiariosFater(pageCounter);

      if (beneficiarioFaterRepository.listaFaterbool == true) {
        beneficiariosFiltrados.addAll(maisBeneficiariosFiltrados);
        listaBeneficiarios = beneficiariosFiltrados;
        statusCarregaMaisBeneficiarios = Status.CONCLUIDO;
      } else {
        statusCarregaMaisBeneficiarios = Status.ERRO;
        mensagemError = 'Erro ao carregar mais beneficiários.';
      }

      pageCounter++;
    } catch (e) {
      statusCarregaMaisBeneficiarios = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @action
  Future<void> carregaBeneficiariosAter(String cityCodeFater) async {
    try {
      statusCarregaBeneficiariosAter = Status.AGUARDANDO;
      listaBeneficiariosAter = await beneficiarioFaterRepository.listaBeneficiariosAter(cityCodeFater);
      statusCarregaBeneficiariosAter = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaBeneficiariosAter = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @action
  Future<void> carregaEslocs() async {
    try {
      statusCarregaEslocs = Status.AGUARDANDO;
      listaEslocs = await beneficiarioFaterRepository.listaEslocs();
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
      listaTecnica = await beneficiarioFaterRepository.listaTecnica();
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
      listaPoliticas = await beneficiarioFaterRepository.listaPoliticas();
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
      listaTecnicoEmater = await beneficiarioFaterRepository.listaTecnicoEmater();
      statusCarregaTecnicas = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaTecnicas = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @action
  Future<void> carregaUnidadeMedida() async {
    try {
      statusCarregaUnidadeMedida = Status.AGUARDANDO;
      listaUnidadeMedida = await beneficiarioFaterRepository.listaUnidadeMedida();
      statusCarregaUnidadeMedida = Status.CONCLUIDO;
    } catch (e) {
      statusCarregaUnidadeMedida = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  @action
  Future<void> deleteBeneficiarioFater(int id) async {
    try {
      bool isDeleted = await beneficiarioFaterRepository.deleteFater(id);
      if(isDeleted){
        carregaBeneficiarios();
        ToastAvisosSucesso('Beneficiário excluído com sucesso!');
      }
      
    } catch (e) {
      mensagemError = e.toString();
    }
  }


  @action
  Future<void> carregaDadosPagina() async {
    try {

    statusCarregaDadosPagina = Status.AGUARDANDO;

    // Verificar se há dados offline disponíveis
    if (appStore != null && appStore!.hasOfflineData) {
      await _carregarDadosOffline();
    } else {
      await carregaBeneficiarios();
      await carregaProater();
      await carregaMunicipios();
      await carregaEslocs();
      await carregaProdutos();
      await carregaMetodos();
      await carregaFinalidadeAtendimento();
      await carregaTenicas();
      await carregaPoliticas();
      await carregaTecnicoEmater();
      await carregaUnidadeMedida();

      // Salvar dados no app store para uso offline
      if (appStore != null) {
        final offlineData = OfflineData(
          municipios: municipiosSelecionaveis,
          eslocs: listaEslocs,
          produtos: listaProdutos,
          metodos: listaMetodos,
          finalidadesAtendimento: listaFinalidadeAtendimento,
          tecnicas: listaTecnica,
          politicas: listaPoliticas,
          tecnicosEmater: listaTecnicoEmater,
          proater: listaProater,
          unidadesMedida: listaUnidadeMedida,
          lastUpdate: DateTime.now(),
        );
        await appStore!.saveOfflineData(offlineData);
      }
    }

    statusCarregaDadosPagina = Status.CONCLUIDO;

    } catch (e) {
      statusCarregaComunidadesSel = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  Future<void> _carregarDadosOffline() async {
    if (appStore?.offlineData == null) return;

    final offlineData = appStore!.offlineData!;
    
    municipiosSelecionaveis = offlineData.municipios.cast<ComunidadeSelecionavel>();
    listaEslocs = offlineData.eslocs.cast<Eslocs>();
    listaProdutos = offlineData.produtos.cast<Produto>();
    listaMetodos = offlineData.metodos.cast<MetodoAter>();
    listaFinalidadeAtendimento = offlineData.finalidadesAtendimento.cast<FinalidadeAtendimento>();
    listaTecnica = offlineData.tecnicas.cast<TecnicaAter>();
    listaPoliticas = offlineData.politicas.cast<PoliticasPublicas>();
    listaTecnicoEmater = offlineData.tecnicosEmater.cast<TecnicoEmater>();
    listaProater = offlineData.proater.cast<Proater>();
    listaUnidadeMedida = offlineData.unidadesMedida.cast<UnidadeMedida>();
  }

  @observable
  ComunidadeSelecionavel? municipioSelecionado;

  @observable
  Eslocs? eslocSelecionado;

  @observable
  Produto? produtoSelecionado;

  @observable
  MetodoAter? metodoSelecionado;

  @observable
  BeneficiarioAter? beneficiarioAterSelecionado;

  @observable
  FinalidadeAtendimento? finalidadeAtendimentoSelecionada;

  @observable
  Comunidade? comunidadeSelecionada;

  @observable
  TecnicaAter? tecnicaSelecionada;

  @observable
  PoliticasPublicas? politicaSelecionada;

  @observable
  TecnicoEmater? tecnicoEmaterSelecionado;

  @observable
  Proater? proaterSelecionado;

  @observable
  List<BeneficiarioAter> listaBeneficiariosAterSelecionados = [];
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
  Status statusCarregaUnidadeMedida = Status.NAO_CARREGADO;

  @observable
  List<UnidadeMedida> listaUnidadeMedida = [];

  @observable
  ObservableList<Insumo> listaInsumos = ObservableList<Insumo>();

  @observable
  ObservableList<Atividade> listaAtividades = ObservableList<Atividade>();

  @observable
  ObservableList<Foto> listaFotos = ObservableList<Foto>();

  @observable
  bool cameraPermissionGranted = false;

  @observable
  bool storagePermissionGranted = false;

  @observable
  List<Map<String, dynamic>> listaMetas = [];


  @action
  Future<void> changeMunicipioSelecionado(ComunidadeSelecionavel? value) async {
    municipioSelecionado = value;
    if (municipioSelecionado != null) {
      await carregaComunidades(int.tryParse(municipioSelecionado!.code ?? '1500107'));
      await carregaBeneficiariosAter(municipioSelecionado!.code ?? '1500107');
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
  void changeBeneficiarioAterSelecionado(BeneficiarioAter? value) {
    beneficiarioAterSelecionado = value;
    addBeneficiarioAterSelecionado(value);
    
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
  void changeProaterSelecionada(Proater? value) {
    proaterSelecionado = value;
    addProaterSelecionada(value);
  }

  @action
  void addProaterSelecionada(Proater? e) {
    if (e == null) return;
    listaProaterNamed.add(e);
  }

  @action
  void changeTecnicoEmaterSelecionado(TecnicoEmater? value) {
    tecnicoEmaterSelecionado = value;
    addTecnicoEmaterSelecionado(value);
  }

   @action
  void addBeneficiarioAterSelecionado(BeneficiarioAter? e){
    if (e == null) return;
    listaBeneficiariosAterSelecionados.add(e);
  }
  
  @action
  void deleteBeneficiarioAterSelecionado(BeneficiarioAter? e){
    if (e == null) return;
    listaBeneficiariosAterSelecionados.removeLast();
  }

    @action
  void addProdutoSelecionado(Produto? e){
    if (e == null) return;
    listaProdutosSelecionados.add(e);
  }
  
  @action
  void deleteProdutoSelecionado(Produto? e){
    if (e == null) return;
    listaProdutosSelecionados.removeLast();
  }

  // Para listaFinalidadeAtendimentoSelecionados
  @action
  void addFinalidadeAtendimentoSelecionada(FinalidadeAtendimento? e) {
    if (e == null) return;
    listaFinalidadeAtendimentoSelecionados.add(e);
  }

  @action
  void deleteFinalidadeAtendimentoSelecionada(FinalidadeAtendimento? e) {
    if (e == null) return;
    listaFinalidadeAtendimentoSelecionados.remove(e);
  }

  // Para listaTecnicasSelecionadas
  @action
  void addTecnicaSelecionada(TecnicaAter? e) {
    if (e == null) return;
    listaTecnicasSelecionadas.add(e);
  }

  @action
  void deleteTecnicaSelecionada(TecnicaAter? e) {
    if (e == null) return;
    listaTecnicasSelecionadas.remove(e);
  }

  // Para listaPoliticasSelecionadas
  @action
  void addPoliticaSelecionada(PoliticasPublicas? e) {
    if (e == null) return;
    listaPoliticasSelecionadas.add(e);
  }

  @action
  void deletePoliticaSelecionada(PoliticasPublicas? e) {
    if (e == null) return;
    listaPoliticasSelecionadas.remove(e);
  }

  // Para listaTecnicosEmaterSelecionados
  @action
  void addTecnicoEmaterSelecionado(TecnicoEmater? e) {
    if (e == null) return;
    listaTecnicosEmaterSelecionados.add(e);
  }

  @action
  void deleteTecnicoEmaterSelecionado(TecnicoEmater? e) {
    if (e == null) return;
    listaTecnicosEmaterSelecionados.remove(e);
  }

  @action
  void adicionarInsumo(Insumo insumo) {
    listaInsumos.add(insumo);
  }

  @action
  void removerInsumo(int index) {
    if (index >= 0 && index < listaInsumos.length) {
      listaInsumos.removeAt(index);
    }
  }

  @action
  void adicionarAtividade(Atividade atividade) {
    listaAtividades.add(atividade);
  }

  @action
  void removerAtividade(int index) {
    if (index >= 0 && index < listaAtividades.length) {
      listaAtividades.removeAt(index);
    }
  }

  @action
  void adicionarFoto(Foto foto) {
    listaFotos.add(foto);
  }

  @action
  void removerFoto(int index) {
    if (index >= 0 && index < listaFotos.length) {
      listaFotos.removeAt(index);
    }
  }

  @action
  void adicionarMeta(Map<String, dynamic> meta) {
    listaMetas.add(meta);
  }

  @action
  void removerMeta(int index) {
    if (index >= 0 && index < listaMetas.length) {
      listaMetas.removeAt(index);
    }
  }

  // Função para gerar o JSON no formato solicitado
  Map<String, dynamic> gerarJsonPost() {
    final Map<String, dynamic> data = <String, dynamic>{};
    
    // Campos básicos
    data['year'] = DateTime.now().year;
    data['action_date'] = dataAtendimento.toIso8601String().split('T')[0];
    data['city_code'] = municipioSelecionado?.code;
    data['communities'] = comunidadeSelecionada?.name;
    data['method_id'] = metodoSelecionado?.id;
    data['description'] = 'Descrição do atendimento';
    data['partnerships'] = 'Parcerias';
    data['participating_technicians'] = 'Técnicos participantes';
    data['office_id'] = eslocSelecionado?.id;
    
    // Arrays multiples
    data['beneficiary_multiples'] = listaBeneficiariosAterSelecionados.map((e) => e.id.toString()).toList();
    data['product_multiples'] = listaProdutosSelecionados.map((e) => e.id.toString()).toList();
    data['finality_multiples'] = listaFinalidadeAtendimentoSelecionados.map((e) => e.id.toString()).toList();
    data['technique_multiples'] = listaTecnicasSelecionadas.map((e) => e.id.toString()).toList();
    data['participating_technicians_multiples'] = listaTecnicosEmaterSelecionados.map((e) => e.id.toString()).toList();
    data['proater_multiples'] = listaProaterNamed.map((e) => e.id).toList();
    data['goal_multiples'] = listaMetas.map((e) => e['id']?.toString() ?? '').toList();
    
    // Insumos com timestamp como chave
    Map<String, dynamic> insumosMap = {};
    for (var insumo in listaInsumos) {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      insumosMap[timestamp] = {
        'descricao': insumo.insumo,
        'amount': insumo.quantidade,
        'unit_of_measure_id': insumo.unidadeMedida,
      };
    }
    data['Insumos'] = insumosMap;
    
    // Atividades com timestamp como chave
    Map<String, dynamic> atividadesMap = {};
    for (var atividade in listaAtividades) {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      atividadesMap[timestamp] = {
        'product_id': atividade.produto,
        'situacao': atividade.situacao,
        'recomendacoes': atividade.recomendacoes,
      };
    }
    data['AtividadesAssuntos'] = atividadesMap;
    
    // Metas com timestamp como chave
    Map<String, dynamic> metasMap = {};
    for (var meta in listaMetas) {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      metasMap[timestamp] = {
        'name': meta['name'],
        'amount': meta['amount'],
        'unit_of_measure_id': meta['unit_of_measure_id'],
      };
    }
    data['Goals'] = metasMap;
    
    return data;
  }

  @action
  void setCameraPermission(bool granted) {
    cameraPermissionGranted = granted;
  }

  @action
  void setStoragePermission(bool granted) {
    storagePermissionGranted = granted;
  }

  // Exemplo de função para limpar o formulário (opcional)
  @action
  void limparFormulario() {
    municipioSelecionado = null;
    eslocSelecionado = null;
    produtoSelecionado = null;
    metodoSelecionado = null;
    finalidadeAtendimentoSelecionada = null;
  }
}
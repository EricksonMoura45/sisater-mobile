
import 'package:esig_utils/status.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/categoria_atividade_produtiva.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/categoria_publico.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/comunidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/motivo_registro.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/municipio.dart';

import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/registro_status.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/uf.dart';
import 'package:sisater_mobile/models/comunidades/comunidade_selecionavel.dart';
import 'package:sisater_mobile/models/organizacoes_ater/campos_selecionaveis/tipo_organizacao.dart';
import 'package:sisater_mobile/models/organizacoes_ater/organizacao_ater_list.dart';
import 'package:sisater_mobile/models/organizacoes_ater/organizacao_ater_post.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/eslocs.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/finalidade_atendimento.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/politicas_publicas.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/tecnica_ater.dart';

import 'package:sisater_mobile/modules/ater/organizacoes_ater/repository/organizacoes_ater_repository.dart';
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_erro.dart';
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_sucesso.dart';

part 'organizacoes_ater_controller.g.dart';

class OrganizacoesAterController = _OrganizacoesAterControllerBase with _$OrganizacoesAterController;

abstract class _OrganizacoesAterControllerBase with Store {

  _OrganizacoesAterControllerBase({
    required this.organizacoesAterRepository,
  });
  
   OrganizacoesAterRepository organizacoesAterRepository;

   @observable
   List<OrganizacaoAterList> listaOrganizacoes = [];

   @observable
  List<OrganizacaoAterList> organizacoesFiltradas = [];

  @observable
  List<OrganizacaoAterList> organizacoesFiltradasPorNome = [];

  @observable
  List<OrganizacaoAterList> maisOrganizacoesFiltradas = [];

  @observable
  String termoBusca = '';

  @observable
  Status statusCarregaOrganizacoes = Status.NAO_CARREGADO;

   @observable
  Status statusCarregaOrganizacao = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaOrganizacoesPorNome = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaMaisOrganizacoes = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaMunicipios = Status.NAO_CARREGADO;

  @observable
  Status deleteOrganizacaoStatus = Status.NAO_CARREGADO;

  int pageCounter = 1;

  @observable
  Status statusCarregaDadosPagina = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaComunidades = Status.NAO_CARREGADO;

  @observable
  Status statusCadastrarOrganizacaoAter = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaEditarOrganizacaoAter = Status.NAO_CARREGADO;

  @observable
  Status statusEditarOrganizacaoAter = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaPaginaEditarOrganizacaoAter = Status.NAO_CARREGADO;

  // Exemplo de listas selecionáveis (adapte conforme seu domínio)
  @observable
  List<Municipio> listaMunicipios = [];
  @observable
  List<ComunidadeSelecionavel> listaMunicipiosInfoGerais = [];
  @observable
  List<Eslocs> listaEslocs = [];

  @observable
  List<FinalidadeAtendimento> listaFinalidadeAtendimento = [];
  @observable
  List<TecnicaAter> listaTecnica = [];
  @observable
  List<PoliticasPublicas> listaPoliticas = [];
  @observable
  List<TipoOrganizacao> listaTiposOrganizacao = [];
  @observable
  List<UF> listaUF = [];
  @observable
  List<CategoriaPublico> listaCategoriaPublico = [];
  @observable
  List<CategoriaAtividadeProdutiva> listaCategoriaAtividadeProdutiva = [];
  @observable
  List<Comunidade> listaComunidades = [];
  @observable
  List<MotivoRegistro> listaMotivosRegistro = [];
  @observable
  List<RegistroStatus> listaRegistroStatus = [];

  @observable
  String mensagemError = '';

  @observable
  TipoOrganizacao? tipoOrganizacaoSelecionada;

  @observable
  ComunidadeSelecionavel? comunidadeSelecionada;

  @observable
  Municipio? municipioSelecionado;

   @observable
  ComunidadeSelecionavel? municipioSelecionadoInfoGerais;

  @observable
  Comunidade? comunidadeSelecionadaInfoGerais;

  @observable
  UF? ufSelecionado;



  @observable
  Eslocs? eslocSelecionado;

  @observable
  MotivoRegistro? motivoRegistroSelecionado;

  @observable
  List<MotivoRegistro> motivosRegistroSelecionados = [];

  @observable

  @observable
  CategoriaPublico? categoriaPublicoSelecionado;

  @observable
  CategoriaAtividadeProdutiva? categoriaAtividadeProdutivaSelecionada;

  @observable
  Eslocs? eslocsSelecionado;

  @observable
  RegistroStatus? registroStatusSelecionado;
  
  @observable
  List<CategoriaAtividadeProdutiva> categoriasAtividadeProdutivaSelecionadas = [];

  OrganizacaoAterPost? organizacaoAterPost;

  OrganizacaoAterPost? editarOrganizacaoAter;



// Exemplo para limpar formulário (opcional)
@action
void limparFormulario() {
  // nomeclear();
  // siglaclear();
  // cnpjclear();
  // numeroAfiliadosclear();
  // nomeResponsavelclear();
  // logradouroclear();
  // numeroclear();
  // complementoclear();
  // bairroclear();
  // cepclear();
  // telefoneclear();
  // emailclear();
  // celularclear();
  tipoOrganizacaoSelecionada = null;
  ufSelecionado = null;
  municipioSelecionado = null;
  municipioSelecionadoInfoGerais = null;
  comunidadeSelecionadaInfoGerais = null;
  categoriaPublicoSelecionado = null;
  categoriaAtividadeProdutivaSelecionada = null;
  categoriasAtividadeProdutivaSelecionadas.clear();

}



  // Funções para recuperar dados do repository

  @action
  void resetarBusca() {
    termoBusca = '';
    pageCounter = 1;
    organizacoesFiltradasPorNome.clear();
    maisOrganizacoesFiltradas.clear();
  }

  @action
  Future<void> carregaOrganizacoes() async {
    try {
      statusCarregaOrganizacoes = Status.AGUARDANDO;
      organizacoesFiltradas = await organizacoesAterRepository.listaOrganizacoesFater(1);
      if (organizacoesAterRepository.listaFaterbool == true) {
        listaOrganizacoes = organizacoesFiltradas;
        statusCarregaOrganizacoes = Status.CONCLUIDO;
      }
    } catch (e) {
      statusCarregaOrganizacoes = Status.ERRO;
      //mensagemError = organizacoesFaterRepository.responseError.toString();
    }
  }

  @action
  Future<void> carregaMaisOrganizacoes() async {
    try {
      statusCarregaMaisOrganizacoes = Status.AGUARDANDO;
      maisOrganizacoesFiltradas = await organizacoesAterRepository.listaOrganizacoesFater(pageCounter);
      if (organizacoesAterRepository.listaFaterbool == true) {
        // Adiciona as novas organizações à lista filtrada
        organizacoesFiltradas.addAll(maisOrganizacoesFiltradas);
        // Atualiza a lista principal também
        listaOrganizacoes = organizacoesFiltradas;
        statusCarregaMaisOrganizacoes = Status.CONCLUIDO;
        pageCounter++;
      }
    } catch (e) {
      statusCarregaMaisOrganizacoes = Status.ERRO;
      //mensagemError = organizacoesFaterRepository.responseError.toString();
    }
  }

  @action
  Future<void> carregaOrganizacoesPorNome(String nome) async {
    try {
      statusCarregaOrganizacoesPorNome = Status.AGUARDANDO;
      termoBusca = nome;
      
      organizacoesFiltradasPorNome = await organizacoesAterRepository.listaBeneficiariosAterPorNome(nome);
      if (organizacoesAterRepository.listaFaterPorNome == true) {
        // Limpa as listas e define os resultados da busca
        organizacoesFiltradas.clear();
        organizacoesFiltradas = organizacoesFiltradasPorNome;
        listaOrganizacoes = organizacoesFiltradas;
        statusCarregaOrganizacoesPorNome = Status.CONCLUIDO;
      }
    } catch (e) {
      statusCarregaOrganizacoesPorNome = Status.ERRO;
      //mensagemError = organizacoesFaterRepository.responseError.toString();
    }
  }

   @action
  Future<void> carregaOrganizacao(int id) async {
    try {
      statusCarregaOrganizacao = Status.AGUARDANDO;

      editarOrganizacaoAter = await organizacoesAterRepository.getOrganizacaoAter(id);

      if (organizacoesAterRepository.getOrganizacaoCode == true) {

        await carregaDadosSelecionaveis();
        await preencherDadosOrganizacaoEdit();


      }
    } catch (e) {
      statusCarregaOrganizacao = Status.ERRO;
      //mensagemError = organizacoesFaterRepository.responseError.toString();
    }
  }

  // Função para carregar todos os dados selecionáveis necessários para o cadastro/edição
  @action
  Future<void> carregaDadosSelecionaveis() async {
    try {
      statusCarregaDadosPagina = Status.AGUARDANDO;

      listaEslocs = await organizacoesAterRepository.listaEslocs();
      listaUF = await organizacoesAterRepository.estadosUF();
      listaTiposOrganizacao = await organizacoesAterRepository.tiposOrganizacao();

      listaCategoriaPublico = await organizacoesAterRepository.listaCategoriaPublico();
      listaMunicipiosInfoGerais = await organizacoesAterRepository.listaMunicipiosInfoGerais();
      listaCategoriaAtividadeProdutiva = await organizacoesAterRepository.listaAtividadeProdutiva();
      listaMotivosRegistro = await organizacoesAterRepository.listaMotivoRegistro();
      listaRegistroStatus = await organizacoesAterRepository.listaRegistroStatus();

      statusCarregaDadosPagina = Status.CONCLUIDO;

    } catch (e) {
      statusCarregaDadosPagina = Status.ERRO;
      //mensagemError = organizacoesFaterRepository.responseError.toString();
    }
  }

  void carregaMunicipios (UF uf) async{

    try {
      statusCarregaMunicipios = Status.AGUARDANDO;

      listaMunicipios = await organizacoesAterRepository.listaMunicipios(uf.code);

      if(organizacoesAterRepository.listaAterMunicipiops == true){
        statusCarregaMunicipios = Status.CONCLUIDO;
      }

    } catch (e) {
      statusCarregaMunicipios = Status.ERRO;
    }

  }

  void carregaSubComunidades(ComunidadeSelecionavel municipio) async{

    try {
      statusCarregaComunidades = Status.AGUARDANDO;

      listaComunidades = await organizacoesAterRepository.listaComunidade(int.tryParse(municipio.code!));

      if(organizacoesAterRepository.listaComunidades == true){
        statusCarregaComunidades = Status.CONCLUIDO;
      }

    } catch (e) {
      statusCarregaComunidades = Status.ERRO;
    }

  }

  Future deleteOrganizacaoAter(int id) async{
    try {
      deleteOrganizacaoStatus = Status.AGUARDANDO;

      await organizacoesAterRepository.deleteOrganizacaoAter(id);

      if(organizacoesAterRepository.deleteOrganizacaoCode == true){
        deleteOrganizacaoStatus == Status.CONCLUIDO;
        ToastAvisosSucesso('Apagado com sucesso.');
      }
    } catch (e) {
      deleteOrganizacaoStatus = Status.ERRO;
      ToastAvisosSucesso('Erro ao apagar.');
    }
  }

  void organizacaoPost(OrganizacaoAterPost organizacao) async {
    try {
      statusCadastrarOrganizacaoAter = Status.AGUARDANDO;

      bool? postOrganizacao = await organizacoesAterRepository.postOrganizacaoAter(organizacao);

      if (postOrganizacao == true) {

        ToastAvisosSucesso("Beneficiário Cadastrado com Sucesso.");

        statusCadastrarOrganizacaoAter = Status.CONCLUIDO;
        
        limparFormulario();

        Modular.to.pushReplacementNamed('/organizacoes_ater');
      }

      else {
        statusCadastrarOrganizacaoAter = Status.ERRO;

        ToastAvisosErro("Erro ao cadastrar o beneficiário. Revise os campos e tente novamente.");

      }


    } catch (e) {
      statusCadastrarOrganizacaoAter = Status.ERRO;
      ToastAvisosSucesso("Erro ao cadastrar a Organizacao. Revise os campos e tente novamente.");
      
    }
  }

  void organizacaoPut(OrganizacaoAterPost organizacao, int id) async {
    try {
      statusEditarOrganizacaoAter = Status.AGUARDANDO;

      bool? postOrganizacao = await organizacoesAterRepository.putOrganizacaoAter(organizacao, id);

      if (postOrganizacao == true) {

        ToastAvisosSucesso("Organização editado com Sucesso.");

        statusEditarOrganizacaoAter = Status.CONCLUIDO;
        
        limparFormulario();

        Modular.to.pushReplacementNamed('/organizacoes_fater');
      }

      else {
        statusEditarOrganizacaoAter = Status.ERRO;

        ToastAvisosErro("Erro ao editar o Organização. Revise os campos e tente novamente.");

      }


    } catch (e) {
      statusEditarOrganizacaoAter = Status.ERRO;
      ToastAvisosSucesso("Erro ao editar a Organização. Revise os campos e tente novamente.");
      
    }
  }

  Future<void> preencherDadosOrganizacaoEdit() async {

    municipioSelecionadoInfoGerais = listaMunicipiosInfoGerais.firstWhere(
      (municipio) => municipio.code == editarOrganizacaoAter?.cityCode,
      orElse: () => listaMunicipiosInfoGerais.first
    );

    municipioSelecionado = listaMunicipios.firstWhere(
      (municipio) => municipio.code == editarOrganizacaoAter?.cityCode,
      orElse: () => listaMunicipios.first
    ); 

    eslocSelecionado = listaEslocs.firstWhere(
      (e) => e.id == editarOrganizacaoAter?.officeId,
      orElse: () => listaEslocs.first
    );
    
    ufSelecionado = listaUF.firstWhere(
      (uf) => uf.code == editarOrganizacaoAter!.physicalPerson?.issuingUf,
      orElse: () => listaUF.first
    );

    tipoOrganizacaoSelecionada = listaTiposOrganizacao.firstWhere(
      (tipo) => tipo.id == editarOrganizacaoAter?.socialOrganization?.organizationTypeId,
      orElse: () => listaTiposOrganizacao.first
    );

    if (editarOrganizacaoAter?.officeId != null) {
       eslocSelecionado = listaEslocs.firstWhere(
    (e) => e.id == editarOrganizacaoAter!.officeId,
  );
}
    categoriaPublicoSelecionado = listaCategoriaPublico.firstWhere(
      (categoria) => categoria.id == editarOrganizacaoAter?.targetPublicId,
      orElse: () => listaCategoriaPublico.first
    );

     categoriasAtividadeProdutivaSelecionadas = listaCategoriaAtividadeProdutiva.where(
    (element) => editarOrganizacaoAter!.productiveActivityMultiples?.contains(element.id.toString()) ?? false,
  ).toList();

    motivoRegistroSelecionado = listaMotivosRegistro.first;

    motivosRegistroSelecionados = listaMotivosRegistro.where(
      (motivo) => editarOrganizacaoAter?.reasonMultiples?.contains(motivo.id.toString()) ?? false
    ).toList();

    registroStatusSelecionado = listaRegistroStatus.firstWhere(
      (status) => status.id == editarOrganizacaoAter?.registrationStatusId,
      orElse: () => listaRegistroStatus.first
    );
    
    statusCarregaPaginaEditarOrganizacaoAter = Status.CONCLUIDO;
  }

  

   @action
  void changeTipoOrganizacaoSelecionada(TipoOrganizacao? e){
    if (e == null) return;
    tipoOrganizacaoSelecionada = e;
  }

   @action
  void changeEslocSelecionada(Eslocs? e){
    if (e == null) return;
    eslocSelecionado = e;
  }

  @action
  void changeUfEnderecoSelecionada(UF? e){
    if (e == null) return;
    ufSelecionado = e;
    carregaMunicipios(e);
  }

  @action
  void changeMunicipioSelecionada(Municipio? e){
    if (e == null) return;
    municipioSelecionado = e;
  }

   @action
  void changeMunicipioInfoGeraisSelecionada(ComunidadeSelecionavel? e){
    if (e == null) return;
    municipioSelecionadoInfoGerais = e;
    carregaSubComunidades(e);
  }

   @action
  void changeComunidadeInfoGeraisSelecionada(Comunidade? e){
    if (e == null) return;
    comunidadeSelecionadaInfoGerais = e;
  }

  @action
  void changeRegistroStatus(RegistroStatus? e){
    if (e == null) return;
    registroStatusSelecionado = e;
  }

  @action
  void changeMotivoSelecionado(MotivoRegistro? e){
    if (e == null) return;
    motivoRegistroSelecionado = e;
    if (!motivosRegistroSelecionados.contains(e)) {
      motivosRegistroSelecionados.add(e);
    }
  }

  @action
void addCategoriaAtividadeProdutivaSelecionada(CategoriaAtividadeProdutiva? e) {
  if (e == null) return;
  if (!categoriasAtividadeProdutivaSelecionadas.contains(e)) {
    categoriasAtividadeProdutivaSelecionadas.add(e);
  }
}

@action
void deleteCategoriaAtividadeProdutivaSelecionada(CategoriaAtividadeProdutiva? e) {
  if (e == null) return;
  categoriasAtividadeProdutivaSelecionadas.remove(e);
}

@action
void changeAtividadeProdutivaSelecionada(CategoriaAtividadeProdutiva? value) {
  categoriaAtividadeProdutivaSelecionada = value;
  addCategoriaAtividadeProdutivaSelecionada(value);
}

@action
void changeCategoriaPublicoSelecionada(CategoriaPublico? value) {
  categoriaPublicoSelecionado = value;
}



}

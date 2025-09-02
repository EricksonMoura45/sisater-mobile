import 'package:esig_utils/status.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:loading_empty_error/snackbar.dart';
import 'package:mobx/mobx.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater_post.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/categoria_atividade_produtiva.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/categoria_publico.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/comunidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/enq_caf.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/entidade_caf.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/escolaridade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/estado_civil.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/motivo_registro.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/municipio.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/nacionalidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/naturalidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/produto.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/programas_governamentais.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/registro_status.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/sexo.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/subproduto.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/uf.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/membro_familiar/campos_selecionaveis/parentesco.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/membro_familiar/membro_familiar.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/membro_familiar/membro_familiar_post.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/membro_familiar/membro_familiar_put.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/prontuario/prontuario.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/repository/beneficiario_ater_repository.dart';
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_erro.dart';
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_sucesso.dart';
part 'beneficiario_ater_controller.g.dart';

class BeneficiarioAterController = _BeneficiarioAterControllerBase with _$BeneficiarioAterController;

abstract class _BeneficiarioAterControllerBase with Store {
  
  final BeneficiarioAterRepository beneficiarioAterRepository;

  _BeneficiarioAterControllerBase(this.beneficiarioAterRepository);

  //Campos 
  @observable
  List<BeneficiarioAter> listaBeneficiarios = [];

  @observable
  List<BeneficiarioAter> beneficiariosFiltrados = [];

  @observable
  List<BeneficiarioAter> beneficiariosFiltradosPorNome = [];

  @observable
  List<BeneficiarioAter> maisBeneficiariosFiltrados = [];
  
  @observable
  String termoBusca = '';

  @observable
  Status statusCarregaBeneficiarios = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaBeneficiariosPorNome = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaMaisBeneficiarios = Status.NAO_CARREGADO;

  int pageCounter = 1;

  @observable
  Status statusCarregaDadosPagina = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaMunicipios = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaComunidades = Status.NAO_CARREGADO;

  @observable
  Status statusPostFamilar = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaFamiliar = Status.NAO_CARREGADO;

  List<Sexo> listaSexo = [Sexo(id: 1, name: 'Masculino'), Sexo(id: 2, name: 'Feminino'), Sexo(id: 3, name: 'Outro')];
  List<EstadoCivil> listaEstadoCivil = [EstadoCivil(id: 1, name: 'Não informado'), EstadoCivil(id: 2, name: 'Casado(a)'), EstadoCivil(id: 3, name: 'Divorciado(a)'), EstadoCivil(id: 4, name: 'Separado(a)'),
  EstadoCivil(id: 5, name: 'Solteiro(a)'), EstadoCivil(id: 6, name: 'União Estável'), EstadoCivil(id: 7, name: 'Viúvo(a)')];
  List<Escolaridade> listaEscolaridade = [];
  List<Nacionalidade> listaNacionalidade = [];
  List<Naturalidade> listaNaturalidade = [];
  List<UF> listaUF = [];
  List<CategoriaPublico> listaCategoriaPublico = [];
  List<MotivoRegistro> listaMotivoRegistro = [];
  List<CategoriaAtividadeProdutiva> listaCategoriaAtividadeProdutiva = [];
  List<Produto> listaProdutos = [];
  List<SubProduto> listaSubprodutos = [];
  List<EnqCaf> listaEnqCaf = [];
  List<EntidadeCaf> listaEntidadeCaf = [];
  List<RegistroStatus> listaRegistroStatus = [];
  List<Comunidade> listaComunidade = [];
  List<Municipio> listaMunicipios = [];
  List<ProgramasGovernamentais> listaProgramasGovernamentais = [];

  //Lista de opções com multipla escolha:
  
  //Produtos que irão para o post
  @observable
  List<Produto> produtosSelecionados = [];

  @observable
  List<MotivoRegistro> motivosRegistroSelecionados = [];
  
  @observable
  List<SubProduto> subProdutosSelecionados = [];

  @observable
  List<CategoriaAtividadeProdutiva> categoriasAtividadeProdutivaSelecionadas = [];

  @observable
  List<ProgramasGovernamentais> programasGovernamentaisSelecionados = [];

  /* Variáveis selecionadas */
  @observable
  Sexo? sexoSelecionado;

  @observable
  Sexo? sexoFamiliarSelecionado;

  DateTime dataNascimentoPicked = DateTime.now();

  DateTime dataEmissaoRGPicked = DateTime.now();

  DateTime dataNascimentoFamiliarPicked = DateTime.now();

  @observable
  EstadoCivil? estadoCivilSelecionado;

  @observable
  UF? ufSelecionado;

  @observable
  UF? ufEnderecoSelecionado;

  @observable
  Escolaridade? escolaridadeSelecionada;

  @observable
  Escolaridade? escolaridadeFamiliarSelecionada;

  @observable
  Nacionalidade? nacionalidadeSelecionada;

  @observable
  Naturalidade? naturalidadeSelecionada;

  @observable
  CategoriaPublico? categoriaPublicoSelecionada;

  @observable
  MotivoRegistro? motivoRegistroSelecionado;

  @observable
  SubProduto? subProdutoSelecionado;

  @observable
  ProgramasGovernamentais? programasGovernamentaisSelecionado;

  @observable
  Produto? produtoSelecionado;

  @observable
  CategoriaAtividadeProdutiva? categoriaAtividadeProdutivaSelecionada;

  @observable
  bool? cafBool;

  @observable
  EntidadeCaf? EntidadeCafSelecionada;

  @observable
  EnqCaf? EnqCafSelecionada;

  @observable
  RegistroStatus? registroStatusSelecionado;

  @observable
  Municipio? municipioSelecionado;

  @observable
  Parentesco? parentescoSelecionado;

  @observable
  List<Municipio> municipioUF = [];

  @observable
  Comunidade? comunidadeSelecionada;
  
  @observable
  List<Comunidade> subComunidades = [];

  @observable
  Comunidade? subComunidadeSelecionada;

  @observable
  List<MotivoRegistro>? motivoRegistroSelecionadoLista = [];

  //Cadastro
  @observable
  Status cadastraBeneficiarioStatus = Status.NAO_CARREGADO;

  @observable
  String? mensagemError;

  //Editar(PUT)
  @observable
  Status putBeneficiarioStatus = Status.NAO_CARREGADO;

  //Delete
  @observable
  Status deleteBeneficiarioAterStatus = Status.NAO_CARREGADO;
  bool? deleteBeneficiarioSucess;

  //Editar
  BeneficiarioAterPost? beneficiarioAterEdit;

  @observable
  Status editarBeneficiarioStatus = Status.NAO_CARREGADO;

  /* Integrantes Familiares */
  @observable
  Status deleteFamiliarBeneficiarioStatus = Status.NAO_CARREGADO;
  bool? deleteFamiliarSucess;

  Status putFamiliarStatus = Status.NAO_CARREGADO;

  @observable
  Status statusFamiliaresBeneficiario = Status.NAO_CARREGADO;

  Future carregaBeneficiarios() async{

    try {
      statusCarregaBeneficiarios = Status.AGUARDANDO;

      beneficiariosFiltrados = await beneficiarioAterRepository.listaBeneficiariosAter(1);
      listaCategoriaPublico = await beneficiarioAterRepository.listaCategoriaPublico();

      if(beneficiarioAterRepository.listaAter == true){

        listaBeneficiarios = beneficiariosFiltrados;
        
        statusCarregaBeneficiarios = Status.CONCLUIDO;

      }

    } catch (e) {
      statusCarregaBeneficiarios = Status.ERRO;
      mensagemError = beneficiarioAterRepository.responseError.toString();
    }
  }

  Future carregaMaisBeneficiarios() async{

    try {
      statusCarregaMaisBeneficiarios = Status.AGUARDANDO;

      maisBeneficiariosFiltrados = await beneficiarioAterRepository.listaBeneficiariosAter(pageCounter);

      if(beneficiarioAterRepository.listaAter == true){

        listaBeneficiarios = beneficiariosFiltrados;

        beneficiariosFiltrados.addAll(maisBeneficiariosFiltrados);
        
        statusCarregaMaisBeneficiarios = Status.CONCLUIDO;

      }

      statusCarregaMaisBeneficiarios = Status.CONCLUIDO;

      pageCounter++;

    } catch (e) {
      statusCarregaBeneficiarios = Status.ERRO;
      mensagemError = beneficiarioAterRepository.responseError.toString();
    }
  }

  Future carregaBeneficiariosPorNome(String nome) async{

    try {
      statusCarregaBeneficiariosPorNome = Status.AGUARDANDO;

      beneficiariosFiltradosPorNome = await beneficiarioAterRepository.listaBeneficiariosAterPorNome(nome);

      if(beneficiarioAterRepository.listaAterPorNome == true){

        beneficiariosFiltrados.clear();

        beneficiariosFiltrados = beneficiariosFiltradosPorNome;
        
        statusCarregaBeneficiariosPorNome = Status.CONCLUIDO;

      }

      statusCarregaBeneficiariosPorNome = Status.NAO_CARREGADO;

    } catch (e) {
      statusCarregaBeneficiariosPorNome = Status.ERRO;
      mensagemError = beneficiarioAterRepository.responseError.toString();
    }
  }

  Future carregaDadosSelecionaveis() async{
    try {

      statusCarregaDadosPagina = Status.AGUARDANDO;

      listaUF = await beneficiarioAterRepository.estadosUF();
      listaEscolaridade = await beneficiarioAterRepository.listaEscolaridade();
      listaNacionalidade = await beneficiarioAterRepository.listaNacionalidade();
      listaNaturalidade = await beneficiarioAterRepository.listaNaturalidade();
      listaCategoriaPublico = await beneficiarioAterRepository.listaCategoriaPublico();
      listaMotivoRegistro = await beneficiarioAterRepository.listaMotivoRegistro();
      listaCategoriaAtividadeProdutiva = await beneficiarioAterRepository.listaAtividadeProdutiva();
      listaProdutos = await beneficiarioAterRepository.listaProdutos();
      listaSubprodutos = await beneficiarioAterRepository.listaSubprodutos();
      listaEnqCaf = await beneficiarioAterRepository.listaEnqCaf();
      listaEntidadeCaf = await beneficiarioAterRepository.listaEntidadeCaf();
      listaRegistroStatus = await beneficiarioAterRepository.listaRegistroStatus();
      listaProgramasGovernamentais = await beneficiarioAterRepository.listaProgGovernamentais();

      statusCarregaDadosPagina = Status.CONCLUIDO;
      
    } catch (e) {
      statusCarregaDadosPagina = Status.ERRO;
    }
  }

  void carregaMunicipios (UF uf) async{

    try {
      statusCarregaMunicipios = Status.AGUARDANDO;

      listaMunicipios = await beneficiarioAterRepository.listaMunicipios(uf.code);

      // Verificar se a lista foi carregada com sucesso
      if(listaMunicipios.isNotEmpty){
        statusCarregaMunicipios = Status.CONCLUIDO;
      } else {
        statusCarregaMunicipios = Status.ERRO;
      }

    } catch (e) {
      statusCarregaMunicipios = Status.ERRO;
    }

  }

  void carregaSubComunidades(Municipio municipio) async{

    try {
      statusCarregaComunidades = Status.AGUARDANDO;

      subComunidades = await beneficiarioAterRepository.listaComunidade(int.tryParse(municipio.code!));

      // Verificar se a lista foi carregada com sucesso
      if(subComunidades.isNotEmpty){
        statusCarregaComunidades = Status.CONCLUIDO;
      } else {
        statusCarregaComunidades = Status.ERRO;
      }

    } catch (e) {
      statusCarregaComunidades = Status.ERRO;
    }

  }


  Future postBeneficiarios(BeneficiarioAterPost? beneficiarioAterPost)async{

    try {
      cadastraBeneficiarioStatus = Status.AGUARDANDO;

      await beneficiarioAterRepository.postBeneficiario(beneficiarioAterPost!);

      if(beneficiarioAterRepository.postBeneficiarioCode == 201){

          cadastraBeneficiarioStatus = Status.CONCLUIDO;

          ToastAvisosSucesso("Beneficiário Cadastrado com Sucesso.");

          Modular.to.pushReplacementNamed('sucesso_cadastro_ater');

          cadastroDisposer();

      }
      else {
        cadastraBeneficiarioStatus = Status.ERRO;

        ToastAvisosSucesso("Erro ao cadastrar o beneficiário. Revise os campos e tente novamente.");

        Modular.to.pushReplacementNamed('sucesso_cadastro_ater');

        cadastroDisposer();
      }



    } catch (e) {
      statusCarregaBeneficiarios = Status.ERRO;
      ToastAvisosErro('Erro ao realizar o cadastro.');

      getEsigSnackBar(beneficiarioAterRepository.responsePOST.toString());

    }
  }

  Future putBeneficiarios(int? id, BeneficiarioAterPost? beneficiarioAterPost)async{

    try {
      putBeneficiarioStatus = Status.AGUARDANDO;

      await beneficiarioAterRepository.putBeneficiario(id ,beneficiarioAterPost!);

      if(beneficiarioAterRepository.putBeneficiarioCode == 203 || beneficiarioAterRepository.putBeneficiarioCode == 200){

          putBeneficiarioStatus = Status.CONCLUIDO;

          ToastAvisosSucesso("Beneficiário Editado com Sucesso.");

          Modular.to.pushReplacementNamed('sucesso_cadastro_ater');

          cadastroDisposer();

      }



    } catch (e) {
      statusCarregaBeneficiarios = Status.ERRO;
      ToastAvisosErro('Erro ao realizar o cadastro.');
    }
  }

  Future deleteBeneficiarioAter(int id) async{
    try {
      deleteBeneficiarioAterStatus = Status.AGUARDANDO;

      deleteBeneficiarioSucess = await beneficiarioAterRepository.deleteBeneficiario(id);

      if(deleteBeneficiarioSucess == true){
        deleteBeneficiarioAterStatus == Status.CONCLUIDO;
        ToastAvisosSucesso('Beneficiário apagado.');
      }
    } catch (e) {
      deleteBeneficiarioAterStatus = Status.ERRO;
      ToastAvisosSucesso('Erro ao apagar o beneficiário.');
    }
  }

  Future getBeneficiarioAter(int id) async {
  try {
    print('=== DEBUG CONTROLLER: Iniciando getBeneficiarioAter para ID: $id ===');
    editarBeneficiarioStatus = Status.AGUARDANDO;

    // Carrega os dados do beneficiário
    beneficiarioAterEdit = await beneficiarioAterRepository.getBeneficiario(id);
    print('=== DEBUG CONTROLLER: Dados do beneficiário carregados: ${beneficiarioAterEdit?.name} ===');

    if (beneficiarioAterRepository.editBeneficiarioCode == 200) {
      print('=== DEBUG CONTROLLER: Status 200, preenchendo dados selecionáveis ===');

      // Atribui os valores do beneficiarioAterEdit aos controladores e variáveis de estado
      _preencherDadosEdit();

      editarBeneficiarioStatus = Status.CONCLUIDO;
      print('=== DEBUG CONTROLLER: Processo concluído com sucesso ===');
    } else {
      print('=== DEBUG CONTROLLER: Status não é 200: ${beneficiarioAterRepository.editBeneficiarioCode} ===');
      editarBeneficiarioStatus = Status.ERRO;
    }

    
  } catch (e) {
    print('=== DEBUG CONTROLLER: Erro no getBeneficiarioAter: $e ===');
    editarBeneficiarioStatus = Status.ERRO;
    ToastAvisosErro('Erro ao receber dados do usuário.');
  }
}

void _preencherDadosEdit() {
  if (beneficiarioAterEdit == null) return;

  // Preenche os dados selecionáveis
  sexoSelecionado = listaSexo.firstWhere(
    (element) => element.id == beneficiarioAterEdit!.physicalPerson?.gender,
    orElse: () => listaSexo.first,
  );

  estadoCivilSelecionado = listaEstadoCivil.firstWhere(
    (element) => element.id == beneficiarioAterEdit!.physicalPerson?.civilStatus,
    orElse: () => listaEstadoCivil.first,
  );

  escolaridadeSelecionada = listaEscolaridade.firstWhere(
    (element) => element.id == beneficiarioAterEdit!.physicalPerson?.scholarityId,
    orElse: () => listaEscolaridade.first,
  );

  nacionalidadeSelecionada = listaNacionalidade.firstWhere(
    (element) => element.id == beneficiarioAterEdit!.physicalPerson?.nationalityId,
    orElse: () => listaNacionalidade.first,
  );

  naturalidadeSelecionada = listaNaturalidade.firstWhere(
    (element) => element.id == beneficiarioAterEdit!.physicalPerson?.naturalnessId,
    orElse: () => listaNaturalidade.first,
  );

  ufSelecionado = listaUF.firstWhere(
    (element) => element.code == beneficiarioAterEdit!.physicalPerson?.issuingUf,
    orElse: () => listaUF.first,
  );

  ufEnderecoSelecionado = listaUF.firstWhere(
    (element) => element.code == beneficiarioAterEdit!.cityCode,
    orElse: () => listaUF.first,
  );

  categoriaPublicoSelecionada = listaCategoriaPublico.firstWhere(
    (element) => element.id == beneficiarioAterEdit!.targetPublicId,
    orElse: () => listaCategoriaPublico.first,
  );

  motivoRegistroSelecionado = listaMotivoRegistro.firstWhere(
    (element) => element.id == beneficiarioAterEdit!.reasonMultiples?.first,
    orElse: () => listaMotivoRegistro.first,
  );

  registroStatusSelecionado = listaRegistroStatus.firstWhere(
    (element) => element.id == beneficiarioAterEdit!.registrationStatusId,
    orElse: () => listaRegistroStatus.first,
  );

  EnqCafSelecionada = listaEnqCaf.firstWhere(
    (element) => element.id == beneficiarioAterEdit!.dapId,
    orElse: () => listaEnqCaf.first,
  );

  EntidadeCafSelecionada = listaEntidadeCaf.firstWhere(
    (element) => element.id == beneficiarioAterEdit!.dapOriginId,
    orElse: () => listaEntidadeCaf.first,
  );

  // Preenche listas de múltipla escolha
  produtosSelecionados = listaProdutos.where(
    (element) => beneficiarioAterEdit!.productMultiples?.contains(element.id.toString()) ?? false,
  ).toList();

  subProdutosSelecionados = listaSubprodutos.where(
    (element) => beneficiarioAterEdit!.derivativesMultiples?.contains(element.id.toString()) ?? false,
  ).toList();

  categoriasAtividadeProdutivaSelecionadas = listaCategoriaAtividadeProdutiva.where(
    (element) => beneficiarioAterEdit!.productiveActivityMultiples?.contains(element.id.toString()) ?? false,
  ).toList();

  programasGovernamentaisSelecionados = listaProgramasGovernamentais.where(
    (element) => beneficiarioAterEdit!.governmentProgramsMultiples?.contains(element.id.toString()) ?? false,
  ).toList();

  motivosRegistroSelecionados = listaMotivoRegistro.where(
    (element) => beneficiarioAterEdit!.reasonMultiples?.contains(element.id.toString()) ?? false,
  ).toList();
}

/* Integrantes Familiares */
@observable
List<MembroFamiliar> listaMembrosFamiliares = [];
List<Parentesco>  listaParentesco = [];

MembroFamiliarPost? membroFamiliarPost;

MembroFamiliar? membroFamiliarEdit;

Future carregaFamiliares(int id) async{

    try {
      statusFamiliaresBeneficiario = Status.AGUARDANDO;

      listaMembrosFamiliares = await beneficiarioAterRepository.listaFamiliares(id);
      listaParentesco = await beneficiarioAterRepository.listaParentesco();
      listaEscolaridade = await beneficiarioAterRepository.listaEscolaridade();

      if(beneficiarioAterRepository.listaAter == true){

        listaBeneficiarios = beneficiariosFiltrados;
        
        statusFamiliaresBeneficiario = Status.CONCLUIDO;

      }

    } catch (e) {
      statusFamiliaresBeneficiario = Status.ERRO;
      mensagemError = beneficiarioAterRepository.responseError.toString();
    }
  }

  Future postFamiliar(int id, MembroFamiliarPost familiar) async{

    try {
      statusPostFamilar = Status.AGUARDANDO;
      await beneficiarioAterRepository.postFamiliar(id, familiar);

      if(beneficiarioAterRepository.postFamiliarCode == 200){

        await carregaFamiliares(id);
        ToastAvisosSucesso('Familiar cadastrado com sucesso.');
        
        statusPostFamilar = Status.CONCLUIDO;
      }
      Modular.to.pushReplacementNamed('integrantes_familia');
        
      cadastroFamiliarDisposer();

      statusPostFamilar = Status.NAO_CARREGADO;

    } catch (e) {
      statusPostFamilar = Status.ERRO;
      ToastAvisosErro('Erro ao cadastrar o familiar.');
    }

  }

  Future putFamiliarAter(int? idFamiliar, int? idBeneficiario, MembroFamiliarPut membroFamiliarPost)async{ 

    try {
      putFamiliarStatus = Status.AGUARDANDO;

      await beneficiarioAterRepository.putFamiliar(idFamiliar, membroFamiliarPost);

      if(beneficiarioAterRepository.putFamiliarCode == 203 || beneficiarioAterRepository.putFamiliarCode == 200){

          putFamiliarStatus = Status.CONCLUIDO;

          ToastAvisosSucesso("Familiar Editado com Sucesso.");

          Modular.to.pushReplacementNamed('integrantes_familia');

          cadastroFamiliarDisposer();

          await carregaFamiliares(idBeneficiario!);

      }



    } catch (e) {
      putFamiliarStatus = Status.ERRO;
      ToastAvisosErro('Erro ao editar o cadastro.');
    }
  }

  Future carregaFamiliarEdit(int id) async {
    try {
      statusCarregaFamiliar = Status.AGUARDANDO;

      // Carrega os dados do beneficiário
      membroFamiliarEdit = await beneficiarioAterRepository.getFamiliar(id);

      if (beneficiarioAterRepository.editBeneficiarioCode == 200) {

        statusCarregaFamiliar = Status.CONCLUIDO;

      }

    } catch (e) {
      statusCarregaFamiliar = Status.ERRO;
      ToastAvisosErro('Erro ao receber dados do familiar.');
    }
  }

  preencheDadosFamiliarEdit(){
    sexoFamiliarSelecionado = listaSexo.firstWhere((element) => element.id == membroFamiliarEdit!.gender, orElse: () => listaSexo.first);
    escolaridadeFamiliarSelecionada = listaEscolaridade.firstWhere((element) => element.id == membroFamiliarEdit!.scholarityId, orElse: () => listaEscolaridade.first);
    parentescoSelecionado = listaParentesco.firstWhere((element) => element.id == membroFamiliarEdit!.relatednessId, orElse: () => listaParentesco.first);
  }

  
  Future deleteFamiliarAter(int id) async{
    try {
      deleteFamiliarBeneficiarioStatus = Status.AGUARDANDO;

      deleteBeneficiarioSucess = await beneficiarioAterRepository.deleteBeneficiario(id);

      if(deleteFamiliarSucess == true){
        deleteFamiliarBeneficiarioStatus == Status.CONCLUIDO;
        ToastAvisosSucesso('Familiar apagado.');
      }
    } catch (e) {
      deleteFamiliarBeneficiarioStatus = Status.ERRO;
      ToastAvisosSucesso('Erro ao apagar o beneficiário.');
    }
  }

  void cadastroFamiliarDisposer() {
    sexoFamiliarSelecionado = null;
    dataNascimentoFamiliarPicked = DateTime.now();
    parentescoSelecionado = null;
    statusPostFamilar = Status.NAO_CARREGADO;
  }



  void cadastroDisposer() {
  sexoSelecionado = null;
  dataNascimentoPicked = DateTime.now();
  dataEmissaoRGPicked = DateTime.now();
  estadoCivilSelecionado = null;
  ufSelecionado = null;
  ufEnderecoSelecionado = null;
  escolaridadeSelecionada = null;
  nacionalidadeSelecionada = null;
  naturalidadeSelecionada = null;
  categoriaPublicoSelecionada = null;
  motivoRegistroSelecionado = null;
  subProdutoSelecionado = null;
  programasGovernamentaisSelecionado = null;
  produtoSelecionado = null;
  categoriaAtividadeProdutivaSelecionada = null;
  cafBool = null;
  EntidadeCafSelecionada = null;
  EnqCafSelecionada = null;
  registroStatusSelecionado = null;
  municipioSelecionado = null;
  municipioUF = [];
  comunidadeSelecionada = null;
  subComunidades = [];
  subComunidadeSelecionada = null;
  motivoRegistroSelecionadoLista = [];
  cadastraBeneficiarioStatus = Status.NAO_CARREGADO;
  deleteBeneficiarioAterStatus = Status.NAO_CARREGADO;
  deleteBeneficiarioSucess = null;
  beneficiarioAterEdit = null;
  editarBeneficiarioStatus = Status.NAO_CARREGADO;
  produtosSelecionados = [];
  motivosRegistroSelecionados = [];
  subProdutosSelecionados = [];
  categoriasAtividadeProdutivaSelecionadas = [];
  programasGovernamentaisSelecionados = [];
  termoBusca = '';
  statusCarregaBeneficiarios = Status.NAO_CARREGADO;
  statusCarregaBeneficiariosPorNome = Status.NAO_CARREGADO;
  statusCarregaMaisBeneficiarios = Status.NAO_CARREGADO;
  statusCarregaDadosPagina = Status.NAO_CARREGADO;
  statusCarregaMunicipios = Status.NAO_CARREGADO;
  statusCarregaComunidades = Status.NAO_CARREGADO;
  listaBeneficiarios = [];
  beneficiariosFiltrados = [];
  beneficiariosFiltradosPorNome = [];
  maisBeneficiariosFiltrados = [];
  listaSexo = [Sexo(id: 1, name: 'Masculino'), Sexo(id: 2, name: 'Feminino'), Sexo(id: 3, name: 'Outro')];
  listaEstadoCivil = [EstadoCivil(id: 1, name: 'Não informado'), EstadoCivil(id: 2, name: 'Casado(a)'), EstadoCivil(id: 3, name: 'Divorciado(a)'), EstadoCivil(id: 4, name: 'Separado(a)'), EstadoCivil(id: 5, name: 'Solteiro(a)'), EstadoCivil(id: 6, name: 'União Estável'), EstadoCivil(id: 7, name: 'Viúvo(a)')];
  listaEscolaridade = [];
  listaNacionalidade = [];
  listaNaturalidade = [];
  listaUF = [];
  listaCategoriaPublico = [];
  listaMotivoRegistro = [];
  listaCategoriaAtividadeProdutiva = [];
  listaProdutos = [];
  listaSubprodutos = [];
  listaEnqCaf = [];
  listaEntidadeCaf = [];
  listaRegistroStatus = [];
  listaComunidade = [];
  listaMunicipios = [];
  listaProgramasGovernamentais = [];
}

  @action
  void changeSexoSelecionada(Sexo? e){
    if (e == null) return;
    sexoSelecionado = e;
  }

  @action
  void changeEstadoCivilSelecionada(EstadoCivil? e){
    if (e == null) return;
    estadoCivilSelecionado = e;
  }

  @action
  void changeUfSelecionada(UF? e){
    if (e == null) return;
    ufSelecionado = e;
  }

  @action
  void changeUfEnderecoSelecionada(UF? e){
    if (e == null) return;
    ufEnderecoSelecionado = e;
    // Limpar campos dependentes quando o UF muda
    municipioSelecionado = null;
    comunidadeSelecionada = null;
    subComunidades = [];
    subComunidadeSelecionada = null;
    // Resetar status para recarregar municípios
    statusCarregaMunicipios = Status.NAO_CARREGADO;
    statusCarregaComunidades = Status.NAO_CARREGADO;
    carregaMunicipios(e);
  }

  @action
  void changeEscolaridadeSelecionada(Escolaridade? e){
    if (e == null) return;
    escolaridadeSelecionada = e;
  }

  @action
  void changeNacionalidadeSelecionada(Nacionalidade? e){
    if (e == null) return;
    nacionalidadeSelecionada = e;
  }

  @action
  void changeNaturalidadeSelecionada(Naturalidade? e){
    if (e == null) return;
    naturalidadeSelecionada = e;
  }

  @action
  void changeCategoriaPublicoSelecionada(CategoriaPublico? e){
    if (e == null) return;
    categoriaPublicoSelecionada = e;
  }
  /* MOTIVO REGISTRO */
   @action
  void changeMotivoRegistroSelecionada(MotivoRegistro? e){
    if (e == null) return;
    motivoRegistroSelecionado = e;
    addMotivoRegistroSelecionado(e);
  }
  @action
  void addMotivoRegistroSelecionado(MotivoRegistro? e){
    if (e == null) return;
    motivosRegistroSelecionados.add(e);
  }
  @action
  void changeParentescoSelecionada(Parentesco? e){
    if (e == null) return;
    parentescoSelecionado = e;
  }
   @action
  void changeSexoFamiliarSelecionada(Sexo? e){
    if (e == null) return;
    sexoFamiliarSelecionado = e;
  }

   @action
  void changeEscolaridadeFamiliarSelecionada(Escolaridade? e){
    if (e == null) return;
    escolaridadeFamiliarSelecionada = e;
  }
  @action
  void deleteMotivosRegustroSelecionado(MotivoRegistro? e){
    if (e == null) return;
    motivosRegistroSelecionados.removeLast();
  }
  /* ATIVIDADE PRODUTIVA */
   @action
  void changeAtividadeProdutivaSelecionada(CategoriaAtividadeProdutiva? e){
    if (e == null) return;
    categoriaAtividadeProdutivaSelecionada = e;
    addAtividadeProdutivaSelecionado(e);
  }
  @action
  void addAtividadeProdutivaSelecionado(CategoriaAtividadeProdutiva? e){
    if (e == null) return;
    categoriasAtividadeProdutivaSelecionadas.add(e);
  }
  @action
  void deleteAtividadeProdutivaSelecionado(CategoriaAtividadeProdutiva? e){
    if (e == null) return;
    categoriasAtividadeProdutivaSelecionadas.removeLast();
  }
  /* PRODUTOS */

   @action
  void changeProdutoSelecionada(Produto? e){
    if (e == null) return;
    produtoSelecionado = e;
    addProdutoSelecionado(e);
  }
  
  @action
  void addProdutoSelecionado(Produto? e){
    if (e == null) return;
    produtosSelecionados.add(e);
  }
  
  @action
  void deleteProdutoSelecionado(Produto? e){
    if (e == null) return;
    produtosSelecionados.removeLast();
  }

  /* PROGRAMAS GOVERNAMENTAIS */

   @action
  void changeProgGovSelecionada(ProgramasGovernamentais? e){
    if (e == null) return;
    programasGovernamentaisSelecionado = e;
    addProgGovSelecionado(e);
  }
  
  @action
  void addProgGovSelecionado(ProgramasGovernamentais? e){
    if (e == null) return;
    programasGovernamentaisSelecionados.add(e);
  }
  
  @action
  void deleteProgGovSelecionado(ProgramasGovernamentais? e){
    if (e == null) return;
    programasGovernamentaisSelecionados.removeLast();
  }

 /*SUBPRODUTOS*/
   @action
  void changeSubProdutoSelecionada(SubProduto? e){
    if (e == null) return;
    subProdutoSelecionado = e;
    addSubProdutoSelecionado(e);
  }
  @action
  void addSubProdutoSelecionado(SubProduto? e){
    if (e == null) return;
    subProdutosSelecionados.add(e);
  }
  
  @action
  void deleteSubProdutoSelecionado(SubProduto? e){
    if (e == null) return;
    subProdutosSelecionados.removeLast();
  }

  @action
  void changeEnqCafSelecionada(EnqCaf? e){
    if (e == null) return;
    EnqCafSelecionada = e;
  }

  @action
  void changeEntidadeCafSelecionada(EntidadeCaf? e){
    if (e == null) return;
    EntidadeCafSelecionada = e;
  }

  @action
  void changeRegistroStatusSelecionada(RegistroStatus? e){
    if (e == null) return;
    registroStatusSelecionado = e;
  }

  @action
  void changeComunidadeSelecionada(Comunidade? e){
    if (e == null) return;
    comunidadeSelecionada = e;
  }

  @action
  void changeMunicipioSelecionada(Municipio? e){
    if (e == null) return;
    municipioSelecionado = e;
    // Limpar comunidade quando o município muda
    comunidadeSelecionada = null;
    subComunidadeSelecionada = null;
    // Resetar status para recarregar comunidades
    statusCarregaComunidades = Status.NAO_CARREGADO;
    carregaSubComunidades(e);
  }

   @action
  void changesubComunidadeSelecionada(Comunidade? e){
    if (e == null) return;
    subComunidadeSelecionada = e;
  }

  @action
  void addRegistroMotivo(MotivoRegistro? e){
    if (e == null) return;
    motivoRegistroSelecionadoLista!.add(e);
  }

  @action
  void removeRegistroMotivo(MotivoRegistro? e){
    if (e == null) return;
    motivoRegistroSelecionadoLista!.remove(e);
  }
  
  Future<String?> baixarProntuarioPdf(int id) async {
    try {
      final prontuario = await beneficiarioAterRepository.prontuarioBeneficiarioAter(id);
      return prontuario.data?.pdf_base64;
    } catch (e) {
      return null;
    }
  }

  // --- PRONTUÁRIO ---
  @observable
  Status statusCarregaProntuario = Status.NAO_CARREGADO;

  @observable
  Prontuario? prontuario;

  @observable
  String? prontuarioError;

  @action
  Future<void> carregarProntuario(int id) async {
    try {
      print('=== DEBUG BENEFICIARIO ATER CONTROLLER: Iniciando carregamento do prontuário ===');
      statusCarregaProntuario = Status.AGUARDANDO;
      prontuarioError = null;

      final prontuarioData = await beneficiarioAterRepository.prontuarioBeneficiarioAter(id);
      print('=== DEBUG BENEFICIARIO ATER CONTROLLER: Prontuário carregado com sucesso ===');

      prontuario = prontuarioData;
      statusCarregaProntuario = Status.CONCLUIDO;
    } catch (e) {
      print('=== DEBUG BENEFICIARIO ATER CONTROLLER: Erro ao carregar prontuário: $e ===');
      statusCarregaProntuario = Status.ERRO;
      prontuarioError = 'Erro ao carregar prontuário: $e';
    }
  }

  @action
  String? getProntuarioPdfBase64() {
    return prontuario?.data?.pdf_base64;
  }

  @action
  void resetProntuarioState() {
    statusCarregaProntuario = Status.NAO_CARREGADO;
    prontuario = null;
    prontuarioError = null;
  }

  @action
  void resetEditState() {
    editarBeneficiarioStatus = Status.NAO_CARREGADO;
    beneficiarioAterEdit = null;
    mensagemError = null;
    
    // Limpa os dados selecionáveis
    sexoSelecionado = null;
    estadoCivilSelecionado = null;
    ufSelecionado = null;
    ufEnderecoSelecionado = null;
    escolaridadeSelecionada = null;
    nacionalidadeSelecionada = null;
    naturalidadeSelecionada = null;
    categoriaPublicoSelecionada = null;
    motivoRegistroSelecionado = null;
    subProdutoSelecionado = null;
    programasGovernamentaisSelecionado = null;
    produtoSelecionado = null;
    categoriaAtividadeProdutivaSelecionada = null;
    cafBool = null;
    EntidadeCafSelecionada = null;
    EnqCafSelecionada = null;
    registroStatusSelecionado = null;
    municipioSelecionado = null;
    comunidadeSelecionada = null;
    
    // Limpa as listas
    produtosSelecionados = [];
    motivosRegistroSelecionados = [];
    subProdutosSelecionados = [];
    categoriasAtividadeProdutivaSelecionadas = [];
    programasGovernamentaisSelecionados = [];
  }
  
}
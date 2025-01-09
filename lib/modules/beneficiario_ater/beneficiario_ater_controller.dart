import 'package:esig_utils/status.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:sisater_mobile/models/beneficiarios/beneficiario_ater.dart';
import 'package:sisater_mobile/models/beneficiarios/beneficiario_ater_post.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/categoria_atividade_produtiva.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/categoria_publico.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/comunidade.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/enq_caf.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/entidade_caf.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/escolaridade.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/estado_civil.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/motivo_registro.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/municipio.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/nacionalidade.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/naturalidade.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/produto.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/registro_status.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/sexo.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/subproduto.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/uf.dart';
import 'package:sisater_mobile/modules/beneficiario_ater/repository/beneficiario_ater_repository.dart';
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
  String termoBusca = '';

  @observable
  Status statusCarregaBeneficiarios = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaDadosPagina = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaMunicipios = Status.NAO_CARREGADO;

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


  
  @observable
  Sexo? sexoSelecionado;

  @observable
  EstadoCivil? estadoCivilSelecionado;

  @observable
  UF? ufSelecionado;

  @observable
  UF? ufEnderecoSelecionado;

  @observable
  Escolaridade? escolaridadeSelecionada;

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
  Produto? produtoSelecionado;

  @observable
  CategoriaAtividadeProdutiva? categoriaAtividadeProdutivaSelecionada;

  @observable
  bool? cafBool;

  @observable
  EntidadeCaf? entidadeCaf;

  @observable
  EnqCaf? enqCaf;

  @observable
  RegistroStatus? registroStatusSelecionado;

  @observable
  Municipio? municipioSelecionado;

  List<Municipio> municipioUF = [];

  @observable
  Comunidade? comunidadeSelecionada;

  List<Comunidade> subComunidades = [];

  @observable
  Comunidade? subComunidadeSelecionada;

  @observable
  List<MotivoRegistro>? motivoRegistroSelecionadoLista = [];

  //Cadastro
  @observable
  Status cadastraBeneficiarioStatus = Status.NAO_CARREGADO;

  //Delete
  @observable
  Status deleteBeneficiarioAterStatus = Status.NAO_CARREGADO;
  bool? deleteBeneficiarioSucess;



  Future carregaBeneficiarios() async{
    try {
      statusCarregaBeneficiarios = Status.AGUARDANDO;

      beneficiariosFiltrados = await beneficiarioAterRepository.listaBeneficiariosAter();

      if(beneficiarioAterRepository.listaAter == true){

        statusCarregaBeneficiarios = Status.CONCLUIDO;

      }

    } catch (e) {
      statusCarregaBeneficiarios = Status.ERRO;
    }
  }

  Future carregaDadosSelecionaveis() async{
    try {

      statusCarregaDadosPagina = Status.AGUARDANDO;

      listaEscolaridade = await beneficiarioAterRepository.listaEscolaridade();
      listaNacionalidade = await beneficiarioAterRepository.listaNacionalidade();
      listaNaturalidade = await beneficiarioAterRepository.listaNaturalidade();
      listaUF = await beneficiarioAterRepository.estadosUF();
      listaCategoriaPublico = await beneficiarioAterRepository.listaCategoriaPublico();
      listaMotivoRegistro = await beneficiarioAterRepository.listaMotivoRegistro();
      listaCategoriaAtividadeProdutiva = await beneficiarioAterRepository.listaAtividadeProdutiva();
      listaProdutos = await beneficiarioAterRepository.listaProdutos();
      listaSubprodutos = await beneficiarioAterRepository.listaSubprodutos();
      listaEnqCaf = await beneficiarioAterRepository.listaEnqCaf();
      listaEntidadeCaf = await beneficiarioAterRepository.listaEntidadeCaf();
      listaRegistroStatus = await beneficiarioAterRepository.listaRegistroStatus();
      listaMunicipios = await beneficiarioAterRepository.listaMunicipios();
      listaComunidade = await beneficiarioAterRepository.listaComunidade();

      statusCarregaDadosPagina = Status.CONCLUIDO;
      
    } catch (e) {
      statusCarregaDadosPagina = Status.ERRO;
    }
  }

  void carregaMunicipios () async{
    municipioUF = listaMunicipios.where((element) => element.ufCode.toString() == ufEnderecoSelecionado!.code.toString()).toList();

  }

  void carregaSubComunidades() async{
    subComunidades = listaComunidade.where((element) => element.cityCode == municipioSelecionado!.code).toList();
  }


  Future postBeneficiarios(BeneficiarioAterPost? beneficiarioAterPost)async{

    try {
      cadastraBeneficiarioStatus = Status.AGUARDANDO;

      await beneficiarioAterRepository.postBeneficiario(beneficiarioAterPost!);

      if(beneficiarioAterRepository.postBeneficiarioCode == 203 || beneficiarioAterRepository.postBeneficiarioCode == 200){
        cadastraBeneficiarioStatus = Status.CONCLUIDO;

          ToastAvisosSucesso("Beneficiário Cadastrado com Sucesso.");

          Modular.to.pushReplacementNamed('sucesso_cadastro_ater');
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

 @action
void atualizaTermoBusca(String termo) {
  termoBusca = termo;
  // Filtrando a lista original (listaBeneficiarios) com base no termo
  beneficiariosFiltrados = listaBeneficiarios.where((beneficiario) {
    final query = termo.toLowerCase();

    return (beneficiario.name?.toLowerCase().contains(query) ?? false) ||
           (beneficiario.document?.contains(query) ?? false) ||
           (beneficiario.cellphone?.contains(query) ?? false);
  }).toList();
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
    carregaMunicipios();
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

   @action
  void changeMotivoRegistroSelecionada(MotivoRegistro? e){
    if (e == null) return;
    motivoRegistroSelecionado = e;
  }

   @action
  void changeAtividadeProdutivaSelecionada(CategoriaAtividadeProdutiva? e){
    if (e == null) return;
    categoriaAtividadeProdutivaSelecionada = e;
  }

   @action
  void changeProdutoSelecionada(Produto? e){
    if (e == null) return;
    produtoSelecionado = e;
  }

   @action
  void changeSubProdutoSelecionada(SubProduto? e){
    if (e == null) return;
    subProdutoSelecionado = e;
  }

  @action
  void changeEnqCafSelecionada(EnqCaf? e){
    if (e == null) return;
    enqCaf = e;
  }

  @action
  void changeEntidadeCafSelecionada(EntidadeCaf? e){
    if (e == null) return;
    entidadeCaf = e;
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
  
}
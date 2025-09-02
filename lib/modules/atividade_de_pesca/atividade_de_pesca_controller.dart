
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:sisater_mobile/models/atividade_de_pesca/atividadePescaPost.dart';
import 'package:sisater_mobile/models/atividade_de_pesca/atividade_pesca.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater.dart';
import 'package:sisater_mobile/models/comunidades/comunidade_selecionavel.dart';
import 'package:sisater_mobile/modules/atividade_de_pesca/repository/atividade_de_pesca_repository.dart';
import 'package:esig_utils/status.dart';
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_sucesso.dart';

part 'atividade_de_pesca_controller.g.dart';

class AtividadeDePescaController = _AtividadeDePescaControllerBase with _$AtividadeDePescaController;

abstract class _AtividadeDePescaControllerBase with Store {

  final AtividadeDePescaRepository repository;

  _AtividadeDePescaControllerBase(this.repository);

  @observable
  Status statusAtividadePescaList = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaMaisAtividadesPesca = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaAtividadePorNome = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaMunicipios = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaBeneficiariosAter = Status.NAO_CARREGADO;

  @observable
  Status statusPostAtividadePesca = Status.NAO_CARREGADO;

  @observable
  Status statusDeleteAtividadePesca = Status.NAO_CARREGADO;

  @observable
  List<AtividadePesca> atividades = [];

  @observable
  List<AtividadePesca> maisAtividadesFiltradas = [];

  @observable
  List<AtividadePesca> atividadesFiltradasPorNome = [];

  @observable
  List<BeneficiarioAter> beneficiariosAter = [];

  @observable
  List<ComunidadeSelecionavel> comunidadesSelecionaveis = [];

  ComunidadeSelecionavel? comunidadeSelecionada;

  BeneficiarioAter? beneficiarioSelecionado;



  @observable
  String mensagemErro = '';

  @observable
  int pageCounter = 0;

  @action
  Future<void> carregarAtividadesPesca() async {

    try {
      statusAtividadePescaList = Status.AGUARDANDO;
      atividades = await repository.getAtividadeDePesca(1);

      if(repository.getAtividadePesca){
        statusAtividadePescaList = Status.CONCLUIDO;
      } 
      else{
        statusAtividadePescaList = Status.ERRO;
        mensagemErro = 'Erro ao carregar atividades de pesca.';
      }
      
    
    } catch (e) {
      mensagemErro = e.toString();
      statusAtividadePescaList = Status.ERRO;
    }
  }

  Future carregaMaisAtividadesPesca() async {
    try {
      statusCarregaMaisAtividadesPesca = Status.AGUARDANDO;

      maisAtividadesFiltradas = await repository.getAtividadeDePesca(pageCounter);

      if (repository.getAtividadePesca == true) {
        atividades.addAll(maisAtividadesFiltradas);
        statusCarregaMaisAtividadesPesca = Status.CONCLUIDO;
        pageCounter++;
      } else {
        statusCarregaMaisAtividadesPesca = Status.ERRO;
        mensagemErro = 'Erro ao carregar mais atividades de pesca.';
      }

    } catch (e) {
      statusCarregaMaisAtividadesPesca = Status.ERRO;
      mensagemErro = e.toString();
    }
  }

  Future carregaAtividadePorNome(String nome) async{

    try {
      statusCarregaAtividadePorNome = Status.AGUARDANDO;

      atividadesFiltradasPorNome = await repository.listaatividadePorNome(nome);

      if(repository.listaAtividadePorNome == true){

        atividades.clear();

        atividades = atividadesFiltradasPorNome;
            
        statusCarregaAtividadePorNome = Status.CONCLUIDO;

      } else {
        statusCarregaAtividadePorNome = Status.ERRO;
        mensagemErro = 'Nenhuma atividade encontrada com esse nome.';
      }

    } catch (e) {
      statusCarregaAtividadePorNome = Status.ERRO;
      mensagemErro = e.toString();
    }
  }


  
  @action
  Future<void> carregarMunicipios() async {
    try {
      statusCarregaMunicipios = Status.AGUARDANDO;
      comunidadesSelecionaveis = [];

      comunidadesSelecionaveis = await repository.listaMunicipios();

      if (repository.carregaMunicipios) {
        statusCarregaMunicipios = Status.CONCLUIDO;
      } else {
        statusCarregaMunicipios = Status.ERRO;
        mensagemErro = 'Erro ao carregar municípios.';
      }

    } catch (e) {
      statusCarregaMunicipios = Status.ERRO;
      mensagemErro = e.toString();
    }
  }

  @action
  Future<void> carregarBeneficiariosAter(String idCidade) async {
    try {
      statusCarregaBeneficiariosAter = Status.AGUARDANDO;
      beneficiariosAter = [];

      beneficiariosAter = await repository.listaBeneficiariosAter(idCidade);

      if(beneficiariosAter.isNotEmpty){
        statusCarregaBeneficiariosAter = Status.CONCLUIDO;
      } else {
        statusCarregaBeneficiariosAter = Status.ERRO;
        mensagemErro = 'Nenhum beneficiário encontrado para a comunidade selecionada.';
      }

    } catch (e) {
      statusCarregaBeneficiariosAter = Status.ERRO;
      mensagemErro = e.toString();
    }
  }
  
  @action
  Future<void> postAtividadePesca(AtividadePescaPost atividadePesca) async {
    try {

      statusPostAtividadePesca = Status.AGUARDANDO;

      bool postAtividade = await repository.atividadePescaPost(atividadePesca);

      if (postAtividade) {

        statusPostAtividadePesca = Status.CONCLUIDO;
        await carregarAtividadesPesca();

      } 

      Modular.to.popAndPushNamed('/atividade_pesca');

      ToastAvisosSucesso('Atividade de pesca criada com sucesso!');

      atividadePescaDisposer();

      statusPostAtividadePesca = Status.NAO_CARREGADO;

    } catch (e) {
      mensagemErro = e.toString();
      statusPostAtividadePesca = Status.ERRO;
    }
  }

  @action
  Future<void> putAtividadePesca(AtividadePesca atividadePesca, int id) async {
    try {

      statusPostAtividadePesca = Status.AGUARDANDO;

      bool postAtividade = await repository.atividadePescaPut(atividadePesca, id);

      if (postAtividade) {

        statusPostAtividadePesca = Status.CONCLUIDO;

        await carregarAtividadesPesca();

        Modular.to.popAndPushNamed('/atividade_pesca');

        ToastAvisosSucesso('Atividade de pesca editada com sucesso!');

      } 

      atividadePescaDisposer();

      statusPostAtividadePesca = Status.NAO_CARREGADO;

    } catch (e) {
      mensagemErro = e.toString();
      statusPostAtividadePesca = Status.ERRO;
    }
  }

  @action
  Future<void> deleteAtividadePesca(int id) async {
    try {

      statusDeleteAtividadePesca = Status.AGUARDANDO;

      bool deleteAtividade = await repository.atividadePescaDelete(id);

      if (deleteAtividade) {

        statusDeleteAtividadePesca = Status.CONCLUIDO;
        await carregarAtividadesPesca();

      } 

      Modular.to.popAndPushNamed('/atividade_pesca');

      ToastAvisosSucesso('Atividade de pesca excluída com sucesso!');

      atividadePescaDisposer();

      statusDeleteAtividadePesca = Status.NAO_CARREGADO;

    } catch (e) {
      mensagemErro = e.toString();
      statusDeleteAtividadePesca = Status.ERRO;
    }
  }




  void atividadePescaDisposer() {
    comunidadeSelecionada = null;
    beneficiarioSelecionado = null;
    pageCounter = 0;
  }

  
  @action
  void changeComunidadeSelecionada(ComunidadeSelecionavel? value) {
    comunidadeSelecionada = value;
    if (value != null) {
      carregarBeneficiariosAter(value.code!);
    } else {
      beneficiariosAter = [];
      statusCarregaBeneficiariosAter = Status.NAO_CARREGADO;
    }
  }
  
  @action
  void changeBeneficiarioAterSelecionado(BeneficiarioAter? value) {
    beneficiarioSelecionado = value;
  }
}
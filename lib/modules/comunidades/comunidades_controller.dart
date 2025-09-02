import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:esig_utils/status.dart';
import 'package:sisater_mobile/models/comunidades/comunidade_selecionavel.dart';
import 'package:sisater_mobile/models/comunidades/comunidades_list.dart';
import 'package:sisater_mobile/models/comunidades/comunidades_post.dart';
import 'package:sisater_mobile/models/comunidades/tipo_acesso.dart';
import 'package:sisater_mobile/modules/comunidades/repository/comunidades_repository.dart';
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_erro.dart';
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_sucesso.dart';

part 'comunidades_controller.g.dart';

class ComunidadesController = _ComunidadesControllerBase with _$ComunidadesController;

abstract class _ComunidadesControllerBase with Store {
  final ComunidadesRepository comunidadesRepository;

  _ComunidadesControllerBase({required this.comunidadesRepository});

  @observable
  Status statusCarregaComunidades = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaMaisComunidades = Status.NAO_CARREGADO;

   @observable
  Status statusCarregaComunidadesSel = Status.NAO_CARREGADO;

  @observable
  Status statusPostComunidades = Status.NAO_CARREGADO;

  @observable
  Status statusPutComunidades = Status.NAO_CARREGADO;

  @observable
  Status statusDeleteComunidades = Status.NAO_CARREGADO;

  @observable
  Status statusCarregaComunidadesPorNome = Status.NAO_CARREGADO;

  @observable
  String mensagemError = '';

  @observable
  int pageCounter = 0;

  List<String> unidadeMedida = [
    'Km',
    'Hora',
  ];

  List<TipoAcesso> tipoAcesso = [
    TipoAcesso(
      id: 1,
      descricao: 'Terrestre',
    ),
    TipoAcesso(
      id: 2,
      descricao: 'Fluvial',
    ),
  ];

  @observable
  List<ComunidadesList> listaComunidades = [];

  @observable
  List<ComunidadesList> comunidadesFiltradas = [];

  @observable
  List<ComunidadesList> maisComunidadesFiltradas = [];

  @observable
  List<ComunidadesList> comunidadesFiltradosPorNome = [];

  @observable
  ComunidadeSelecionavel? comunidadeSelecionada;

  @observable
  TipoAcesso? tipoAcessoSelecionado;

  @observable
  String? unidadeMedidaSelecionado;
  
  @observable
  List<ComunidadeSelecionavel> comunidadesSelecionaveis = [];

  @observable
  ComunidadesList? comunidadeEditando;

  @observable
  Status statusPutComunidade = Status.NAO_CARREGADO;

  Future carregaComunidades() async {
    try {
      statusCarregaComunidades = Status.AGUARDANDO;

      await carregaSubComunidades();
      comunidadesFiltradas = await comunidadesRepository.listaComunidades(1);

      if (comunidadesRepository.listaComunidadesbool == true) {
        listaComunidades = comunidadesFiltradas;
        statusCarregaComunidades = Status.CONCLUIDO;
      }
    } catch (e) {
      statusCarregaComunidades = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  Future carregaMaisComunidades() async {
    try {
      statusCarregaMaisComunidades = Status.AGUARDANDO;

      maisComunidadesFiltradas = await comunidadesRepository.listaComunidades(pageCounter);

      if (comunidadesRepository.listaComunidadesbool == true) {
        comunidadesFiltradas.addAll(maisComunidadesFiltradas);
        listaComunidades = comunidadesFiltradas;
        statusCarregaMaisComunidades = Status.CONCLUIDO;
      } else {
        statusCarregaMaisComunidades = Status.ERRO;
        mensagemError = 'Erro ao carregar mais comunidades.';
      }

      pageCounter++;
    } catch (e) {
      statusCarregaMaisComunidades = Status.ERRO;
      mensagemError = e.toString();
    }
  }

  Future carregaComunidadesPorNome(String nome) async{

    try {
      statusCarregaComunidadesPorNome = Status.AGUARDANDO;

      comunidadesFiltradosPorNome = await comunidadesRepository.listaComunidadePorNome(nome);

      if(comunidadesRepository.listaAterPorNome == true){

        comunidadesFiltradas.clear();

        comunidadesFiltradas = comunidadesFiltradosPorNome;
            
        statusCarregaComunidadesPorNome = Status.CONCLUIDO;

      }

      statusCarregaComunidadesPorNome = Status.NAO_CARREGADO;

    } catch (e) {
      statusCarregaComunidadesPorNome = Status.ERRO;
      //mensagemError = beneficiarioAterRepository.responseError.toString();
    }
  }

   carregaSubComunidades() async{

    try {
      statusCarregaComunidadesSel = Status.AGUARDANDO;

      comunidadesSelecionaveis = await comunidadesRepository.listaMunicipios();

      if(comunidadesRepository.postComunidadeCode == true){
        statusCarregaComunidadesSel = Status.CONCLUIDO;
      }

    } catch (e) {
      statusCarregaComunidadesSel = Status.ERRO;
    }

  }

  void postComunidade(ComunidadesPost comunidade) async {
    try {
      statusPostComunidades = Status.AGUARDANDO;

      await comunidadesRepository.postComunidade(comunidade);

      if (comunidadesRepository.postComunidadeCode == true) {

        comunidadesFiltradas = await comunidadesRepository.listaComunidades(1);
        
        ToastAvisosSucesso('Comunidade cadastrada com sucesso!');
        statusPostComunidades = Status.CONCLUIDO;

      }

      Modular.to.popAndPushNamed('/comunidades');

      comunidadesDisposer();

      statusPostComunidades = Status.NAO_CARREGADO;

    } catch (e) {
      statusPostComunidades = Status.ERRO;
      ToastAvisosErro('Erro ao cadastrar comunidade.');
    }
  }

  void putComunidade(ComunidadesPost comunidade, int id) async {
    try {
      statusPutComunidades = Status.AGUARDANDO;

      await comunidadesRepository.putComunidade(comunidade, id);

      if (comunidadesRepository.putComunidadeCode == true) {

        comunidadesFiltradas = await comunidadesRepository.listaComunidades(1);
        
        ToastAvisosSucesso('Comunidade atualizada com sucesso!');
        statusPutComunidades = Status.CONCLUIDO;

      }

      Modular.to.popAndPushNamed('/comunidades');

      comunidadesDisposer();

      statusPutComunidades = Status.NAO_CARREGADO;

    } catch (e) {
      statusPutComunidades = Status.ERRO;
      ToastAvisosErro('Erro ao atualizar comunidade.');
    }
  }

  @action
  Future<void> editarComunidade(ComunidadesPost comunidade, int id) async {
    try {
      statusPutComunidade = Status.AGUARDANDO;
      await comunidadesRepository.putComunidade(comunidade, id);
      if (comunidadesRepository.postComunidadeCode == true) {
        statusPutComunidade = Status.CONCLUIDO;
      } else {
        statusPutComunidade = Status.ERRO;
      }
    } catch (e) {
      statusPutComunidade = Status.ERRO;
    }
  }

  @action
  Future<void> deleteComunidade(int id) async {
    try {
      statusDeleteComunidades = Status.AGUARDANDO;

      int response = await comunidadesRepository.deleteComunidade(id);

      if (response == 200) {

        comunidadesFiltradas = await comunidadesRepository.listaComunidades(1);

        statusDeleteComunidades = Status.CONCLUIDO;

        ToastAvisosSucesso('Comunidade excluída com sucesso!');

      } 

      statusDeleteComunidades = Status.NAO_CARREGADO;

    } catch (e) {
      statusDeleteComunidades = Status.ERRO;
      ToastAvisosErro('Erro ao excluir comunidade.');
    }
  }

  void comunidadesDisposer() {
    statusCarregaComunidades = Status.NAO_CARREGADO;
    statusCarregaMaisComunidades = Status.NAO_CARREGADO;
    statusCarregaComunidadesSel = Status.NAO_CARREGADO;
    statusPostComunidades = Status.NAO_CARREGADO;
    mensagemError = '';
    pageCounter = 0;
    listaComunidades = [];
    comunidadesFiltradas = [];
    maisComunidadesFiltradas = [];
    comunidadeSelecionada = null;
    tipoAcessoSelecionado = null;
    unidadeMedidaSelecionado = null;
    //comunidadesSelecionaveis = [];
  }

  @action
  void changeComunidadeSelecionada(ComunidadeSelecionavel? e){
    if (e == null) return;
    comunidadeSelecionada = e;
  }

  @action
  void changeTipoAcessoSelecionada(TipoAcesso? e){
    if (e == null) return;
    tipoAcessoSelecionado = e;
  }

  @action
  void changeUnidadeMedSelecionada(String? e){
    if (e == null) return;
    unidadeMedidaSelecionado = e;
  }

  @action
  void setComunidadeEditando(ComunidadesList comunidade) {
    comunidadeEditando = comunidade;
  }
}
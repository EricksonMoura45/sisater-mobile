import 'package:enviroment_flavor/enviroment_flavor.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:loading_empty_error/snackbar.dart';
import 'package:mobx/mobx.dart';
import 'package:one_context/one_context.dart';
import 'package:sisater_mobile/models/autenticacao/login_response.dart';
import 'package:sisater_mobile/models/autenticacao/usuario_dados.dart';
import 'package:sisater_mobile/models/offline/offline_data.dart';
import 'package:sisater_mobile/models/offline/offline_beneficiario_fater.dart';
import 'package:sisater_mobile/modules/autenticacao/exceptions/login_nao_persistido.dart';
import 'package:sisater_mobile/shared/utils/crashlytics_handler.dart';
import 'package:sisater_mobile/shared/utils/shared_prefs.dart';
import 'package:sisater_mobile/shared/utils/connectivity_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;

part 'app_store.g.dart';

class AppStore = _AppStoreBase with _$AppStore;

abstract class _AppStoreBase with Store {
  final prefs = SharedPrefs();
  late final String appVersion;

  _AppStoreBase() {
    final envFlavor = EnvironmentFlavor();
    final appVersion = envFlavor.getProperty('appVersion');
    final buildNumber = envFlavor.getProperty('buildNumber');
    this.appVersion = 'v$appVersion+$buildNumber';
  }

  // Test constructor that bypasses EnvironmentFlavor
  _AppStoreBase._test() {
    this.appVersion = 'v1.0.0+1';
  }
  
  @observable
  LoginResponse? loginResponse;

  @observable
  UsuarioDados? usuarioDados;

  @observable
  OfflineData? offlineData;

  @observable
  bool isOnline = true;

  @observable
  List<OfflineBeneficiarioFater> offlineBeneficiarios = [];

  @computed
  get isLogado => loginResponse != null;

  @computed
  get hasOfflineData => offlineData != null;

  @computed
  get pendingSyncCount => offlineBeneficiarios.where((b) => !b.isSynced).length;

  void updateLoginResponse(LoginResponse newValue) {
    loginResponse?.accessToken = newValue.accessToken;
  }

  @action
  Future<void> checkConnectivity() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      isOnline = connectivityResult != ConnectivityResult.none;
      
      // Se voltou a ficar online, sincronizar dados pendentes
      if (isOnline && pendingSyncCount > 0) {
        await syncOfflineData();
      }
    } catch (e) {
      developer.log('Erro ao verificar conectividade: $e');
      isOnline = false;
    }
  }

  @action
  Future<void> startConnectivityMonitoring() async {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      isOnline = result != ConnectivityResult.none;
      
      // Se voltou a ficar online, sincronizar dados pendentes
      if (isOnline && pendingSyncCount > 0) {
        syncOfflineData();
      }
    });
  }

  @action
  Future<void> saveOfflineData(OfflineData data) async {
    try {
      offlineData = data;
      await prefs.save('offline_data', data.toJson());
      developer.log('Dados offline salvos com sucesso');
    } catch (e) {
      developer.log('Erro ao salvar dados offline: $e');
    }
  }

  @action
  Future<void> loadOfflineData() async {
    try {
      if (await prefs.contem('offline_data')) {
        final data = await prefs.read('offline_data');
        offlineData = OfflineData.fromJson(data);
        developer.log('Dados offline carregados com sucesso');
      }
    } catch (e) {
      developer.log('Erro ao carregar dados offline: $e');
    }
  }

  @action
  Future<void> saveOfflineBeneficiario(OfflineBeneficiarioFater beneficiario) async {
    try {
      offlineBeneficiarios.add(beneficiario);
      await _saveOfflineBeneficiarios();
      developer.log('Beneficiário offline salvo: ${beneficiario.id}');
    } catch (e) {
      developer.log('Erro ao salvar beneficiário offline: $e');
    }
  }

  @action
  Future<void> updateOfflineBeneficiario(OfflineBeneficiarioFater beneficiario) async {
    try {
      final index = offlineBeneficiarios.indexWhere((b) => b.id == beneficiario.id);
      if (index != -1) {
        offlineBeneficiarios[index] = beneficiario;
        await _saveOfflineBeneficiarios();
        developer.log('Beneficiário offline atualizado: ${beneficiario.id}');
      }
    } catch (e) {
      developer.log('Erro ao atualizar beneficiário offline: $e');
    }
  }

  @action
  Future<void> deleteOfflineBeneficiario(String id) async {
    try {
      offlineBeneficiarios.removeWhere((b) => b.id == id);
      await _saveOfflineBeneficiarios();
      developer.log('Beneficiário offline removido: $id');
    } catch (e) {
      developer.log('Erro ao remover beneficiário offline: $e');
    }
  }

  @action
  Future<void> loadOfflineBeneficiarios() async {
    try {
      if (await prefs.contem('offline_beneficiarios')) {
        final data = await prefs.read('offline_beneficiarios');
        if (data is List) {
          offlineBeneficiarios = data
              .map((item) => OfflineBeneficiarioFater.fromJson(item))
              .toList();
          developer.log('Beneficiários offline carregados: ${offlineBeneficiarios.length}');
        }
      }
    } catch (e) {
      developer.log('Erro ao carregar beneficiários offline: $e');
    }
  }

  Future<void> _saveOfflineBeneficiarios() async {
    try {
      final data = offlineBeneficiarios.map((b) => b.toJson()).toList();
      await prefs.save('offline_beneficiarios', data);
    } catch (e) {
      developer.log('Erro ao salvar beneficiários offline: $e');
    }
  }

  @action
  Future<void> syncOfflineData() async {
    if (!isOnline || offlineBeneficiarios.isEmpty) return;

    try {
      developer.log('Iniciando sincronização de ${pendingSyncCount} beneficiários...');
      
      // Aqui você implementaria a lógica para enviar os dados para o backend
      // Por enquanto, vamos apenas marcar como sincronizados
      for (var beneficiario in offlineBeneficiarios) {
        if (!beneficiario.isSynced) {
          // TODO: Implementar envio para o backend
          // await enviarParaBackend(beneficiario.data);
          
          // Marcar como sincronizado
          final updated = OfflineBeneficiarioFater(
            id: beneficiario.id,
            data: beneficiario.data,
            createdAt: beneficiario.createdAt,
            isSynced: true,
          );
          await updateOfflineBeneficiario(updated);
        }
      }
      
      developer.log('Sincronização concluída com sucesso');
    } catch (e) {
      developer.log('Erro durante sincronização: $e');
    }
  }

  void persistirDadosLogin() async {
    try {

      final loginSalvo = await prefs.save(
        SharedPrefs.loginResponseKey,
        loginResponse,
      );

      final usuarioSalvo = await prefs.save(
        SharedPrefs.dashboardResponseKey, 
        usuarioDados
        );

      if (!loginSalvo) {
        throw LoginNaoPersistidoException();
      }

      if (!usuarioSalvo) {
        throw Exception();
      }
    } on LoginNaoPersistidoException catch (e) {
      getEsigSnackBar(
        e.msg,
        context: OneContext().context,
        duracao: 3,
      );
      CrashlyticsHandler.reportException(
        e,
        key: 'app_store.dart',
        value: 'SharedPrefsError',
      );
    }
  }

   @action
  Future carregarDados() async {
    
    final isloginSalvo = await prefs.contem(SharedPrefs.loginResponseKey);
    final isUsuarioSalvo = await prefs.contem(SharedPrefs.dashboardResponseKey);
  
    loginResponse = isloginSalvo
        ? LoginResponse.fromJson(
            await prefs.read(SharedPrefs.loginResponseKey),
          )
        : null;

    usuarioDados = isUsuarioSalvo
        ? UsuarioDados.fromJson(
            await prefs.read(SharedPrefs.dashboardResponseKey),
          )
        : null;    

    // Carregar dados offline
    await loadOfflineData();
    await loadOfflineBeneficiarios();
    
    // Iniciar monitoramento de conectividade
    await startConnectivityMonitoring();
    await checkConnectivity();
    
    // Inicializar serviço de conectividade
    ConnectivityService().initialize(this as AppStore);
  }

  @action
  Future logout() async {
    final storedKeys = await prefs.getKeys();
    final removedKeys = <String, bool>{};

    for (var key in storedKeys) {
      removedKeys[key] = await prefs.remove(key);
    }
    developer.log('removedKeys: $removedKeys');

    loginResponse = null;
    usuarioDados = null;
    offlineData = null;
    offlineBeneficiarios.clear();
    //permissoes = null;
    Modular.to.pushReplacementNamed('/');
    return removedKeys;
  }

}
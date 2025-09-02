import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/app_store.dart';
import 'package:sisater_mobile/modules/offline/pages/offline_home_page.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  late AppStore _appStore;
  bool _isInitialized = false;
  String _currentRoute = '/';

  void initialize(AppStore appStore) {
    if (_isInitialized) return;
    
    _appStore = appStore;
    _isInitialized = true;
    
    // Iniciar monitoramento de conectividade
    _startConnectivityMonitoring();
    _startRouteMonitoring();
  }

  void _startConnectivityMonitoring() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      final isOnline = result != ConnectivityResult.none;
      
      if (_appStore.isOnline != isOnline) {
        _appStore.isOnline = isOnline;
        
        // Se ficou offline e não está na página offline, redirecionar
        if (!isOnline && !_isOnOfflinePage()) {
          _redirectToOffline();
        }
        
        // Se voltou a ficar online e está na página offline, voltar para home
        if (isOnline && _isOnOfflinePage()) {
          _redirectToHome();
        }
      }
    });
  }

  void _startRouteMonitoring() {
    // Monitorar mudanças de rota usando o Modular
    Modular.to.addListener(() {
      // Atualizar rota atual quando houver navegação
      _updateCurrentRoute();
    });
  }

  void _updateCurrentRoute() {
    try {
      // Como não podemos obter a rota atual diretamente, vamos usar uma abordagem diferente
      // Vamos confiar no updateCurrentRoute manual e no listener para detectar mudanças
      debugPrint('Route change detected, current route: $_currentRoute');
    } catch (e) {
      debugPrint('Error updating route: $e');
    }
  }

  bool _isOnOfflinePage() {
    return _currentRoute.startsWith('/offline');
  }

  void updateCurrentRoute(String route) {
    _currentRoute = route;
  }

  void _redirectToOffline() {
    // Verificar se já não está na página offline
    if (!_isOnOfflinePage()) {
      _currentRoute = '/offline';
      Modular.to.navigate('/offline');
    }
  }

  void _redirectToHome() {
    // Voltar para a página principal
    _currentRoute = '/home';
    Modular.to.popUntil((route) => route.isFirst);
  }

  Future<bool> checkConnectivity() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOnline = connectivityResult != ConnectivityResult.none;
      
      debugPrint('Connectivity check result: $connectivityResult, isOnline: $isOnline');
      
      if (_isInitialized) {
        _appStore.isOnline = isOnline;
      }
      
      return isOnline;
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      if (_isInitialized) {
        _appStore.isOnline = false;
      }
      return false;
    }
  }

  void showOfflineDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.red),
            SizedBox(width: 8),
            Text('Sem Conexão'),
          ],
        ),
        content: const Text(
          'Não foi possível conectar à internet. O app será redirecionado para o modo offline.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _redirectToOffline();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Method to manually trigger offline mode for testing
  void triggerOfflineMode() {
    if (_isInitialized) {
      _appStore.isOnline = false;
      _currentRoute = '/home';
      _redirectToOffline();
    }
  }
}

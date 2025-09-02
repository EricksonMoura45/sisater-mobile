import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/models/autenticacao/usuario_dados.dart';
import 'package:sisater_mobile/modules/app_store.dart';
import 'package:sisater_mobile/modules/autenticacao/autenticacao_controller.dart';
import 'package:sisater_mobile/modules/home/widgets/appbar_home.dart';
import 'package:sisater_mobile/modules/home/widgets/custom_drawer_widget.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/connectivity_service.dart';
import 'package:sisater_mobile/modules/fater/beneficiario_fater/beneficiario_fater_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AutenticacaoController autenticacaoController = Modular.get();
  UsuarioDados? usuarioDados = Modular.args.data;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    if(usuarioDados == null){
      autenticacaoController.carregaUsuario();
    }

    if(usuarioDados?.primeiroAcesso == true){
      Modular.to.pushNamed('/primeiro_acesso', arguments: usuarioDados);
    }

    // Carregar dados do beneficiario_fater para uso offline
    _carregarDadosOffline();
  }

  Future<void> _carregarDadosOffline() async {
    try {
      // Aguardar um pouco para garantir que o app store está inicializado
      await Future.delayed(const Duration(seconds: 2));
      
      // Obter o controller e carregar dados
      final controller = Modular.get<BeneficiarioFaterController>();
      if (controller != null) {
        await controller.carregaDadosPagina();
      }
    } catch (e) {
      // Log do erro mas não falhar
      debugPrint('Erro ao carregar dados offline: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    AppStore appStore = Modular.get();

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarhome(context),
      drawer: CustomDrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Parte fixa
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, ${usuarioDados?.name ?? 'Usuário'}',
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${usuarioDados?.officeName ?? 'Escritório'}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Selecione entre as opções abaixo:',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  // Test button for offline mode
                  if (appStore.isOnline)
                    ElevatedButton(
                      onPressed: () {
                        appStore.isOnline = false;
                        ConnectivityService().updateCurrentRoute('/home');
                        Modular.to.navigate('/offline');
                      },
                      child: const Text('Test Offline Mode'),
                    ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            // Parte rolável
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: _opcoesBotoes(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
        child: Text(
          appStore.appVersion,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _opcoesBotoes() {
    return Column(
      children: [
        _HomeMenuButton(
          icon: Icons.menu,
          label: 'Menu',
          onTap: (){
            _scaffoldKey.currentState?.openDrawer();
          }
        ),
        const SizedBox(height: 16),
        _HomeMenuButton(
          icon: Icons.chat_bubble_outline,
          label: 'Chat com Assistente',
          onTap: () => Modular.to.pushNamed('/atendimento'),
        ),
        const SizedBox(height: 16),
        _HomeMenuButton(
          icon: Icons.calendar_month,
          label: 'Agendamentos',
          onTap: () => Modular.to.pushNamed('/agendamentos'),
        ),
        const SizedBox(height: 16),
        _HomeMenuButton(
          icon: Icons.person_outline,
          label: 'Beneficiários de ATER',
          onTap: () => Modular.to.pushNamed('/beneficiarios_ater'),
        ),
        const SizedBox(height: 16),
        _HomeMenuButton(
          icon: Icons.groups_outlined,
          label: 'Org. Sociais de ATER',
          onTap: () => Modular.to.pushNamed('/organizacoes_ater'),
        ),
        const SizedBox(height: 16),
        _HomeMenuButton(
          icon: Icons.person_outline,
          label: 'FATER - Beneficiários',
          onTap: () => Modular.to.pushNamed('/beneficiarios_fater'),
        ),
        const SizedBox(height: 16),
        _HomeMenuButton(
          icon: Icons.groups_outlined,
          label: 'FATER - Org Sociais',
          onTap: () => Modular.to.pushNamed('/organizacoes_fater'),
        ),
        const SizedBox(height: 16),
        _HomeMenuButton(
          icon: Icons.location_city_outlined,
          label: 'Comunidades',
          onTap: () => Modular.to.pushNamed('/comunidades'),
        ),
        const SizedBox(height: 16),
        _HomeMenuButton(
          icon: Icons.set_meal_outlined,
          label: 'Atividade de Pesca',
          onTap: () => Modular.to.pushNamed('/atividade_de_pesca'),
        ),
        const SizedBox(height: 16),
        _HomeMenuButton(
          icon: Icons.agriculture_outlined,
          label: 'Unidades de Produção',
          onTap: () => Modular.to.pushNamed('/unidades_producao'),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _HomeMenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HomeMenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Themes.verdeBotao,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
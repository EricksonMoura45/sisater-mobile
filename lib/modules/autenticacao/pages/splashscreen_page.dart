import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/autenticacao/autenticacao_controller.dart';
import 'package:sisater_mobile/shared/utils/images.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  
  final AutenticacaoController _authController = Modular.get();

  @override
  void initState() {
    _authController.verificarDadoPersistidos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Cor de fundo clara
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E8), // Verde claro no topo
              Colors.white, // Branco no centro
              Colors.white, // Branco na parte inferior
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 
                          MediaQuery.of(context).padding.top - 
                          MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      // Espaçamento superior
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      
                      // Logo principal SISATER PAI D'ÉGUA
                      _buildMainLogo(),
                      
                      const SizedBox(height: 20),
                      
                      // Texto de boas-vindas
                      _buildWelcomeText(),
                      
                      const SizedBox(height: 30),
                      
                      // Botão de acesso
                      _buildAccessButton(context),
                      
                      const Spacer(),
                      const SizedBox(height: 20),
                      // Seção de realização
                      _buildRealizationSection(),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainLogo() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
         Image.asset(
                    Images.logo_paidegua,
                    height: MediaQuery.of(context).size.height * 0.20,
                    fit: BoxFit.contain,
                  ), // Logo oval com fundo verde escuro
         
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        const Text(
          'Bem-vindo ao app',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF666666),
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'SISATER PAI D\'ÉGUA',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildAccessButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: ElevatedButton(
        onPressed: () {
          Modular.to.pushReplacementNamed('/login_page');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Themes.verdeBotao, // Verde vibrante
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Acessar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward, size: 20, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildRealizationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 10),
          child: Text(
            'Realização:',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Logo EMATER-PARÁ
            Expanded(
              child: Column(
                children: [
                  Image.asset(
                    Images.logo_emater,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
            const SizedBox(width: 15),
            // Logo GOVERNO DO PARÁ
            Expanded(
              child: Column(
                children: [
                  Image.asset(
                    Images.logo_para,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 6),
                  
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Seção de Parceiros
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 10),
          child: Text(
            'Parceiros:',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Logo IPAM
            Expanded(
              child: Column(
                children: [
                  Image.asset(
                    Images.logo_ipam,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Instituto de Pesquisa\nAmbiental da Amazônia',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                    const SizedBox(height: 2),
                  
                ],
              ),
            ),
            const SizedBox(width: 15),
            // Logo Walmart Foundation
            Expanded(
              child: Column(
                children: [
                  Image.asset(
                    Images.logo_walmart,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Foundation',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF0066CC),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Seção de Desenvolvimento
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 10),
          child: Text(
            'Desenvolvimento:',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo getinfo
            Image.asset(
              Images.logo_getinfo,
              height: 50,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/models/autenticacao/usuario_dados.dart';
import 'package:sisater_mobile/modules/beneficiario_menu/beneficiario_controller.dart';
import 'package:sisater_mobile/modules/home/widgets/appbar_home.dart';
import 'package:sisater_mobile/modules/app_store.dart';
import 'package:sisater_mobile/shared/utils/images.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'dart:convert';
import 'dart:typed_data';

class BeneficiarioHomePage extends StatefulWidget {
  const BeneficiarioHomePage({super.key});

  @override
  State<BeneficiarioHomePage> createState() => _BeneficiarioHomePageState();
}

class _BeneficiarioHomePageState extends State<BeneficiarioHomePage> {
  BeneficiarioController beneficiarioController = Modular.get();
  UsuarioDados? usuarioDados = Modular.args.data;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarhome(context),
      drawer: _BeneficiarioDrawer(usuarioDados: usuarioDados),
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho fixo
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Logo ou ícone
                  Image.asset(Images.logo_paidegua, width: 120, height: 80),
                  const SizedBox(height: 24),
                  // Título de boas-vindas
                  Text(
                    'Olá, ${usuarioDados?.name ?? 'Beneficiário'}!',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Themes.pretoTexto,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Selecione entre as opções abaixo: ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Themes.cinzaTexto,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Botões roláveis
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Botões principais
                    _BeneficiarioMenuButton(
                      icon: Icons.calendar_today,
                      label: 'Meus agendamentos',
                      onTap: () {
                        Modular.to.pushNamed('/beneficiario/agendamentos_beneficiario');
                      },
                    ),
                    const SizedBox(height: 20),
                    _BeneficiarioMenuButton(
                      icon: Icons.chat_bubble_outline,
                      label: 'Atendimentos',
                      onTap: () {
                        Modular.to.pushNamed('/beneficiario/chat');
                      },
                    ),
                    const SizedBox(height: 20),

                    _BeneficiarioMenuButton(
                      icon: Icons.description,
                      label: 'Meu prontuário',
                      onTap: () {
                        Modular.to.pushNamed('/beneficiario/prontuario');
                      },
                    ),
                     const SizedBox(height: 20),
                    _BeneficiarioMenuButton(
                      icon: Icons.person,
                      label: 'Meu Perfil',
                      onTap: () {
                        Modular.to.pushNamed('/beneficiario/perfil');
                      },
                    ),
                    const SizedBox(height: 40),
                    // Informações adicionais
                    // Container(
                    //   padding: const EdgeInsets.all(16),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(12),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.black.withOpacity(0.05),
                    //         blurRadius: 10,
                    //         offset: const Offset(0, 2),
                    //       ),
                    //     ],
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         Icons.info_outline,
                    //         color: Themes.verdeBotao,
                    //         size: 24,
                    //       ),
                    //       const SizedBox(width: 12),
                    //       Expanded(
                    //         child: Text(
                    //           'Entre em contato com nosso assistente virtual para tirar suas dúvidas e receber orientações.',
                    //           style: TextStyle(
                    //             fontSize: 14,
                    //             color: Themes.cinzaTexto,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BeneficiarioDrawer extends StatelessWidget {
  final UsuarioDados? usuarioDados;
  
  const _BeneficiarioDrawer({this.usuarioDados});
  
  Widget _buildProfileImage() {
    if (usuarioDados?.foto != null && usuarioDados!.foto!.isNotEmpty) {
      String fotoData = usuarioDados!.foto!;
      
      // Verificar se é base64 com prefixo data:image
      if (fotoData.startsWith('data:image/')) {
        // Remover o prefixo data:image/png;base64, ou similar
        String base64Data = fotoData;
        if (fotoData.contains(';base64,')) {
          base64Data = fotoData.split(';base64,').last;
        }
        
        try {
          // Converter base64 para bytes
          final Uint8List imageBytes = Uint8List.fromList(base64Decode(base64Data));
          
          return Image.memory(
            imageBytes,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              );
            },
          );
        } catch (e) {
          return const Icon(
            Icons.person,
            size: 40,
            color: Colors.white,
          );
        }
      } else if (fotoData.startsWith('http://') || fotoData.startsWith('https://')) {
        // Se for uma URL completa
        return Image.network(
          fotoData,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            );
          },
        );
      } else {
        // Se não for base64 nem URL, pode ser um caminho relativo
        String fotoUrl = 'https://api.sisater.com.br/$fotoData';
        
        return Image.network(
          fotoUrl,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            );
          },
        );
      }
    } else {
      return const Icon(
        Icons.person,
        size: 40,
        color: Colors.white,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    AppStore appStore = Modular.get();
    
    return Drawer(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 10),
          // Cabeçalho do drawer
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                                 Container(
                   width: 80,
                   height: 80,
                   decoration: BoxDecoration(
                     color: Themes.verdeBotao,
                     shape: BoxShape.circle,
                   ),
                   child: ClipOval(
                     child: _buildProfileImage(),
                   ),
                 ),
                const SizedBox(height: 16),
                const Text(
                  'Área do Beneficiário',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sisater Mobile',
                  style: TextStyle(
                    fontSize: 14,
                    color: Themes.cinzaTexto,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // Opções do menu
          ListTile(
            title: const Text(
              'Meus agendamentos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            leading: Icon(
              Icons.calendar_today,
              color: Themes.verdeBotao,
            ),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              Modular.to.pushNamed('/beneficiario/agendamentos_beneficiario');
            },
          ),
          ListTile(
            title: const Text(
              'Atendimentos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            leading: Icon(
              Icons.chat_bubble_outline,
              color: Themes.verdeBotao,
            ),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              Modular.to.pushNamed('/beneficiario/chat');
            },
          ),
          ListTile(
            title: const Text(
              'Meu prontuário',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            leading: Icon(
              Icons.description,
              color: Themes.verdeBotao,
            ),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              Modular.to.pushNamed('/beneficiario/prontuario');
            },
          ),
          ListTile(
            title: const Text(
              'Meu Perfil',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            leading: Icon(
              Icons.person,
              color: Themes.verdeBotao,
            ),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              Modular.to.pushNamed('/beneficiario/perfil');
            },
          ),
          const Spacer(),
          const Divider(),
          // Opção de sair
          ListTile(
            title: const Text(
              'Sair',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: const Icon(
              Icons.exit_to_app_outlined, 
              color: Themes.vermelhoTexto,
            ),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              appStore.logout();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _BeneficiarioMenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BeneficiarioMenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Themes.verdeBotao,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 90, // Aumentando 50% a altura (era ~60px, agora 90px)
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Reduzindo padding para evitar overflow
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
            crossAxisAlignment: CrossAxisAlignment.center, // Centraliza horizontalmente
            children: [
              Icon(icon, color: Colors.white, size: 36), // Reduzindo o ícone para evitar overflow
              const SizedBox(height: 6), // Reduzindo espaçamento
              Flexible( // Adicionando Flexible para evitar overflow de texto
                child: Text(
                  label,
                  textAlign: TextAlign.center, // Centraliza o texto
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Reduzindo a fonte para evitar overflow
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis, // Adicionando ellipsis para texto longo
                  maxLines: 2, // Limitando a 2 linhas
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
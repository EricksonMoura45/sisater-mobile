import 'package:esig_utils/size_screen.dart';
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height/11),
              logoEmater(),
              SizedBox(height: 20),
              Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
              child: _botaoAcesso(context),
              ),
              textoApresentacao(),
              SizedBox(height: 5,),
              textoModalidades(),
              textoExplicativo(),
              textoExplicativoB(),
              SizedBox(height: 40,)
            ],
          ),
        ),
      ),
    );
  }

  Widget logoEmater(){
    return Image.asset(Images.logo_emater);
  }

  Widget textoApresentacao(){
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text
      ('Bem-vindos ao Sistema de Acompanhamento das Atividades de Assistência Técnica e Extensão Rural (SISATER-PARÁ), que é uma ferramenta de trabalho para cadastro dos beneficiários de ATER e registro de dados e informações, visando o planejamento, monitoramento e avaliação das atividades de ATER da empresa.\n\n É constituído por módulos específicos contendo informações sobre:',
      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
      textAlign: TextAlign.justify,
      ),
    );
  }

  Widget textoModalidades(){
    return  Text
    ('• Força de Trabalho\n• Beneficiários de ATER\n• Organizações Sociais\n• Comunidades\n• Unidades de Produção\n• Subprojetos do PROATER\n• Programação Mensal\n• Formulário de registro das atividades de ATER (FATER)\n• Crédito Rural\n',
    textAlign: TextAlign.left,
    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[900], fontSize: 16),
    );
  }

   Widget textoExplicativo(){
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
      ('O SISATER-PARÁ conta com um painel de informações que auxilia as pessoas dos diversos setores da empresa na coleta de dados para tomada de decisões. Foi desenvolvido para ambiente web, desktop e mobile, a ser utilizado nos escritórios locais, regionais, no escritório central e nos centros de treinamento, Pesquisa e Extensão da Empresa.'),
      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
      textAlign: TextAlign.justify,
      ),
    );
  }

  Widget textoExplicativoB(){
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
      ('O principal usuário é o Escritório Local, através dos técnicos de campo que deverão utilizar o SISATER-PARÁ como uma ferramenta de trabalho. Também farão uso do sistema os empregados e gestores lotados na DIREX, nas Coordenadorias e nos Escritórios Regionais que trabalham diretamente com assessoramento, monitoramento e avaliação das atividades de ATER.'),
      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
      textAlign: TextAlign.justify,
      ),
    );
  }

  

   Widget _botaoAcesso(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
        minWidth: SizeScreen.perWidth(context, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        colorBrightness: Brightness.dark,
        color: Themes.verdeBotao,
        onPressed: (){
          Modular.to.pushReplacementNamed('/login_page');
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ACESSAR',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 20,),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }
}
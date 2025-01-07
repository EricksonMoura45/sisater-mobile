import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/app_store.dart';
import 'package:sisater_mobile/modules/home/widgets/appbar_home.dart';
import 'package:sisater_mobile/modules/home/widgets/botao_menu.dart';
import 'package:sisater_mobile/modules/home/widgets/custom_drawer_widget.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    AppStore appStore = Modular.get();

    return Scaffold(
      appBar: appBarhome(context),
      drawer: CustomDrawerWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Olá, Usuário!', style: TextStyle(fontSize: 35),),
              Text('Sisater Mobile', style: TextStyle(fontSize: 20),),
              SizedBox(height: 40,),
              opcoesBotoes()
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
        child: Text(appStore.appVersion,
        textAlign: TextAlign.center, 
        style: TextStyle(fontWeight: FontWeight.bold),),
      ),
    );
  }

  Widget opcoesBotoes(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: BotaoMenu(
            tituloBotao: 'Beneficiários de ATER', 
            function: ()async {
            Modular.to.pushNamed('/beneficiarios_ater');
          }),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: BotaoMenu(tituloBotao: 'Org. Sociais de ATER', function: (){

          }),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: BotaoMenu(tituloBotao: 'FATER - Beneficiários', function: (){

          }),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: BotaoMenu(tituloBotao: 'Org. Sociais de FATER', function: (){

          }),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: BotaoMenu(tituloBotao: 'Unidade de Produção', function: (){

          }),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: BotaoMenu(tituloBotao: 'Atividade de Pesca', function: (){

          }),
        ),
      ],
    );
  }
}
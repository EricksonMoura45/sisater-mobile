import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:one_context/one_context.dart';
import 'package:sisater_mobile/modules/app_store.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
           SizedBox(height: MediaQuery.of(context).size.height / 10,),
          buildTextoTitulo(),    
          buildBeneficiariosAter(),
          buildBeneficiariosFater(),
          buildForcaTrabalho(),
          SizedBox(height: MediaQuery.of(context).size.height / 8,),
          buildSair()
        ],
      ),
    );
  }

  Widget buildTextoTitulo(){
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
        child: Text('Menu de opções:', style: TextStyle(fontSize: 20),),
      ));
  }

  Widget buildForcaTrabalho(){
    return ListTile(
        title: const Text(
          'Forca de Trabalho',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(Icons.work),
        onTap: () {
          //_fecharDrawer();
          //Modular.to.pushNamed('/elogios/');
        },
      );
  }

  Widget buildBeneficiariosAter(){
    return  ListTile(
        title: const Text(
          'Beneficiarios Ater',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(Icons.work),
        onTap: () {
          //_fecharDrawer();
          //Modular.to.pushNamed('/elogios/');
        },
      );
  }

  Widget buildBeneficiariosFater(){
    return  ListTile(
        title: const Text(
          'Forca de Trabalho',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(Icons.work),
        onTap: () {
          //_fecharDrawer();
          //Modular.to.pushNamed('/elogios/');
        },
      );
  }

  Widget buildSair(){
    AppStore appStore = Modular.get();
    return  ListTile(
        title: const Text(
          'Sair',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(Icons.exit_to_app_outlined, color: Themes.vermelhoTexto),
        onTap: () {
          appStore.logout();
        },
      );
  }

  // void _fecharDrawer() {
  //   if (Scaffold.of(context).isDrawerOpen) Scaffold.of(context).closeDrawer();
  // }
}

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/app_store.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/images.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 15,),
            buildLogo(),
            buildHeaderWithCloseButton(context),
            buildChatAssistente(),
            buildAgendamentos(),
            buildBeneficiariosAter(),
            buildorgAter(),
            buildBeneficiariosFater(),
            buildOrgFater(),
            buildComunidade(),
            buildatividadePesca(),
            buildUnidadeProducao(),
            SizedBox(height: 20),
            buildSair()
          ],
        ),
      ),
    );
  }

  Widget buildLogo() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        child: Image.asset(
          Images.logo_paidegua,
          height: 60,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget buildHeaderWithCloseButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Menu de opções:',
            style: TextStyle(fontSize: 14),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 24),
            onPressed: () {
              Navigator.of(context).pop();
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget buildBeneficiariosAter(){
    return  ListTile(
        title: const Text(
          'Beneficiários de ATER',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(Icons.person_outline, color: Themes.verdeBotao),
        onTap: () {
          Modular.to.pushNamed('/beneficiarios_ater');
        },
      );
  }

  Widget buildorgAter(){
    return  ListTile(
        title: const Text(
          'Org. Sociais de ATER',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(Icons.groups_outlined, color: Themes.verdeBotao),
        onTap: () {
          Modular.to.pushNamed('/organizacoes_ater');
        },
      );
  }
  
  Widget buildBeneficiariosFater(){
    return  ListTile(
        title: const Text(
          'FATER - Beneficiários',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(Icons.person_outline, color: Themes.verdeBotao),
        onTap: () {
          Modular.to.pushNamed('/beneficiarios_fater');
        },
      );
  }

  Widget buildOrgFater(){
    return  ListTile(
        title: const Text(
          'FATER - Org Sociais',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(Icons.groups_outlined, color: Themes.verdeBotao),
        onTap: () {
          Modular.to.pushNamed('/organizacoes_fater');
        },
      );
  }

  Widget buildComunidade(){
    return  ListTile(
        title: const Text(
          'Comunidades',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(Icons.location_city_outlined, color: Themes.verdeBotao),
        onTap: () {
          Modular.to.pushNamed('/comunidades');
        },
      );
  }

  Widget buildatividadePesca(){
    return  ListTile(
        title: const Text(
          'Atividades de Pesca',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(Icons.set_meal_outlined, color: Themes.verdeBotao),
        onTap: () {
          Modular.to.pushNamed('/atividade_pesca');
        },
      );
  }

  Widget buildUnidadeProducao(){
    return  ListTile(
        title: const Text(
          'Unidades de Produção',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(Icons.agriculture_outlined, color: Themes.verdeBotao),
        onTap: () {
          Modular.to.pushNamed('/unidades_producao');
        },
      );
  }

  Widget buildChatAssistente() {
    return ListTile(
      title: const Text(
        'Chat com Assistente',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: const Icon(Icons.chat_bubble_outline, color: Themes.verdeBotao),
      onTap: () {
        Modular.to.pushNamed('/atendimento');
      },
    );
  }

  Widget buildAgendamentos() {
    return ListTile(
      title: const Text(
        'Agendamentos',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: const Icon(Icons.calendar_month, color: Themes.verdeBotao),
      onTap: () {
        Modular.to.pushNamed('/agendamentos');
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

  Widget buildMenuOption({required IconData icon, required String label, required String route}) {
    return ListTile(
      leading: Icon(icon, color: Themes.verdeBotao),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Modular.to.pushNamed(route);
      },
    );
  }
}

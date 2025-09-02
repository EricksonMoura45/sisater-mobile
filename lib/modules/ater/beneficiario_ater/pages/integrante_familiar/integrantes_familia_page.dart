import 'package:esig_utils/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/beneficiario_ater_controller.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/widgets/familia_card_widget.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';

class IntegranteFamiliaPage extends StatefulWidget {
  const IntegranteFamiliaPage({super.key});

  @override
  State<IntegranteFamiliaPage> createState() => _IntegranteFamiliaPageState();
}

class _IntegranteFamiliaPageState extends State<IntegranteFamiliaPage> {

  BeneficiarioAterController controller = Modular.get();
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: formAppBar(context, 'Integrantes da Família', true, 'novo_integrantes_familia'),
      body: Observer(builder: (_){
        if(controller.statusFamiliaresBeneficiario == Status.ERRO){
          return Container(
        child: Center(
          child: Text('Não foram encontrados resultados.'),
        ),
      );
        }
        else if(controller.statusFamiliaresBeneficiario == Status.CONCLUIDO){
          if(controller.listaMembrosFamiliares.isEmpty){
            return Container(
        child: Center(
          child: Text('Não foram encontrados resultados.'),
        ),
      );
          } else{
          return ListView.builder(
            itemCount: controller.listaMembrosFamiliares.length,
            itemBuilder: (context, index){
              return FamiliaCardWidget(
                id: controller.listaMembrosFamiliares[index].id ?? 0,
                nome: controller.listaMembrosFamiliares[index].name ?? 'Não informado',	
                grauParentesco: controller.listaMembrosFamiliares[index].relatednessId ?? 1,
                sexo: controller.listaMembrosFamiliares[index].gender ?? 1,
                cpf: controller.listaMembrosFamiliares[index].document ?? 'Não informado',	
                dataNascimento: controller.listaMembrosFamiliares[index].birthDate ?? 'Não informado',
              );
            },
          );
          }
        }
        else {
           return Container(
        child: Center(
          child: Text('Não foram encontrados resultados.'),
        ));
        }
      })
    );
  }
  
}
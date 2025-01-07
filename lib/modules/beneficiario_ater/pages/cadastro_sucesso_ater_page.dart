import 'package:esig_utils/size_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/shared/utils/images.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';

class CadastroSucessoPage extends StatelessWidget {
  const CadastroSucessoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: _buildTexto(context)),
            SizedBox(height: MediaQuery.of(context).size.height / 4,),
            _buildBotoes(context),
      ],),
      );
  }

  Widget _buildTexto(BuildContext context){
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        SizedBox(height: MediaQuery.of(context).size.height / 5,),
        Image.asset(Images.logo_emater),  
        SizedBox(height: 20,),  
        Text('Registro do beneficiário concluído com sucesso!',
        textAlign: TextAlign.center, 
        maxLines: 5,
        style: TextStyle( fontSize: 30, fontWeight: FontWeight.bold),),
        SizedBox(height: 25,),
      ],),
    );
  }

   Widget _buildBotoes(BuildContext context) {
    return Column(
      children: [
        MaterialButton(
          padding: const EdgeInsets.all(17),
          minWidth: SizeScreen.perWidth(context, 90),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          colorBrightness: Brightness.dark,
          color: Themes.verdeBotao,
          onPressed: () async {
            //controller.clearStates();
            Modular.to.pushReplacementNamed('/beneficiarios_ater');
           }
          ,
          child: Text(
            'Concluir',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 15,),
      ],
    );
  }
}
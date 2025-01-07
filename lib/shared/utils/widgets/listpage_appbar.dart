import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';

PreferredSizeWidget? listPageAppBar(BuildContext context, String titulo){
   //final ColorScheme temaPadrao = Theme.of(context).colorScheme;
    return AppBar(
      shadowColor: Colors.white,
      leading: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Themes.verdeBotao,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.keyboard_arrow_left,
                      size: 32, color: Colors.white),
                ),
              ),
              onTap: () {
                Modular.to.pop();
              }
            ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTitulo(context, titulo),
          _buildAddBeneficiario()
        ],
      ),      
    );
  }

  Widget _buildTitulo(BuildContext context, String titulo) {
    return SizedBox(
      width: MediaQuery.of(context).size.width /2 ,
      child: Text(
        titulo,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildAddBeneficiario(){
    return  GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Themes.verdeBotao),
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.transparent,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.add,
                      size: 32, color: Themes.verdeBotao),
                ),
              ),
              onTap: () {
                Modular.to.pushNamed('/beneficiarios_ater/cadastro_ater');
              } ,
            );
  }


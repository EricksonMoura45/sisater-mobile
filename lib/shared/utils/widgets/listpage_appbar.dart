import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';

PreferredSizeWidget? listPageAppBar(BuildContext context, String titulo, int tipo){
   //final ColorScheme temaPadrao = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
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
          //_buildAddBeneficiario(tipo)
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
          fontSize: MediaQuery.of(context).size.width / 20,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildAddBeneficiario(int tipo){
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
                //inteiros para definir qual parte do código irá o cadastro
                if(tipo == 1){ //Benefiriários Ater
                  Modular.to.pushNamed('/beneficiarios_ater/cadastro_ater'); 
                }
                else if(tipo == 2){ 
                  Modular.to.pushNamed('/organizacoes_ater/cadastro_ater_organizacao'); 
                }
                else if(tipo == 3){ 
                  Modular.to.pushNamed('/beneficiarios_fater/cadastro_beneficiario_fater'); 
                }
                else if(tipo == 4){ 
                  Modular.to.pushNamed('/organizacoes_fater/cadastro_organizacao_fater'); 
                }
                else if(tipo == 5){ 
                  Modular.to.pushNamed('/comunidades/cadastrar_comunidade'); 
                }
                else if(tipo == 6){ 
                  Modular.to.pushNamed('/atividade_pesca/cadastrar_atividade_pesca'); 
                }
                else if(tipo == 7){ 
                  Modular.to.pushNamed('/atividade_pesca/cadastrar_atividade_pesca'); //UND PROD
                }

              } ,
            );
  }


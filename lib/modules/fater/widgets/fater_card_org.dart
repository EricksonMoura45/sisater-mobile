import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/models/organizacoes_fater/organizacao_fater_list.dart';
import 'package:sisater_mobile/modules/fater/organizacoes_fater/organizacoes_fater_controller.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';

class FaterCardOrg extends StatelessWidget {
   OrganizacaoFaterList organizacaoFaterList;

  FaterCardOrg({
    super.key,
    required this.organizacaoFaterList,
  });

  @override
  Widget build(BuildContext context) {
    OrganizacoesFaterController controller = Modular.get();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Themes.verdeBotao,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Themes.verdeBotao)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text('Organização', style: TextStyle(color: Colors.white),),
                      )),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                            
                            // Modular.to.pushNamed('editar_ater', arguments: beneficiarioAter);
      
                            // await controller.getBeneficiarioAter(beneficiarioAter.id!);    
                             
                            },
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.8),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.white)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child:Row(
                                      children: [
                                        Icon(Icons.edit, color: Colors.white,),
                                        // SizedBox(width: 2,),
                                        // Text('Editar', style: TextStyle(color: Colors.white),),
                                      ],
                                )
                              )),
                        ),
                      SizedBox(width: 5,),
                      
                      GestureDetector(
                        onTap: () async{
      
                          // exibirAlertDialog(context, beneficiarioAter);
      
                        },
                        child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Themes.vermelhoTexto,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.white)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Icon(Icons.highlight_remove_rounded, color: Colors.white,),
                              // SizedBox(width: 2,),
                              // Text('Apagar', style: TextStyle(color: Colors.white),),
                            ],
                          ),
                        )),
                      ),
                        ],
                      )
                  ],
                ),
                  SizedBox(height: 10,),
                Flexible(
                  child: Text(organizacaoFaterList.communities ?? 'Nome indisponível',
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  )),
                  SizedBox(height: 10,),
                Align(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Código'),
                            Text(organizacaoFaterList.code.toString() ?? 'Cpf indisponível', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                          ],
                        ),
                      ),
                      //SizedBox(width: MediaQuery.of(context).size.width / 10,),
                      Flexible(
                        child: Column(
                          children: [
                            Text('Ano'),
                            Text(organizacaoFaterList.year.toString() ?? '---', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),  
              ],
            ),
          ),
        ),
      ),
    );
  }

  void exibirAlertDialog(BuildContext context, OrganizacaoFaterList beneficiarioAter) {
    
  OrganizacoesFaterController controller = Modular.get();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: const EdgeInsets.all(16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Apagar Beneficiário?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            GestureDetector(
              child: Icon(Icons.close, color: Themes.vermelhoTexto, size: 30),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500, // Defina um tamanho máximo para o diálogo
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Garante que o diálogo só ocupe o espaço necessário
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(beneficiarioAter.communities ?? ''),
              Text(beneficiarioAter.code.toString() ?? ''),
              const SizedBox(height: 10),
              const Text(
                'Tem certeza que deseja apagar o Beneficiário?',
                textAlign: TextAlign.justify,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                child: MaterialButton(
                  padding: const EdgeInsets.all(17),
                  minWidth: MediaQuery.of(context).size.width,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  colorBrightness: Brightness.dark,
                  color: Themes.vermelhoTexto,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    //TODO await controller.deleteBeneficiarioAter(beneficiarioAter.id!);
                    controller.carregaOrganizacoes();
                  },
                  child: const Text(
                    'Sim, tenho certeza.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}
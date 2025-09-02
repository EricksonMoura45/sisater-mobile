import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/models/organizacoes_ater/organizacao_ater_list.dart';
import 'package:sisater_mobile/modules/ater/organizacoes_ater/organizacoes_ater_controller.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';

class OrganizacaoAterCard extends StatelessWidget {

  OrganizacaoAterCard({super.key, required this.organizacaoAter});

  OrganizacaoAterList organizacaoAter;

  OrganizacoesAterController controller = Modular.get();

  @override
  Widget build(BuildContext context) {
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height / 3.5,
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
                        child: Text('Organização Ater', style: TextStyle(color: Colors.white),),
                      )),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {

                            Modular.to.pushNamed('editar_ater_organizacao', arguments: organizacaoAter.id); 
                            await controller.carregaOrganizacao(organizacaoAter.id);
                               
                             
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
      
                          exibirAlertDialog(context, organizacaoAter);
      
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
                  child: Text(organizacaoAter.name ?? 'Nome indisponível',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  )),
                  SizedBox(height: 5,),
                Align(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('CNPJ', style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(organizacaoAter.document ?? 'CPNJ indisponível', style: TextStyle(fontSize: 14),),
                          ],
                        ),
                      ),
                      //SizedBox(width: MediaQuery.of(context).size.width / 10,),
                      organizacaoAter == null
                      ? SizedBox()
                      : Flexible(
                        child: Column(
                          children: [
                            Text('Telefone', style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(organizacaoAter.cellphone ??  '---', style: TextStyle(fontSize: 14),),
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

  void exibirAlertDialog(BuildContext context, OrganizacaoAterList organizacaoAter) {

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: const EdgeInsets.all(16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Apagar Organização?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
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
              Text(organizacaoAter.name ?? ''),
              Text(organizacaoAter.document ?? ''),
              const SizedBox(height: 10),
              const Text(
                'Tem certeza que deseja apagar a organização?',
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
                    
                     await controller.deleteOrganizacaoAter(organizacaoAter.id);
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
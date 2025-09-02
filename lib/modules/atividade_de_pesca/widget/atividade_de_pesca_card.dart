import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/models/atividade_de_pesca/atividade_pesca.dart';
import 'package:sisater_mobile/modules/atividade_de_pesca/atividade_de_pesca_controller.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';

class AtividadeDePescaCard extends StatelessWidget {

  final AtividadePesca atividadePesca;

  const AtividadeDePescaCard({super.key, required this.atividadePesca});

  @override
  Widget build(BuildContext context) {
    AtividadeDePescaController controller = Modular.get();
    if (atividadePesca.fisherman == null) {
      return const SizedBox();
    }
    else{
      return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                        child: Text('Nome da Embarcação', style: TextStyle(color: Colors.white),),
                      )),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async { 

                            Modular.to.pushNamed('editar_atividade_pesca', arguments: atividadePesca);    
                             
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
      
                          exibirAlertDialog(context, atividadePesca);
      
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
            Text(
              atividadePesca.fisherman?.currentVesselName ?? 'Sem nome',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Themes.verdeTexto,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cadastrado em: ${atividadePesca.created_at}' ?? 'Sem descrição',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            // Text(
            //   'Município: $nomeMunicipio',
            //   style: TextStyle(
            //     fontSize: 14,
            //     color: Colors.grey[600],
            //   ),
            // ),
          ],
        ),
      ),
    );
    }
    
  }

  void exibirAlertDialog(BuildContext context, AtividadePesca atividadePesca) {
  AtividadeDePescaController controller = Modular.get();

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
              Text(atividadePesca.fisherman?.currentVesselName ?? ''),
              //Text(comunidade.description ?? ''),
              const SizedBox(height: 10),
              const Text(
                'Tem certeza que deseja apagar essa atividade?',
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

                    await controller.deleteAtividadePesca(atividadePesca.id!);
                    controller.carregarAtividadesPesca();

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
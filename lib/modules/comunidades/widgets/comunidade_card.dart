import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/models/comunidades/comunidade_selecionavel.dart';
import 'package:sisater_mobile/models/comunidades/comunidades_list.dart';
import 'package:sisater_mobile/modules/comunidades/comunidades_controller.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';

class ComunidadeCard extends StatelessWidget {
  final ComunidadesList comunidade;

  const ComunidadeCard({
    super.key,
    required this.comunidade,
  });

  @override
  Widget build(BuildContext context) {

    ComunidadesController controller = Modular.get();

    String nomeMunicipio = controller.comunidadesSelecionaveis.firstWhere(
      (element) => element.code == comunidade.cityCode,
      orElse: () => ComunidadeSelecionavel(name: 'N/A'),
    ).name ?? 'N/A';

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
                        child: Text('Comunidade', style: TextStyle(color: Colors.white),),
                      )),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {

                            //await controller.carregaSubComunidades();
                            Modular.to.pushNamed('editar_comunidade', arguments: comunidade);
      
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
      
                          exibirAlertDialog(context, comunidade);
      
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
              comunidade.name ?? 'Sem nome',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Themes.verdeTexto,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              comunidade.description ?? 'Sem descrição',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Município: $nomeMunicipio',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void exibirAlertDialog(BuildContext context, ComunidadesList comunidade) {
  ComunidadesController controller = Modular.get();

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
              Text(comunidade.name ?? ''),
              Text(comunidade.description ?? ''),
              const SizedBox(height: 10),
              const Text(
                'Tem certeza que deseja apagar a comunidade?',
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
                    await controller.deleteComunidade(comunidade.id!);
                    controller.carregaComunidades();
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
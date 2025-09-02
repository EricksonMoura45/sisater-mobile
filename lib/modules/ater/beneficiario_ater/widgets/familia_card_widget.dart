import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/beneficiario_ater_controller.dart';
import 'package:sisater_mobile/shared/utils/Themes.dart';

class FamiliaCardWidget extends StatelessWidget {

  final String? nome;
  final int? id;
  final int? grauParentesco;
  final int? sexo;
  final String? cpf;
  final String? dataNascimento;

  const FamiliaCardWidget({
    required this.id,
    required this.nome,
    required this.grauParentesco,
    required this.sexo,
    required this.cpf,
    required this.dataNascimento,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    
     BeneficiarioAterController controller = Modular.get();

     String? grauParentescoTexto = controller.listaParentesco.firstWhere((element) => element.id == grauParentesco).name;
     String? sexoTexto = controller.listaSexo.firstWhere((element) => element.id == sexo).name;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
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
                      child: Text('Integrante Familiar', style: TextStyle(color: Colors.white),),
                    )),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
            
                          await controller.carregaFamiliarEdit(id!);   
            
                          await controller.preencheDadosFamiliarEdit();
                          
                          Modular.to.pushNamed('editar_integrantes_familia', arguments: id);
                           
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
                                    ],
                              )
                            )),
                      ),
                    SizedBox(width: 5,),
                    
                    GestureDetector(
                      onTap: () async{
            
                        exibirAlertDialog(context, id!, nome ?? 'Nome indisponível');
            
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
              SizedBox(height: 5,),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(nome ?? 'Nome indisponível',
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )),
                SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('CPF'),
                        SizedBox(height: 3,), 
                        Text(cpf ?? 'Cpf indisponível', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      ],
                    ),
                  ),
                  //SizedBox(width: MediaQuery.of(context).size.width / 10,),
                  Flexible(
                    child: Column(
                      children: [
                        Text('Grau de Parentesco'),
                        Text(grauParentescoTexto ?? '---', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Data de Nascimento'),
                        Text(dataNascimento ?? 'Cpf indisponível', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      ],
                    ),
                  ),
                  //SizedBox(width: MediaQuery.of(context).size.width / 10,),
                  Flexible(
                    child: Column(
                      children: [
                        Text('Sexo'),
                        Text(sexoTexto ?? '---', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      ],
                    ),
                  ),
                ],
              ),  
            ],
          ),
        ),
      ),
    );
  }

  void exibirAlertDialog(BuildContext context, int id, String nome) {
  BeneficiarioAterController controller = Modular.get();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: const EdgeInsets.all(16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Apagar Familiar?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            GestureDetector(
              child: Icon(Icons.close, color: Themes.vermelhoTexto, size: 30),
              onTap: () {
                Navigator.of(context).pop(); //
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
              Text(nome),
              const SizedBox(height: 10),
              const Text(
                'Tem certeza que deseja apagar o Familiar?',
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

                    await controller.deleteFamiliarAter(id);
                    await controller.carregaFamiliares(controller.beneficiarioAterEdit!.id!);

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

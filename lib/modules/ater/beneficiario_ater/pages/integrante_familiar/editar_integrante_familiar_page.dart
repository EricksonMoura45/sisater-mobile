import 'package:esig_utils/size_screen.dart';
import 'package:esig_utils/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/escolaridade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/sexo.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/membro_familiar/campos_selecionaveis/parentesco.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/membro_familiar/membro_familiar_put.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/beneficiario_ater_controller.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/widgets/build_input_field.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/date_picker.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appBar_familiar.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_mask.dart';

class EditarIntegranteFamiliarPage extends StatefulWidget {
  const EditarIntegranteFamiliarPage({super.key});

  @override
  State<EditarIntegranteFamiliarPage> createState() => _EditarIntegranteFamiliarPageState();
}

class _EditarIntegranteFamiliarPageState extends State<EditarIntegranteFamiliarPage> {

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController dataNascimentoController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  BeneficiarioAterController controller = Modular.get();

  @override
  void initState() {
    
    if(controller.membroFamiliarEdit != null){
      preencheDadosFamiliarEdit();
    }
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: formAppBarFamiliar(context, 'Editar Familiar', false, ''),
      body: Observer(
        builder: (_){
          if(controller.statusCarregaFamiliar == Status.AGUARDANDO){
            return Center(child: CircularProgressIndicator(color: Themes.verdeTexto,));
          }
          else if (controller.statusCarregaFamiliar == Status.ERRO){
            return Center(
              child: Text('Erro ao carregar os dados do familiar.'),
            );
          }
          else if (controller.statusCarregaFamiliar == Status.CONCLUIDO){
            return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: RefreshIndicator(
            onRefresh: () => controller.carregaFamiliares(controller.beneficiarioAterEdit!.id!),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 0, 2),
                    child: Text('Todos os campos com obrigatórios devem ser preenchidos.(*)', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  ),
                      
                  SizedBox(height: 20,),
                  
                  buildInputField(
                  label: 'Nome*',
                  controller: nomeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório.';
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Grau de Parentesco',
                    style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                      
                DropdownButtonFormField<Parentesco>(
                  hint: Text('Selecione entre as opções'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
                  ),
                  borderRadius: BorderRadius.circular(10),
                   key: const ValueKey('parentescoDropdown'),
                   isExpanded: true,
                   value: controller.parentescoSelecionado,
                  items: controller.listaParentesco.map(
                    (e) => DropdownMenuItem<Parentesco>(
                      value: e,
                      key: ValueKey(e.name),
                      child: Text(e.name),
                      )).toList(), 
                  onChanged: controller.changeParentescoSelecionada
                  ),
                 SizedBox(height: 10,),
            
                buildInputField(
                  label: 'CPF',
                  controller: cpfController,
                  formatters: [maskCpf],
              
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Sexo',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                DropdownButtonFormField<Sexo>(
                  hint: Text('Selecione entre as opções'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
                  ),
                  borderRadius: BorderRadius.circular(10),
                   key: const ValueKey('sexoDropdown'),
                   isExpanded: true,
                   value: controller.sexoFamiliarSelecionado,
                  items: controller.listaSexo.map(
                    (e) => DropdownMenuItem<Sexo>(
                      value: e,
                      key: ValueKey(e.name),
                      child: Text(e.name ?? 'Sem nome'),
                      )).toList(), 
                  onChanged: controller.changeSexoFamiliarSelecionada
                  ),
                 SizedBox(height: 10,),
              
                 Align(
                  alignment: Alignment.centerLeft,
                   child: Text('Escolaridade*',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                 ),
                DropdownButtonFormField<Escolaridade>(
                  hint: Text('Selecione entre as opções'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
                  ),
                  borderRadius: BorderRadius.circular(10),
                   key: const ValueKey('escolaridadeDropdown'),
                   isExpanded: true,
                   value: controller.escolaridadeFamiliarSelecionada,
                  items: controller.listaEscolaridade.map(
                    (e) => DropdownMenuItem<Escolaridade>(
                      value: e,
                      key: ValueKey(e.name),
                      child: Text(e.name ?? 'Sem nome'),
                      )).toList(), 
                  onChanged: controller.changeEscolaridadeFamiliarSelecionada
                  ),
                 SizedBox(height: 10,),
            
                 DatePickerWidget(label: 'Data de Nascimento*', formfield: 3),
                      
                  SizedBox(height: 20,),
                      
                ],
              ),
            ),
          ),
        ),
      );
          }
          else{
            return Center(
              child: Text('Erro ao carregar os dados do familiar.'),
            );
          }
        }
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: MaterialButton(
      padding: const EdgeInsets.all(17),
      minWidth: SizeScreen.perWidth(context, 90),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      colorBrightness: Brightness.dark,
      color: Themes.verdeBotao,
      onPressed: () async {

        if(nomeController.text.isEmpty){
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Atenção!'),
              content: const Text('Preencha o campo nome.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if(controller.escolaridadeFamiliarSelecionada == null){
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Atenção!'),
              content: const Text('Selecione a escolaridade.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if(controller.dataNascimentoFamiliarPicked == null){
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Atenção!'),
              content: const Text('Selecione a data de nascimento.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }

        if (formKey.currentState!.validate()) {
          FocusScope.of(context).unfocus();

          controller.putFamiliarAter(
            controller.membroFamiliarEdit!.id!,
            controller.beneficiarioAterEdit!.id!,
            MembroFamiliarPut(
              beneficiary_id: controller.beneficiarioAterEdit!.id!,
              name: nomeController.text,
              relatednessId: controller.parentescoSelecionado!.id,
              document: cpfController.text,
              gender: controller.sexoFamiliarSelecionado!.id!,
              scholarityId: controller.escolaridadeFamiliarSelecionada!.id!,
              birthDate: '${controller.dataNascimentoFamiliarPicked.year}-${controller.dataNascimentoFamiliarPicked.month}-${controller.dataNascimentoFamiliarPicked.day}'
            ),
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Observer(builder: (_){

            if(controller.putFamiliarStatus == Status.AGUARDANDO){
              return CircularProgressIndicator(
                color: Colors.white,
              );
            }
            else if(controller.putFamiliarStatus == Status.ERRO){
              return Text(
            'Editar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          );
            }
            else if(controller.putFamiliarStatus == Status.CONCLUIDO){
              return Text(
            'Editar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          );
            }
            else{
              return Text(
            'Editar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          );
            }
          },)
        ],
      ),
    )      
    ),
    );
    
  }

  void preencheDadosFamiliarEdit(){
    controller.preencheDadosFamiliarEdit();
    nomeController.text = controller.membroFamiliarEdit!.name!;
    cpfController.text = controller.membroFamiliarEdit!.document!; 
    controller.dataNascimentoFamiliarPicked = DateTime.parse(controller.membroFamiliarEdit!.birthDate!); 
  }
  
}

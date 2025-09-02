import 'package:esig_utils/size_screen.dart';
import 'package:esig_utils/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/models/comunidades/comunidade_selecionavel.dart';
import 'package:sisater_mobile/models/comunidades/tipo_acesso.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/widgets/build_input_field.dart';
import 'package:sisater_mobile/modules/comunidades/comunidades_controller.dart';
import 'package:sisater_mobile/models/comunidades/comunidades_list.dart';
import 'package:sisater_mobile/models/comunidades/comunidades_post.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';

class EditarComunidadePage extends StatefulWidget {
  
  ComunidadesList comunidade = Modular.args.data;

   EditarComunidadePage({super.key, required this.comunidade});

  @override
  State<EditarComunidadePage> createState() => _EditarComunidadePageState();
}

class _EditarComunidadePageState extends State<EditarComunidadePage> {

    @override
    void initState() {
      super.initState();
      nomeController.text = widget.comunidade.name ?? '';
      //distanciaController.text = widget.comunidade.distance.toString();
      descricaoController.text = widget.comunidade.description ?? '';

      controller.comunidadeSelecionada = 
        controller.comunidadesSelecionaveis.firstWhere(
          (element) => element.code == widget.comunidade.cityCode,
          orElse: () => controller.comunidadesSelecionaveis.first,
        );
      controller.tipoAcessoSelecionado = 
        controller.tipoAcesso.firstWhere(
          (element) => element.id == widget.comunidade.accessType,
          orElse: () => controller.tipoAcesso.first,
        );
      controller.unidadeMedidaSelecionado = controller.unidadeMedida.firstWhere(
          (element) => element == widget.comunidade.unit,
          orElse: () => controller.unidadeMedida.first,
        );

    }


    final TextEditingController nomeController = TextEditingController();
    final TextEditingController distanciaController = TextEditingController();
    final TextEditingController descricaoController = TextEditingController();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    
    ComunidadesController controller = Modular.get();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: formAppBar(context, 'Editar Comunidade', false, ''),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 0, 2),
                  child: Text('Todos os campos com obrigatórios devem ser preenchidos.(*)', 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                ),       
                SizedBox(height: 20,),
                buildFields(),  
              ],
            ),
          ),
        ),
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
        } else if(controller.comunidadeSelecionada == null){
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Atenção!'),
              content: const Text('Selecione o Municipio.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if(controller.unidadeMedidaSelecionado == null){
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Atenção!'),
              content: const Text('Selecione a unidade de medida.'),
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

          controller.putComunidade(
            ComunidadesPost(
              name: nomeController.text,
              cityCode: controller.comunidadeSelecionada?.code,
              accessType: controller.tipoAcessoSelecionado?.id,
              distance: distanciaController.text,
              unit: controller.unidadeMedidaSelecionado,
              description: descricaoController.text,
            ), widget.comunidade.id!
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Observer(builder: (_){

            if(controller.statusPostComunidades == Status.AGUARDANDO){
              return CircularProgressIndicator(
                color: Colors.white,
              );
            }
            else if(controller.statusPostComunidades == Status.ERRO){
              return Text(
            'Editar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          );
            }
            else if(controller.statusPostComunidades == Status.CONCLUIDO){
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
    )      ),
    );
  }

  Widget buildFields(){
    return Column(
      children: [
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
                'Município*',
                style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
            ),
                  
            DropdownButtonFormField<ComunidadeSelecionavel>(
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
               value: controller.comunidadeSelecionada,
              items: controller.comunidadesSelecionaveis.map(
                (e) => DropdownMenuItem<ComunidadeSelecionavel>(
                  value: e,
                  key: ValueKey(e.code),
                  child: Text(e.name ?? 'Sem nome'),
                  )).toList(), 
              onChanged: controller.changeComunidadeSelecionada
              ),
             SizedBox(height: 10,),

              Align(
              alignment: Alignment.centerLeft,
              child: Text('Tipo de Acesso',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            DropdownButtonFormField<TipoAcesso>(
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
               key: const ValueKey('tipoAcessodropdown'),
               isExpanded: true,
               value: controller.tipoAcessoSelecionado,
              items: controller.tipoAcesso.map(
                (e) => DropdownMenuItem<TipoAcesso>(
                  value: e,
                  key: ValueKey(e.id),
                  child: Text(e.descricao ?? 'Sem nome'),
                  )).toList(), 
              onChanged: controller.changeTipoAcessoSelecionada
              ),
             SizedBox(height: 10,),
        
            buildInputField(
              label: 'Distância entre Esloc e Comunidade*',
              controller: distanciaController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório.';
                }
                return null;
              },
            ),
          
             Align(
              alignment: Alignment.centerLeft,
               child: Text('Unidade de Medida*',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
             ),
            DropdownButtonFormField<String>(
              hint: Text('Selecione entre as opções'),
              validator:  (value) {
                if (value == null) {
                  return 'Campo obrigatório.';
                }
                return null;
              },
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
               key: const ValueKey('UnidMedDropdown'),
               isExpanded: true,
               value: controller.unidadeMedidaSelecionado,
              items: controller.unidadeMedida.map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  key: ValueKey(e),
                  child: Text(e),
                  )).toList(), 
              onChanged: controller.changeUnidadeMedSelecionada
              ),
             SizedBox(height: 10,),
             
             TextField(
              controller: descricaoController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
              ),
             ),
                  
             SizedBox(height: 20,),
      ],
    );
  }
}
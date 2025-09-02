import 'package:esig_utils/size_screen.dart';
import 'package:esig_utils/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/comunidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/produto.dart';
import 'package:sisater_mobile/models/comunidades/comunidade_selecionavel.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/eslocs.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/finalidade_atendimento.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/metodo_ater.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/politicas_publicas.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/tecnica_ater.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/tecnico_emater.dart';
import 'package:sisater_mobile/modules/fater/beneficiario_fater/beneficiario_fater_controller.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/date_picker_fater.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';
import 'package:sisater_mobile/shared/utils/widgets/input_widget.dart';

class EditarBeneficiarioFater extends StatefulWidget {
  const EditarBeneficiarioFater({super.key});

  @override
  State<EditarBeneficiarioFater> createState() => _EditarBeneficiarioFaterState();
}

class _EditarBeneficiarioFaterState extends State<EditarBeneficiarioFater> {
  final _formKey = GlobalKey<FormState>();

  final controller = Modular.get<BeneficiarioFaterController>();

  final TextEditingController instituicaoController = TextEditingController();
  final TextEditingController tecnicoInstituicaoController = TextEditingController();
  final TextEditingController resumoAtividadesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.carregaDadosPagina();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: formAppBar(context, 'Editar Beneficiários Fater', false, ''),
      body: Observer(
        builder: (_) {
          if (controller.statusCarregaDadosPagina == Status.AGUARDANDO) {
            return const Center(child: CircularProgressIndicator());
          }

          // if (controller.statusCarregaDadosPagina == Status.ERRO) {
          //   return Center(
          //     child: Text(
          //       controller.mensagemError,
          //       style: const TextStyle(color: Colors.red),
          //     ),
          //   );
          // }

          if (controller.statusCarregaDadosPagina == Status.ERRO) {
            return const Center(child: Text('Nenhum dado carregado.'));
          }


          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 0, 2),
              child: Text('Todos os campos com obrigatórios devem ser preenchidos.(*)', 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            ),
                  SizedBox(height: 20,),
                  DatePickerFaterWidget(label: 'Data de Nascimento*', formfield: 1),

                  Text('Município do atendimento*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
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
           key: const ValueKey('municipioFaterDropdown'),
           isExpanded: true,
           value: controller.municipioSelecionado,
           items: controller.listaMunicipios.map(
            (e) => DropdownMenuItem<ComunidadeSelecionavel>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeMunicipioSelecionado
          ),
          SizedBox(height: 10,),

          Text('Lotação(Eslocs)*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<Eslocs>(
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
           key: const ValueKey('municipioDropdown'),
           isExpanded: true,
           value: controller.eslocSelecionado,
           items: controller.listaEslocs.map(
            (e) => DropdownMenuItem<Eslocs>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeEslocSelecionado
          ),
          SizedBox(height: 10,),

          Text('Beneficiários*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<BeneficiarioAter>(
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
           key: const ValueKey('BeneficiarioAternoFaterDropdown'),
           isExpanded: true,
           value: controller.beneficiarioAterSelecionado,
           items: controller.listaBeneficiariosAter.map(
            (e) => DropdownMenuItem<BeneficiarioAter>(
              value: e,
              key: ValueKey(e.id),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeBeneficiarioAterSelecionado
          ),
          SizedBox(height: 10,),
          controller.listaBeneficiariosAterSelecionados.isEmpty ? 
          SizedBox()
          : Container(
            decoration: BoxDecoration(
              border: Border.all(color: Themes.verdeBotao, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: controller.listaBeneficiariosAterSelecionados
                    .map((item) => Chip(
                          label: Text(item.name ?? ''),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              controller.listaBeneficiariosAterSelecionados.remove(item);
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
          ),

          Observer(builder: (_){

          if(controller.statusCarregaComunidades == Status.AGUARDANDO){
              return Center(child: CircularProgressIndicator(color: Themes.verdeBotao,),);
          }
          if(controller.statusCarregaComunidades == Status.CONCLUIDO){
           return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Comunidade ou Local de Atendimento *',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<Comunidade>(
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
           key: const ValueKey('comunidadeDropdown'),
           isExpanded: true,
           value: controller.comunidadeSelecionada,
          items: controller.listaComunidades.map(
            (e) => DropdownMenuItem<Comunidade>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeComunidadeSelecionada
          ),
          SizedBox(height: 10,),
            ],
           ); 
         }
         else{
           return SizedBox();
         }}),

         Text('Finalidades do Atendimento*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<FinalidadeAtendimento>(
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
           key: const ValueKey('finalidadeDropdown'),
           isExpanded: true,
           value: controller.finalidadeAtendimentoSelecionada,
           items: controller.listaFinalidadeAtendimento.map(
            (e) => DropdownMenuItem<FinalidadeAtendimento>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeFinalidadeAtendimentoSelecionada
          ),
          SizedBox(height: 10,),

          controller.listaFinalidadeAtendimentoSelecionados.isEmpty ? 
          SizedBox()
          : Container(
            decoration: BoxDecoration(
              border: Border.all(color: Themes.verdeBotao, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: controller.listaFinalidadeAtendimentoSelecionados
                    .map((item) => Chip(
                          label: Text(item.name ?? ''),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              controller.listaFinalidadeAtendimentoSelecionados.remove(item);
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
          ),

          Text('Cadeias produtivas relacionadas ao atendimento',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<Produto>(
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
           key: const ValueKey('cadeiaProdDropdown'),
           isExpanded: true,
           value: controller.produtoSelecionado,
           items: controller.listaProdutos.map(
            (e) => DropdownMenuItem<Produto>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeProdutoSelecionado
          ),
          SizedBox(height: 10,),

          controller.listaProdutosSelecionados.isEmpty ? 
          SizedBox()
          : Container(
            decoration: BoxDecoration(
              border: Border.all(color: Themes.verdeBotao, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: controller.listaProdutosSelecionados
                    .map((item) => Chip(
                          label: Text(item.name ?? ''),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              controller.listaProdutosSelecionados.remove(item);
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
          ),

          Text('Método de ATER*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<MetodoAter>(
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
           key: const ValueKey('metodoDropdown'),
           isExpanded: true,
           value: controller.metodoSelecionado,
           items: controller.listaMetodos.map(
            (e) => DropdownMenuItem<MetodoAter>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeMetodoSelecionado
          ),
          SizedBox(height: 10,),

           Text('Técnicas de ATER',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<TecnicaAter>(
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
           key: const ValueKey('tecDropdown'),
           isExpanded: true,
           value: controller.tecnicaSelecionada,
           items: controller.listaTecnica.map(
            (e) => DropdownMenuItem<TecnicaAter>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeTecnicaSelecionada
          ),
          SizedBox(height: 10,),

          controller.listaTecnicasSelecionadas.isEmpty ? 
          SizedBox()
          : Container(
            decoration: BoxDecoration(
              border: Border.all(color: Themes.verdeBotao, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: controller.listaTecnicasSelecionadas
                    .map((item) => Chip(
                          label: Text(item.name ?? ''),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              controller.listaTecnicasSelecionadas.remove(item);
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
          ),

          Text('Política(s) pública(s) relacionada(s) ao atendimento',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<PoliticasPublicas>(
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
           key: const ValueKey('PPDropdown'),
           isExpanded: true,
           value: controller.politicaSelecionada,
           items: controller.listaPoliticas.map(
            (e) => DropdownMenuItem<PoliticasPublicas>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changePoliticaSelecionada
          ),
          SizedBox(height: 10,),

          controller.listaPoliticasSelecionadas.isEmpty ? 
          SizedBox()
          : Container(
            decoration: BoxDecoration(
              border: Border.all(color: Themes.verdeBotao, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: controller.listaPoliticasSelecionadas
                    .map((item) => Chip(
                          label: Text(item.name ?? ''),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              controller.listaPoliticasSelecionadas.remove(item);
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
          ),

          buildInputField(label: 'Instituição parceira', controller: instituicaoController),

          buildInputField(
            label: 'Técnico(a) da instituição parceira',
            controller: tecnicoInstituicaoController,
          ),

          Text('Técnicos da EMATER envolvidos nos atendimentos*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<TecnicoEmater>(
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
           key: const ValueKey('TecEmDropdown'),
           isExpanded: true,
           value: controller.tecnicoEmaterSelecionado,
           items: controller.listaTecnicoEmater.map(
            (e) => DropdownMenuItem<TecnicoEmater>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeTecnicoEmaterSelecionado
          ),
          SizedBox(height: 10,),

          controller.listaTecnicosEmaterSelecionados.isEmpty ? 
          SizedBox()
          : Container(
            decoration: BoxDecoration(
              border: Border.all(color: Themes.verdeBotao, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: controller.listaTecnicosEmaterSelecionados
                    .map((item) => Chip(
                          label: Text(item.name ?? ''),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              controller.listaTecnicosEmaterSelecionados.remove(item);
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
          SizedBox(height: 20,),
          TextField(
              controller: resumoAtividadesController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Resumo das Atividades',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
              ),
             ),
         

        //TODO carrega beneficiarios




                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
        child: Observer(builder: (_){
           if(controller.statusCarregaDadosPagina == Status.CONCLUIDO){
            return 
              botaoCadastrar(context);
           }
            else{
              return SizedBox();
            }
        }) 
      ),
    );
  }

  Widget buildInputField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    
    List<TextInputFormatter>? formatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          InputWidget(
            controller: controller,
            formatters: formatters,
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget botaoCadastrar(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.all(17),
      minWidth: SizeScreen.perWidth(context, 90),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      colorBrightness: Brightness.dark,
      color: Themes.verdeBotao,
      onPressed: () async {
        //verificaCamposObrigatorios();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Observer(builder: (_){

            if(controller.cadastraBeneficiarioStatus == Status.AGUARDANDO){
              return CircularProgressIndicator(
                color: Colors.white,
              );
            }
            else if(controller.cadastraBeneficiarioStatus == Status.ERRO){
              return Text(
            'Cadastrar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          );
            }
            else{
              return Text(
            'Cadastrar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          );
            }
          },)
        ],
      ),
    );
  }
}
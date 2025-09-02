import 'package:esig_utils/size_screen.dart';
import 'package:esig_utils/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/models/organizacoes_fater/organizacao_fater_list.dart';
import 'package:sisater_mobile/models/comunidades/comunidade_selecionavel.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/eslocs.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/date_picker_fater.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';
import 'package:sisater_mobile/modules/fater/organizacoes_fater/organizacoes_fater_controller.dart';
import 'package:sisater_mobile/shared/utils/widgets/input_widget.dart';

class CadastrarOrganizacaoFaterPage extends StatefulWidget {
  const CadastrarOrganizacaoFaterPage({super.key});

  @override
  State<CadastrarOrganizacaoFaterPage> createState() => _CadastrarOrganizacaoFaterPageState();
}

class _CadastrarOrganizacaoFaterPageState extends State<CadastrarOrganizacaoFaterPage> {
  
  final _formKey = GlobalKey<FormState>();

  final controller = Modular.get<OrganizacoesFaterController>();

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
      appBar: formAppBar(context, 'Cadastrar Organização Fater', false, ''),
      body: Observer(
        builder: (_) {
          if (controller.statusCarregaDadosPagina == Status.AGUARDANDO) {
            return const Center(child: CircularProgressIndicator());
          }

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
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 20,),
                  DatePickerFaterWidget(label: 'Data de Fundação*', formfield: 1),

                  Text('Município do atendimento*',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  DropdownButtonFormField<ComunidadeSelecionavel>(
                    hint: Text('Selecione entre as opções'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
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
                      )
                    ).toList(), 
                    onChanged: controller.changeMunicipioSelecionado
                  ),
                  SizedBox(height: 10,),

                  Text('Lotação(Eslocs)*',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  DropdownButtonFormField<Eslocs>(
                    hint: Text('Selecione entre as opções'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
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
                      )
                    ).toList(), 
                    onChanged: controller.changeEslocSelecionado
                  ),
                  SizedBox(height: 10,),

                  Text('Organizações*',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  DropdownButtonFormField<OrganizacaoFaterList>(
                    hint: Text('Selecione entre as opções'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    key: const ValueKey('OrganizacaoFaterDropdown'),
                    isExpanded: true,
                    value: controller.organizacaoFaterSelecionada,
                    items: controller.listaOrganizacoes.map(
                      (e) => DropdownMenuItem<OrganizacaoFaterList>(
                        value: e,
                        key: ValueKey(e.id),
                        child: Text(e.communities ?? 'Sem nome'),
                      )
                    ).toList(), 
                    onChanged: controller.changeOrganizacaoFaterSelecionada
                  ),
                  SizedBox(height: 10,),
                  controller.listaOrganizacoesAterSelecionadas.isEmpty ? 
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
                        children: controller.listaOrganizacoesAterSelecionadas
                            .map((item) => Chip(
                                  label: Text(item.communities ?? ''),
                                  deleteIcon: Icon(Icons.close),
                                  onDeleted: () {
                                    setState(() {
                                      controller.listaOrganizacoesAterSelecionadas.remove(item);
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                  ),

                  // Repita o padrão acima para os demais campos, adaptando para organização

                  buildInputField(label: 'Instituição parceira', controller: instituicaoController),

                  buildInputField(
                    label: 'Técnico(a) da instituição parceira',
                    controller: tecnicoInstituicaoController,
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
            return botaoCadastrar(context);
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

            if(controller.cadastraOrganizacaoStatus == Status.AGUARDANDO){
              return CircularProgressIndicator(
                color: Colors.white,
              );
            }
            else if(controller.cadastraOrganizacaoStatus == Status.ERRO){
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
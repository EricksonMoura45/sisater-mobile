import 'package:esig_utils/size_screen.dart';
import 'package:esig_utils/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/models/beneficiario_fater/proater.dart';
import 'package:sisater_mobile/models/beneficiario_fater/insumo.dart';
import 'package:sisater_mobile/models/beneficiario_fater/atividade.dart';
import 'package:sisater_mobile/models/beneficiario_fater/foto.dart';
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
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/unidade_medida.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/date_picker_fater.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';
import 'package:sisater_mobile/modules/fater/beneficiario_fater/beneficiario_fater_controller.dart';
import 'package:sisater_mobile/shared/utils/widgets/input_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:sisater_mobile/modules/app_store.dart';

class CadastrarBeneficiarioFaterPage extends StatefulWidget {
  const CadastrarBeneficiarioFaterPage({super.key});

  @override
  State<CadastrarBeneficiarioFaterPage> createState() => _CadastrarBeneficiarioFaterPageState();
}

class _CadastrarBeneficiarioFaterPageState extends State<CadastrarBeneficiarioFaterPage> {
  
  final _formKey = GlobalKey<FormState>();

  final controller = Modular.get<BeneficiarioFaterController>();

  final TextEditingController instituicaoController = TextEditingController();
  final TextEditingController tecnicoInstituicaoController = TextEditingController();
  final TextEditingController resumoAtividadesController = TextEditingController();
  
  // Controllers para o modal de insumos
  final TextEditingController insumoController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();

  // Controllers para o modal de atividades
  final TextEditingController situacaoController = TextEditingController();
  final TextEditingController recomendacoesController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    controller.carregaDadosPagina();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    controller.setCameraPermission(true);
    controller.setStoragePermission(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: formAppBar(context, 'Cadastrar Beneficiários Fater', false, ''),
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
                  DatePickerFaterWidget(label: 'Data de Atendimento*', formfield: 1),

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
          SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              _showBeneficiariosSelectionModal(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.listaBeneficiariosAterSelecionados.isEmpty
                          ? 'Selecione os beneficiários'
                          : '${controller.listaBeneficiariosAterSelecionados.length} beneficiário(s) selecionado(s)',
                      style: TextStyle(
                        color: controller.listaBeneficiariosAterSelecionados.isEmpty
                            ? Colors.grey.shade600
                            : Colors.black,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
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

           Text('Subprojetos PROATER',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<Proater>(
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
           key: const ValueKey('ProaterDropdown'),
           isExpanded: true,
           value: controller.proaterSelecionado,
           items: controller.listaProater.map(
            (e) => DropdownMenuItem<Proater>(
              value: e,
              key: ValueKey(e.proaterName?.id),
              child: Text(e.proaterName?.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeProaterSelecionada
          ),
          SizedBox(height: 10,),

          controller.listaProaterNamed.isEmpty ? 
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
                children: controller.listaProaterNamed
                    .map((item) => Chip(
                          label: Text(item.proaterName?.name ?? ''),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              controller.listaProaterNamed.remove(item);
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
          SizedBox(height: 10,),  
          Text('Insumo(s)',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),

          // Botão para adicionar insumo
          MaterialButton(
            padding: const EdgeInsets.all(15),
            minWidth: double.infinity,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Themes.verdeBotao,
            onPressed: () {
              _showAdicionarInsumoDialog(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Adicionar Insumo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // Lista de insumos adicionados
          Observer(builder: (_) {
            if (controller.listaInsumos.isEmpty) {
              return SizedBox();
            }
            return Container(
              child: Column(
                children: [
                  // Cabeçalho da tabela
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Insumo',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Qtd',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Unidade de Medida',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Ações',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Lista de insumos
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: controller.listaInsumos.asMap().entries.map((entry) {
                        int index = entry.key;
                        Insumo insumo = entry.value;
                        return Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: index < controller.listaInsumos.length - 1 
                                ? BorderSide(color: Colors.grey.shade200) 
                                : BorderSide.none,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  insumo.insumo ?? '',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  insumo.quantidade?.toStringAsFixed(0) ?? '0',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  insumo.unidadeMedida ?? '',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.delete, color: Colors.white, size: 18),
                                      onPressed: () {
                                        controller.removerInsumo(index);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }),

          SizedBox(height: 20),

          // Seção de Atividades e Assuntos Abordados
          Text('Atividades e Assuntos Abordados',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),

          // Botão para adicionar atividade
          MaterialButton(
            padding: const EdgeInsets.all(15),
            minWidth: double.infinity,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Themes.verdeBotao,
            onPressed: () {
              _showAdicionarAtividadeDialog(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Adicionar Atividade',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // Lista de atividades adicionadas
          Observer(builder: (_) {
            if (controller.listaAtividades.isEmpty) {
              return SizedBox();
            }
            return Container(
              child: Column(
                children: [
                  // Cabeçalho da tabela
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Produto',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Situação',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Recomendações',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Ações',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Lista de atividades
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: controller.listaAtividades.asMap().entries.map((entry) {
                        int index = entry.key;
                        Atividade atividade = entry.value;
                        return Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: index < controller.listaAtividades.length - 1 
                                ? BorderSide(color: Colors.grey.shade200) 
                                : BorderSide.none,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  atividade.produto ?? '',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  atividade.situacao ?? '',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  atividade.recomendacoes ?? '',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.delete, color: Colors.white, size: 18),
                                      onPressed: () {
                                        controller.removerAtividade(index);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }),

          SizedBox(height: 20),

          // Seção de Fotos
          Text('Fotos',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),

          // Verificar permissões
          Observer(builder: (_) {
            if (!controller.cameraPermissionGranted || !controller.storagePermissionGranted) {
              return Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'É necessário habilitar o acesso à câmera e/ou galeria para adicionar fotos.',
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Botão para adicionar foto
                MaterialButton(
                  padding: const EdgeInsets.all(15),
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Themes.verdeBotao,
                  onPressed: () {
                    _showAdicionarFotoDialog(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Adicionar Foto',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // Lista de fotos adicionadas
                Observer(builder: (_) {
                  if (controller.listaFotos.isEmpty) {
                    return SizedBox();
                  }
                  return Container(
                    child: Column(
                      children: [
                        // Grid de fotos
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                          itemCount: controller.listaFotos.length,
                          itemBuilder: (context, index) {
                            final foto = controller.listaFotos[index];
                            return Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(foto.caminho ?? ''),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey.shade200,
                                          child: Icon(Icons.image, color: Colors.grey),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                // Checkmark no canto inferior direito
                                Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                // Botão de remover no canto superior direito
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.removerFoto(index);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          }),

          SizedBox(height: 20),

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

  void _showAdicionarInsumoDialog(BuildContext context) {
    UnidadeMedida? unidadeMedidaSelecionada;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Adicionar Insumo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 20),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Campo Insumo
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Insumo',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        TextField(
                          controller: insumoController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    
                    // Campos Quantidade e Unidade de Medida lado a lado
                    Row(
                      children: [
                        // Campo Quantidade
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quantidade',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              TextField(
                                controller: quantidadeController,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        
                        // Campo Unidade de Medida
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Unidade',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Observer(builder: (_) {
                                if (controller.statusCarregaUnidadeMedida == Status.AGUARDANDO) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                  );
                                }
                                
                                return DropdownButtonFormField<UnidadeMedida>(
                                  hint: Text('Selecione', style: TextStyle(fontSize: 13)),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  ),
                                  value: unidadeMedidaSelecionada,
                                  items: controller.listaUnidadeMedida.map((e) => 
                                    DropdownMenuItem<UnidadeMedida>(
                                      value: e,
                                      child: Text(e.name ?? '', style: TextStyle(fontSize: 13)),
                                    )
                                  ).toList(),
                                  onChanged: (UnidadeMedida? value) {
                                    setState(() {
                                      unidadeMedidaSelecionada = value;
                                    });
                                  },
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    padding: EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    color: Themes.verdeBotao,
                    onPressed: () {
                      if (insumoController.text.isNotEmpty && 
                          quantidadeController.text.isNotEmpty && 
                          unidadeMedidaSelecionada != null) {
                        
                        double? quantidade = double.tryParse(quantidadeController.text);
                        
                        Insumo novoInsumo = Insumo(
                          insumo: insumoController.text,
                          quantidade: quantidade,
                          unidadeMedida: unidadeMedidaSelecionada!.name,
                        );
                        
                        controller.adicionarInsumo(novoInsumo);
                        
                        // Limpar os campos
                        insumoController.clear();
                        quantidadeController.clear();
                        
                        Navigator.of(context).pop();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Adicionar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAdicionarAtividadeDialog(BuildContext context) {
    Produto? produtoSelecionado;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Adicionar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 20),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Campo Produto
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Produto',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Observer(builder: (_) {
                          if (controller.statusCarregaProdutos == Status.AGUARDANDO) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            );
                          }
                          
                          return DropdownButtonFormField<Produto>(
                            hint: Text('Selecione o produto', style: TextStyle(fontSize: 13)),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            ),
                            value: produtoSelecionado,
                            items: controller.listaProdutos.map((e) => 
                              DropdownMenuItem<Produto>(
                                value: e,
                                child: Text(e.name ?? '', style: TextStyle(fontSize: 13)),
                              )
                            ).toList(),
                            onChanged: (Produto? value) {
                              setState(() {
                                produtoSelecionado = value;
                              });
                            },
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 12),
                    
                    // Campo Situação
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Situação',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        TextField(
                          controller: situacaoController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    
                    // Campo Recomendações
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recomendações',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        TextField(
                          controller: recomendacoesController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    padding: EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    color: Themes.verdeBotao,
                    onPressed: () {
                      if (produtoSelecionado != null &&
                          situacaoController.text.isNotEmpty &&
                          recomendacoesController.text.isNotEmpty) {
                        
                        Atividade novaAtividade = Atividade(
                          produto: produtoSelecionado!.name,
                          situacao: situacaoController.text,
                          recomendacoes: recomendacoesController.text,
                        );
                        
                        controller.adicionarAtividade(novaAtividade);
                        
                        // Limpar os campos
                        situacaoController.clear();
                        recomendacoesController.clear();
                        
                        Navigator.of(context).pop();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Adicionar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAdicionarFotoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Adicionar Foto',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                // Opção Câmera
                MaterialButton(
                  padding: EdgeInsets.all(12),
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  color: Themes.verdeBotao,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _pickImageFromCamera();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Câmera',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // Opção Galeria
                MaterialButton(
                  padding: EdgeInsets.all(12),
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  color: Themes.verdeBotao,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _pickImageFromGallery();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_library, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Galeria',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAdicionarMetaDialog(BuildContext context) {
    final metaController = TextEditingController();
    final valorController = TextEditingController();
    UnidadeMedida? unidadeMedidaSelecionada;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Adicionar Meta',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 20),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Campo Meta/Descrição
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Descrição',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        TextField(
                          controller: metaController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    
                    // Campos Valor e Unidade de Medida lado a lado
                    Row(
                      children: [
                        // Campo Valor
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Valor',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              TextField(
                                controller: valorController,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        
                        // Campo Unidade de Medida
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Unidade',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Observer(builder: (_) {
                                if (controller.statusCarregaUnidadeMedida == Status.AGUARDANDO) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                  );
                                }
                                
                                return DropdownButtonFormField<UnidadeMedida>(
                                  hint: Text('Selecione', style: TextStyle(fontSize: 13)),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  ),
                                  value: unidadeMedidaSelecionada,
                                  items: controller.listaUnidadeMedida.map((e) => 
                                    DropdownMenuItem<UnidadeMedida>(
                                      value: e,
                                      child: Text(e.name ?? '', style: TextStyle(fontSize: 13)),
                                    )
                                  ).toList(),
                                  onChanged: (UnidadeMedida? value) {
                                    setState(() {
                                      unidadeMedidaSelecionada = value;
                                    });
                                  },
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    padding: EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    color: Themes.verdeBotao,
                    onPressed: () {
                      if (metaController.text.isNotEmpty && 
                          valorController.text.isNotEmpty && 
                          unidadeMedidaSelecionada != null) {
                        
                        double? valor = double.tryParse(valorController.text);
                        
                        Map<String, dynamic> novaMeta = {
                          'name': metaController.text,
                          'amount': valor,
                          'unit_of_measure_id': unidadeMedidaSelecionada!.id,
                          'unit_name': unidadeMedidaSelecionada!.name,
                        };
                        
                        controller.adicionarMeta(novaMeta);
                        
                        // Limpar os campos
                        metaController.clear();
                        valorController.clear();
                        
                        Navigator.of(context).pop();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Adicionar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (image != null) {
        final foto = Foto(
          caminho: image.path,
          nome: image.name,
          dataAdicao: DateTime.now(),
        );
        controller.adicionarFoto(foto);
      }
    } catch (e) {
      // Tratar erro silenciosamente
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        final foto = Foto(
          caminho: image.path,
          nome: image.name,
          dataAdicao: DateTime.now(),
        );
        controller.adicionarFoto(foto);
      }
    } catch (e) {
      // Tratar erro silenciosamente
    }
  }

  void _showBeneficiariosSelectionModal(BuildContext context) {
    final searchController = TextEditingController();
    final Set<BeneficiarioAter> selectedBeneficiarios = Set.from(controller.listaBeneficiariosAterSelecionados);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Selecionar Beneficiários',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Pesquisar beneficiários...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setModalState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Observer(
                      builder: (_) {
                        if (controller.statusCarregaBeneficiariosAter == Status.AGUARDANDO) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        if (controller.statusCarregaBeneficiariosAter == Status.ERRO) {
                          return const Center(
                            child: Text('Erro ao carregar beneficiários'),
                          );
                        }
                        
                        // Filter and sort beneficiaries
                        List<BeneficiarioAter> filteredBeneficiarios = controller.listaBeneficiariosAter
                            .where((beneficiario) =>
                                beneficiario.name?.toLowerCase().contains(
                                    searchController.text.toLowerCase()) ?? false)
                            .toList();
                        
                        // Sort alphabetically
                        filteredBeneficiarios.sort((a, b) =>
                            (a.name ?? '').compareTo(b.name ?? ''));
                        
                        if (filteredBeneficiarios.isEmpty) {
                          return const Center(
                            child: Text('Nenhum beneficiário encontrado'),
                          );
                        }
                        
                        return ListView.builder(
                          itemCount: filteredBeneficiarios.length,
                          itemBuilder: (context, index) {
                            final beneficiario = filteredBeneficiarios[index];
                            final isSelected = selectedBeneficiarios.contains(beneficiario);
                            
                            return CheckboxListTile(
                              title: Text(beneficiario.name ?? 'Sem nome'),
                              subtitle: Text('ID: ${beneficiario.id}'),
                              value: isSelected,
                              onChanged: (bool? value) {
                                setModalState(() {
                                  if (value == true) {
                                    selectedBeneficiarios.add(beneficiario);
                                  } else {
                                    selectedBeneficiarios.remove(beneficiario);
                                  }
                                });
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              controller.listaBeneficiariosAterSelecionados.clear();
                              controller.listaBeneficiariosAterSelecionados.addAll(selectedBeneficiarios);
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Confirmar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget botaoCadastrar(BuildContext context) {
    return Observer(builder: (_) {
      final appStore = Modular.get<AppStore>();
      
      if (appStore.isOnline) {
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
            // TODO: Implementar cadastro online
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Funcionalidade de cadastro online será implementada'),
                backgroundColor: Colors.blue,
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(controller.cadastraBeneficiarioStatus == Status.AGUARDANDO)
                const CircularProgressIndicator(
                  color: Colors.white,
                )
              else
                const Text(
                  'Cadastrar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        );
      } else {
        return MaterialButton(
          padding: const EdgeInsets.all(17),
          minWidth: SizeScreen.perWidth(context, 90),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          colorBrightness: Brightness.dark,
          color: Colors.orange,
          onPressed: () async {
            // TODO: Implementar salvamento offline
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Funcionalidade de salvamento offline será implementada'),
                backgroundColor: Colors.orange,
              ),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.save, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Salvar Offline',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
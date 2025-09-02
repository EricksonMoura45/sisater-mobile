import 'package:esig_utils/size_screen.dart';
import 'package:intl/intl.dart';
import 'package:esig_utils/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater_post.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/categoria_atividade_produtiva.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/categoria_publico.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/comunidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/enq_caf.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/entidade_caf.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/escolaridade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/estado_civil.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/motivo_registro.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/municipio.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/nacionalidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/naturalidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/produto.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/programas_governamentais.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/registro_status.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/sexo.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/subproduto.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/uf.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/beneficiario_ater_controller.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/date_picker.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';
import 'package:sisater_mobile/shared/utils/widgets/input_widget.dart';
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_erro.dart';
import 'package:validadores/Validador.dart';

class EditarBeneficiarioPage extends StatefulWidget {
  const EditarBeneficiarioPage({super.key});

  @override
  State<EditarBeneficiarioPage> createState() => _EditarBeneficiarioPageState();
}

class _EditarBeneficiarioPageState extends State<EditarBeneficiarioPage> {
  BeneficiarioAter beneficiarioAter = Modular.args.data;

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController apelidoController = TextEditingController();
  final TextEditingController dataNascimentoController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController rgController = TextEditingController();
  final TextEditingController dataEmissaoController = TextEditingController();
  final TextEditingController orgaoRGController = TextEditingController();
  final TextEditingController nomeMaeController = TextEditingController();
  
  final TextEditingController lougradouroController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController complementoController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController cepEndController = TextEditingController();

  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController emailController = TextEditingController();     
  
  final TextEditingController cadastroNacionalController = TextEditingController();       

  final List<Widget> opcoesCAF = <Widget>[
    Text('NÃO'),
    Text('SIM'),
  ];

  final List<bool> opcoesCafBool = <bool>[false, false];

  BeneficiarioAterController controller = Modular.get();
  BeneficiarioAterPost? beneficiarioAterPost;

  final maskCpf = MaskTextInputFormatter(
      mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});
  final maskDataNascimento = MaskTextInputFormatter(
      mask: "##/##/####", filter: {"#": RegExp(r'[0-9]')});
  final maskTelefone = MaskTextInputFormatter(
      mask: "(##)####-####", filter: {"#": RegExp(r'[0-9]')});
  final maskCelular = MaskTextInputFormatter(
      mask: "(##)#####-####", filter: {"#": RegExp(r'[0-9]')});
  final cepMask = MaskTextInputFormatter(
      mask: "#####-###", filter: {"#": RegExp(r'[0-9]')});

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  // Estados para controlar expansão dos módulos
  bool isEnderecoExpanded = false;
  bool isPessoaisExpanded = false;
  bool isContatoExpanded = false;
  bool isGeraisExpanded = false;
  bool isRegistroExpanded = false;

  @override
  void initState() {
    // Reset do estado do controller e inicia carregamento
    controller.resetEditState();
    controller.editarBeneficiarioStatus = Status.AGUARDANDO;
    controller.mensagemError = null;
    _carregarDadosBeneficiario();
    super.initState();
  }

  void _carregarDadosBeneficiario() async {
    try {
      print('=== DEBUG: Iniciando carregamento de dados do beneficiário ${beneficiarioAter.id} ===');
      
      // Primeiro carrega os dados selecionáveis
      await controller.carregaDadosSelecionaveis();
      
      // Depois carrega os dados específicos do beneficiário
      await controller.getBeneficiarioAter(beneficiarioAter.id!);
      
      print('=== DEBUG: Dados carregados, beneficiarioAterEdit: ${controller.beneficiarioAterEdit?.name} ===');
      
      // Aguarda um pouco para garantir que tudo foi carregado
      await Future.delayed(Duration(milliseconds: 100));
      
      // Preenche os campos de texto após carregar tudo
      if (mounted) {
        setState(() {
          preencheDadosEdit();
        });
      }
    } catch (e) {
      print('Erro ao carregar dados do beneficiário: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      appBar: formAppBar(context, 'Editar Beneficiário', false, ''),
      body: Observer(
        builder: (_) {
          if (controller.editarBeneficiarioStatus == Status.AGUARDANDO || controller.editarBeneficiarioStatus == Status.NAO_CARREGADO) {
            return SingleChildScrollView(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  children: List.generate(6, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          }

          if (controller.editarBeneficiarioStatus == Status.CONCLUIDO) {
            return Column(
              children: [
                // Botão Integrante Familiar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: botaoAdicionarFamiliar(context),
                ),
                
                // Texto explicativo
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Escolha as informações que deseja editar',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Lista de módulos expansíveis
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _buildExpansibleModule(
                          title: 'Informações de endereço',
                          subtitle: 'Editar informações do endereço',
                          isExpanded: isEnderecoExpanded,
                          onToggle: () => setState(() => isEnderecoExpanded = !isEnderecoExpanded),
                          content: formularioInformacoesEndereco(),
                        ),
                        SizedBox(height: 12),
                        _buildExpansibleModule(
                          title: 'Informações Pessoais',
                          subtitle: 'Editar informações pessoais',
                          isExpanded: isPessoaisExpanded,
                          onToggle: () => setState(() => isPessoaisExpanded = !isPessoaisExpanded),
                          content: formularioDadosPessoais(),
                        ),
                        SizedBox(height: 12),
                        _buildExpansibleModule(
                          title: 'Informações de Contato',
                          subtitle: 'Editar informações de contato',
                          isExpanded: isContatoExpanded,
                          onToggle: () => setState(() => isContatoExpanded = !isContatoExpanded),
                          content: formularioinformacoesContato(),
                        ),
                        SizedBox(height: 12),
                        _buildExpansibleModule(
                          title: 'Informações Gerais',
                          subtitle: 'Editar informações gerais',
                          isExpanded: isGeraisExpanded,
                          onToggle: () => setState(() => isGeraisExpanded = !isGeraisExpanded),
                          content: formularioinformacoesGerais(),
                        ),
                        SizedBox(height: 12),
                        _buildExpansibleModule(
                          title: 'Informações de Registro',
                          subtitle: 'Editar informações de Registro',
                          isExpanded: isRegistroExpanded,
                          onToggle: () => setState(() => isRegistroExpanded = !isRegistroExpanded),
                          content: formularioInformacoesRegistro(),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                
                // Error widget
                Observer(builder: (_) {
                  if (controller.mensagemError != null) {
                    return errorWidget();
                  } else {
                    return SizedBox();
                  }
                }),
              ],
            );
          }

          if (controller.editarBeneficiarioStatus == Status.ERRO) {
            return Center(child: Text('Erro ao carregar a página.'));
          }

          return Center(child: Text('Erro ao carregar a página.'));
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: Observer(builder: (_) {
          if (controller.editarBeneficiarioStatus == Status.CONCLUIDO) {
            return Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Modular.to.pop(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Voltar',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: botaoSalvar(context),
                ),
              ],
            );
          } else {
            return SizedBox();
          }
        }),
      ),
    );
  }

  Widget _buildExpansibleModule({
    required String title,
    required String subtitle,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Header clicável
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade600,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          
          // Conteúdo expansível
          if (isExpanded)
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: content,
            ),
        ],
      ),
    );
  }

  Widget formularioDadosPessoais() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildInputField(
          label: 'Nome*',
          controller: nomeController,
        ),
        buildInputField(
          label: 'Apelido',
          controller: apelidoController,
        ),
        buildDropdownField(
          label: 'Sexo*',
          value: controller.sexoSelecionado,
          items: controller.listaSexo.map((e) => DropdownMenuItem<Sexo>(
            value: e,
            child: Text(e.name ?? 'Sem nome'),
          )).toList(),
          onChanged: controller.changeSexoSelecionada,
        ),
        DatePickerWidget(label: 'Data de Nascimento*', formfield: 1),
        buildInputField(
          label: 'CPF*',
          controller: cpfController,
          formatters: [maskCpf],
          validator: (String? cpf) {
            return Validador()
              .add(Validar.CPF, msg: 'CPF Inválido')
              .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
              .minLength(11)
              .maxLength(11)
              .valido(cpf, clearNoNumber: true);
          },
        ),
        buildDropdownField(
          label: 'Estado Civil*',
          value: controller.estadoCivilSelecionado,
          items: controller.listaEstadoCivil.map((e) => DropdownMenuItem<EstadoCivil>(
            value: e,
            child: Text(e.name ?? 'Sem nome'),
          )).toList(),
          onChanged: controller.changeEstadoCivilSelecionada,
        ),
        buildInputField(
          label: 'RG',
          controller: rgController,
        ),
        DatePickerWidget(label: 'Data de Emissão', formfield: 2),
        buildInputField(
          label: 'Órgão de Emissão',
          controller: orgaoRGController,
        ),
        buildDropdownField(
          label: 'Estado de Emissão*',
          value: controller.ufSelecionado,
          items: controller.listaUF.map((e) => DropdownMenuItem<UF>(
            value: e,
            child: Text(e.name ?? 'Sem nome'),
          )).toList(),
          onChanged: controller.changeUfSelecionada,
        ),
        buildDropdownField(
          label: 'Escolaridade*',
          value: controller.escolaridadeSelecionada,
          items: controller.listaEscolaridade.map((e) => DropdownMenuItem<Escolaridade>(
            value: e,
            child: Text(e.name ?? 'Sem nome'),
          )).toList(),
          onChanged: controller.changeEscolaridadeSelecionada,
        ),
        buildDropdownField(
          label: 'Nacionalidade*',
          value: controller.nacionalidadeSelecionada,
          items: controller.listaNacionalidade.map((e) => DropdownMenuItem<Nacionalidade>(
            value: e,
            child: Text(e.name ?? 'Sem nome'),
          )).toList(),
          onChanged: controller.changeNacionalidadeSelecionada,
        ),
        buildDropdownField(
          label: 'Naturalidade*',
          value: controller.naturalidadeSelecionada,
          items: controller.listaNaturalidade.map((e) => DropdownMenuItem<Naturalidade>(
            value: e,
            child: Text(e.name ?? 'Sem nome'),
          )).toList(),
          onChanged: controller.changeNaturalidadeSelecionada,
        ),
        buildInputField(
          label: 'Nome da Mãe',
          controller: nomeMaeController,
        ),
      ],
    );
  }

  Widget formularioInformacoesEndereco() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildInputField(
          label: 'Logradouro*',
          controller: lougradouroController,
        ),
        buildInputField(
          label: 'Nº*',
          controller: numeroController,
        ),
        buildInputField(
          label: 'Complemento',
          controller: complementoController,
        ),
        buildInputField(
          label: 'Bairro',
          controller: bairroController,
        ),
        buildDropdownField(
          label: 'UF*',
          value: controller.ufEnderecoSelecionado,
          items: controller.listaUF.map((e) => DropdownMenuItem<UF>(
            value: e,
            child: Text(e.name ?? 'Sem nome'),
          )).toList(),
          onChanged: controller.changeUfEnderecoSelecionada,
        ),
        Observer(builder: (_) {
          if (controller.statusCarregaMunicipios == Status.AGUARDANDO) {
            return Center(child: CircularProgressIndicator(color: Themes.verdeBotao));
          } else if (controller.statusCarregaMunicipios == Status.CONCLUIDO) {
            return buildDropdownField(
              label: 'Município*',
              value: controller.municipioSelecionado,
              items: controller.listaMunicipios.map((e) => DropdownMenuItem<Municipio>(
                value: e,
                child: Text(e.name ?? 'Sem nome'),
              )).toList(),
              onChanged: controller.changeMunicipioSelecionada,
            );
          } else {
            return SizedBox();
          }
        }),
        buildInputField(
          label: 'CEP',
          controller: cepEndController,
          formatters: [cepMask]
        ),
        Observer(builder: (_) {
          if (controller.statusCarregaComunidades == Status.AGUARDANDO) {
            return Center(child: CircularProgressIndicator(color: Themes.verdeBotao));
          } else if (controller.statusCarregaComunidades == Status.CONCLUIDO) {
            return buildDropdownField(
              label: 'Comunidade',
              value: controller.comunidadeSelecionada,
              items: controller.subComunidades.map((e) => DropdownMenuItem<Comunidade>(
                value: e,
                child: Text(e.name ?? 'Sem nome'),
              )).toList(),
              onChanged: controller.changeComunidadeSelecionada,
            );
          } else {
            return SizedBox();
          }
        }),
      ],
    );
  }

  Widget formularioinformacoesContato() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildInputField(
          label: 'Telefone',
          controller: telefoneController,
          formatters: [maskTelefone]
        ),
        buildInputField(
          label: 'Celular',
          controller: celularController,
          formatters: [maskCelular]
        ),
        buildInputField(
          label: 'Email',
          controller: emailController,
        ),
      ],
    );
  }

  Widget formularioinformacoesGerais() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDropdownField(
          label: 'Categoria de Público*',
          value: controller.categoriaPublicoSelecionada,
          items: controller.listaCategoriaPublico.map((e) => DropdownMenuItem<CategoriaPublico>(
            value: e,
            child: Text(e.name ?? 'Sem nome'),
          )).toList(),
          onChanged: controller.changeCategoriaPublicoSelecionada,
        ),
        buildDropdownField(
          label: 'Categoria por Atividade Produtiva',
          value: controller.categoriaAtividadeProdutivaSelecionada,
          items: controller.listaCategoriaAtividadeProdutiva.map((e) => DropdownMenuItem<CategoriaAtividadeProdutiva>(
            value: e,
            child: Text(e.name ?? 'Sem nome'),
          )).toList(),
          onChanged: controller.changeAtividadeProdutivaSelecionada,
        ),
        if (controller.categoriasAtividadeProdutivaSelecionadas.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Themes.verdeBotao, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: controller.categoriasAtividadeProdutivaSelecionadas
                    .map((item) => Chip(
                          label: Text(item.name ?? ''),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              controller.categoriasAtividadeProdutivaSelecionadas.remove(item);
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
        buildDropdownField(
          label: 'Produto',
          value: controller.produtoSelecionado,
          items: controller.listaProdutos.map((e) => DropdownMenuItem<Produto>(
            value: e,
            child: Text(e.name ?? 'Sem nome'),
          )).toList(),
          onChanged: controller.changeProdutoSelecionada,
        ),
        if (controller.produtosSelecionados.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Themes.verdeBotao, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: controller.produtosSelecionados
                    .map((item) => Chip(
                          label: Text(item.name ?? ''),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              controller.produtosSelecionados.remove(item);
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
        buildDropdownField(
          label: 'Subprodutos/Derivados',
          value: controller.subProdutoSelecionado,
          items: controller.listaSubprodutos.map((e) => DropdownMenuItem<SubProduto>(
            value: e,
            child: Text(e.name ?? 'Sem nome'),
          )).toList(),
          onChanged: controller.changeSubProdutoSelecionada,
        ),
        if (controller.subProdutosSelecionados.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Themes.verdeBotao, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: controller.subProdutosSelecionados
                    .map((item) => Chip(
                          label: Text(item.name ?? ''),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              controller.subProdutosSelecionados.remove(item);
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
        Text('CAF', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
        SizedBox(height: 8),
        ToggleButtons(
          borderRadius: BorderRadius.circular(8),
          selectedBorderColor: Colors.black,
          selectedColor: Colors.white,
          fillColor: Themes.verdeBotao,
          color: Colors.black,
          constraints: BoxConstraints(minHeight: 40, minWidth: 80),
          onPressed: (int index) {
            setState(() {
              for (int i = 0; i < opcoesCafBool.length; i++) {
                opcoesCafBool[i] = i == index;
                if (opcoesCafBool[1] == true) {
                  controller.cafBool = true;
                } else {
                  controller.cafBool = false;
                }
              }
            });
          },
          isSelected: controller.cafBool == true ? opcoesCafBool : [false, true],
          children: opcoesCAF,
        ),
        Observer(builder: (_) {
          if (controller.cafBool == true) {
            return buildCafOpcoes();
          } else {
            return SizedBox();
          }
        }),
        buildInputField(
          label: 'Cadastro Nacional da Agricultura Familiar - CAF',
          controller: cadastroNacionalController,
        ),
        buildDropdownField(
          label: 'Programas Governamentais',
          value: controller.programasGovernamentaisSelecionado,
          items: controller.listaProgramasGovernamentais.map((e) => DropdownMenuItem<ProgramasGovernamentais>(
            value: e,
            child: Text(e.name ?? 'Sem nome'),
          )).toList(),
          onChanged: controller.changeProgGovSelecionada,
        ),
        if (controller.programasGovernamentaisSelecionados.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Themes.verdeBotao, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: controller.programasGovernamentaisSelecionados
                    .map((item) => Chip(
                          label: Text(item.name ?? ''),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              controller.programasGovernamentaisSelecionados.remove(item);
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
      ],
    );
  }

  Widget formularioInformacoesRegistro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDropdownField(
          label: 'Motivo Cadastro*',
          value: controller.motivoRegistroSelecionado,
          items: controller.listaMotivoRegistro.map((e) => DropdownMenuItem<MotivoRegistro>(
            value: e,
            child: Text(e.name ?? 'Sem nome'),
          )).toList(),
          onChanged: controller.changeMotivoRegistroSelecionada,
        ),
        if (controller.motivosRegistroSelecionados.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Themes.verdeBotao, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: controller.motivosRegistroSelecionados
                    .map((item) => Chip(
                          label: Text(item.name ?? ''),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              controller.motivosRegistroSelecionados.remove(item);
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
        buildDropdownField(
          label: 'Situação Cadastro*',
          value: controller.registroStatusSelecionado,
          items: controller.listaRegistroStatus.map((e) => DropdownMenuItem<RegistroStatus>(
            value: e,
            child: Text(e.name ?? 'Sem nome'),
          )).toList(),
          onChanged: controller.changeRegistroStatusSelecionada,
        ),
      ],
    );
  }

  Widget buildCafOpcoes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        buildDropdownField(
          label: 'Enquadramento do CAF',
          value: controller.EnqCafSelecionada,
          items: controller.listaEnqCaf.map((e) => DropdownMenuItem<EnqCaf>(
            value: e,
            child: Text(e.name ?? 'Sem nome'),
          )).toList(),
          onChanged: controller.changeEnqCafSelecionada,
        ),
        buildDropdownField(
          label: 'Entidade responsável pela emissão do CAF',
          value: controller.EntidadeCafSelecionada,
          items: controller.listaEntidadeCaf.map((e) => DropdownMenuItem<EntidadeCaf>(
            value: e,
            child: Text(e.name ?? 'Sem nome'),
          )).toList(),
          onChanged: controller.changeEntidadeCafSelecionada,
        ),
      ],
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
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          InputWidget(
            controller: controller,
            formatters: formatters,
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget buildDropdownField<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Selecione uma opção',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Themes.verdeBotao),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
            dropdownColor: Colors.white,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget botaoAdicionarFamiliar(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.all(17),
      minWidth: SizeScreen.perWidth(context, 90),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      colorBrightness: Brightness.dark,
      color: Themes.verdeBotao,
      onPressed: () async {
        await controller.carregaFamiliares(beneficiarioAter.id!);
        Modular.to.pushNamed('integrantes_familia', arguments: beneficiarioAter);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Observer(builder: (_) {
            if (controller.statusFamiliaresBeneficiario == Status.AGUARDANDO) {
              return CircularProgressIndicator(color: Colors.white);
            } else {
              return Row(
                children: [
                  Text(
                    'Integrante Familiar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.navigate_next),
                  )
                ]
              );
            }
          }),
        ],
      ),
    );
  }

  Widget botaoSalvar(BuildContext context) {
    return Observer(builder: (_) {
      if (controller.cadastraBeneficiarioStatus == Status.AGUARDANDO) {
        return ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Themes.verdeBotao,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        );
      } else {
        return ElevatedButton(
          onPressed: () async {
            verificaCamposObrigatorios();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Themes.verdeBotao,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Salvar Alterações',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }
    });
  }

  void verificaCamposObrigatorios() async {
    if (nomeController.text != '' && controller.sexoSelecionado != null && cpfController.text != '' && controller.estadoCivilSelecionado != null && controller.escolaridadeSelecionada != null && controller.nacionalidadeSelecionada != null && controller.naturalidadeSelecionada != null) {
      if (lougradouroController.text != '' && numeroController.text != '' && controller.ufEnderecoSelecionado != null) {
        if (controller.categoriaPublicoSelecionada != null) {
          if (controller.motivoRegistroSelecionado != null && controller.registroStatusSelecionado != null) {
            beneficiarioAterPost = BeneficiarioAterPost(
              document: cpfController.text,
              name: nomeController.text,
              type: controller.sexoSelecionado!.id,
              street: lougradouroController.text,
              number: numeroController.text,
              complement: complementoController.text,
              neighborhood: bairroController.text,
              cityCode: controller.municipioSelecionado?.code ?? '1502509',
              postalCode: cepEndController.text,
              phone: telefoneController.text,
              cellphone: celularController.text,
              email: emailController.text,
              communityId: controller.comunidadeSelecionada?.id,
              targetPublicId: controller.categoriaPublicoSelecionada?.id ?? 1,
              hasDap: controller.cafBool! ? 0 : 1,
              nis: '',
              dapId: controller.EnqCafSelecionada?.id,
              dapOriginId: controller.EntidadeCafSelecionada?.id,
              caf: cadastroNacionalController.text,
              reasonMultiples: controller.motivosRegistroSelecionados.map((e) => e.id.toString()).toList(),
              officeId: 1,
              registrationStatusId: controller.registroStatusSelecionado?.id ?? 4,
              productMultiples: controller.produtosSelecionados.map((e) => e.id.toString()).toList(),
              derivativesMultiples: controller.subProdutosSelecionados.map((e) => e.id.toString()).toList(),
              productiveActivityMultiples: controller.categoriasAtividadeProdutivaSelecionadas.map((e) => e.id.toString()).toList(),
              governmentProgramsMultiples: controller.programasGovernamentaisSelecionados.map((e) => e.id.toString()).toList(),
              targetPublicMultiples: controller.motivosRegistroSelecionados.map((e) => e.id.toString()).toList(),
              physicalPerson: PhysicalPerson(
                nickname: apelidoController.text,
                gender: controller.sexoSelecionado!.id,
                civilStatus: controller.estadoCivilSelecionado!.id,
                nationalityId: controller.nacionalidadeSelecionada!.id,
                nationalIdentity: rgController.text,
                naturalnessId: controller.naturalidadeSelecionada!.id,
                birthDate: '${controller.dataNascimentoPicked.year}-${controller.dataNascimentoPicked.month}-${controller.dataNascimentoPicked.day}',
                issuingEntity: orgaoRGController.text,
                issueDate: '${controller.dataEmissaoRGPicked.year}-${controller.dataEmissaoRGPicked.month}-${controller.dataEmissaoRGPicked.day}',
                scholarityId: controller.escolaridadeSelecionada!.id,
                mothersName: nomeMaeController.text,
                issuingUf: controller.ufSelecionado?.code,
              )
            );

            await controller.putBeneficiarios(beneficiarioAter.id, beneficiarioAterPost);
          } else {
            ToastAvisosErro('Campos obrigatórios(*) em "Informações de Registro" não preenchidos');
          }
        } else {
          ToastAvisosErro('Campos obrigatórios(*) em "Informações Gerais" não preenchidos');
        }
      } else {
        ToastAvisosErro('Campos obrigatórios(*) em "Informações de Endereço" não preenchidos');
      }
    } else {
      ToastAvisosErro('Campos obrigatórios(*) em "Informações Pessoais" não preenchidos');
    }
  }

  Widget errorWidget() {
    return Column(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              controller.mensagemError!,
              style: TextStyle(color: Colors.red),
            ),
          ),
        )
      ],
    );
  }

  void preencheDadosEdit() {
    if (controller.beneficiarioAterEdit == null) {
      print('beneficiarioAterEdit é null');
      return;
    }

    print('Preenchendo dados do beneficiário: ${controller.beneficiarioAterEdit?.name}');
    
    // Define se tem CAF baseado no hasDap
    bool isCaf = controller.beneficiarioAterEdit?.hasDap == 1;
    controller.cafBool = isCaf;
    
    // Preenche os campos de texto
    nomeController.text = controller.beneficiarioAterEdit?.name ?? '';
    apelidoController.text = controller.beneficiarioAterEdit?.physicalPerson?.nickname ?? '';
    dataNascimentoController.text = controller.beneficiarioAterEdit?.physicalPerson?.birthDate ?? '';
    cpfController.text = controller.beneficiarioAterEdit?.document ?? '';
    rgController.text = controller.beneficiarioAterEdit?.physicalPerson?.nationalIdentity ?? '';
    dataEmissaoController.text = controller.beneficiarioAterEdit?.physicalPerson?.issueDate ?? '';
    orgaoRGController.text = controller.beneficiarioAterEdit?.physicalPerson?.issuingEntity ?? '';
    nomeMaeController.text = controller.beneficiarioAterEdit?.physicalPerson?.mothersName ?? '';
    lougradouroController.text = controller.beneficiarioAterEdit?.street ?? '';
    numeroController.text = controller.beneficiarioAterEdit?.number ?? '';
    complementoController.text = controller.beneficiarioAterEdit?.complement ?? '';
    bairroController.text = controller.beneficiarioAterEdit?.neighborhood ?? '';
    cepEndController.text = controller.beneficiarioAterEdit?.postalCode?.toString() ?? '';
    telefoneController.text = controller.beneficiarioAterEdit?.phone ?? '';
    celularController.text = controller.beneficiarioAterEdit?.cellphone ?? '';
    emailController.text = controller.beneficiarioAterEdit?.email ?? '';
    cadastroNacionalController.text = controller.beneficiarioAterEdit?.caf ?? '';
    
    print('Dados preenchidos - Nome: ${nomeController.text}, CPF: ${cpfController.text}');
  }
}

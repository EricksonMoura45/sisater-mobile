import 'package:esig_utils/size_screen.dart';
import 'package:intl/intl.dart';
import 'package:esig_utils/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater_post.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/beneficiario_ater_controller.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';

class VisualizarBeneficiarioAterPage extends StatefulWidget {
  final BeneficiarioAter beneficiario;

  const VisualizarBeneficiarioAterPage({
    super.key,
    required this.beneficiario,
  });

  @override
  State<VisualizarBeneficiarioAterPage> createState() => _VisualizarBeneficiarioAterPageState();
}

class _VisualizarBeneficiarioAterPageState extends State<VisualizarBeneficiarioAterPage> {
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
      appBar: formAppBar(context, 'Visualizar Beneficiário', false, ''),
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
                    'Visualize as informações do beneficiário',
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
                          subtitle: 'Visualizar informações do endereço',
                          isExpanded: isEnderecoExpanded,
                          onToggle: () => setState(() => isEnderecoExpanded = !isEnderecoExpanded),
                          content: formularioInformacoesEndereco(),
                        ),
                        SizedBox(height: 12),
                        _buildExpansibleModule(
                          title: 'Informações Pessoais',
                          subtitle: 'Visualizar informações pessoais',
                          isExpanded: isPessoaisExpanded,
                          onToggle: () => setState(() => isPessoaisExpanded = !isPessoaisExpanded),
                          content: formularioDadosPessoais(),
                        ),
                        SizedBox(height: 12),
                        _buildExpansibleModule(
                          title: 'Informações de Contato',
                          subtitle: 'Visualizar informações de contato',
                          isExpanded: isContatoExpanded,
                          onToggle: () => setState(() => isContatoExpanded = !isContatoExpanded),
                          content: formularioinformacoesContato(),
                        ),
                        SizedBox(height: 12),
                        _buildExpansibleModule(
                          title: 'Informações Gerais',
                          subtitle: 'Visualizar informações gerais',
                          isExpanded: isGeraisExpanded,
                          onToggle: () => setState(() => isGeraisExpanded = !isGeraisExpanded),
                          content: formularioinformacoesGerais(),
                        ),
                        SizedBox(height: 12),
                        _buildExpansibleModule(
                          title: 'Informações de Registro',
                          subtitle: 'Visualizar informações de Registro',
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
            return SizedBox(
              width: double.infinity,
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
                    fontSize: 16,
                  ),
                ),
              ),
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
        buildReadOnlyField(
          label: 'Nome*',
          value: nomeController.text,
        ),
        buildReadOnlyField(
          label: 'Apelido',
          value: apelidoController.text,
        ),
        buildReadOnlyDropdownField(
          label: 'Sexo*',
          value: controller.sexoSelecionado?.name ?? 'Não informado',
        ),
        buildReadOnlyField(
          label: 'Data de Nascimento*',
          value: dataNascimentoController.text,
        ),
        buildReadOnlyField(
          label: 'CPF*',
          value: cpfController.text,
        ),
        buildReadOnlyDropdownField(
          label: 'Estado Civil*',
          value: controller.estadoCivilSelecionado?.name ?? 'Não informado',
        ),
        buildReadOnlyField(
          label: 'RG',
          value: rgController.text,
        ),
        buildReadOnlyField(
          label: 'Data de Emissão',
          value: dataEmissaoController.text,
        ),
        buildReadOnlyField(
          label: 'Órgão de Emissão',
          value: orgaoRGController.text,
        ),
        buildReadOnlyDropdownField(
          label: 'Estado de Emissão*',
          value: controller.ufSelecionado?.name ?? 'Não informado',
        ),
        buildReadOnlyDropdownField(
          label: 'Escolaridade*',
          value: controller.escolaridadeSelecionada?.name ?? 'Não informado',
        ),
        buildReadOnlyDropdownField(
          label: 'Nacionalidade*',
          value: controller.nacionalidadeSelecionada?.name ?? 'Não informado',
        ),
        buildReadOnlyDropdownField(
          label: 'Naturalidade*',
          value: controller.naturalidadeSelecionada?.name ?? 'Não informado',
        ),
        buildReadOnlyField(
          label: 'Nome da Mãe',
          value: nomeMaeController.text,
        ),
      ],
    );
  }

  Widget formularioInformacoesEndereco() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildReadOnlyField(
          label: 'Logradouro*',
          value: lougradouroController.text,
        ),
        buildReadOnlyField(
          label: 'Nº*',
          value: numeroController.text,
        ),
        buildReadOnlyField(
          label: 'Complemento',
          value: complementoController.text,
        ),
        buildReadOnlyField(
          label: 'Bairro',
          value: bairroController.text,
        ),
        buildReadOnlyDropdownField(
          label: 'UF*',
          value: controller.ufEnderecoSelecionado?.name ?? 'Não informado',
        ),
        Observer(builder: (_) {
          if (controller.statusCarregaMunicipios == Status.AGUARDANDO) {
            return Center(child: CircularProgressIndicator(color: Themes.verdeBotao));
          } else if (controller.statusCarregaMunicipios == Status.CONCLUIDO) {
            return buildReadOnlyDropdownField(
              label: 'Município*',
              value: controller.municipioSelecionado?.name ?? 'Não informado',
            );
          } else {
            return SizedBox();
          }
        }),
        buildReadOnlyField(
          label: 'CEP',
          value: cepEndController.text,
        ),
        Observer(builder: (_) {
          if (controller.statusCarregaComunidades == Status.AGUARDANDO) {
            return Center(child: CircularProgressIndicator(color: Themes.verdeBotao));
          } else if (controller.statusCarregaComunidades == Status.CONCLUIDO) {
            return buildReadOnlyDropdownField(
              label: 'Comunidade',
              value: controller.comunidadeSelecionada?.name ?? 'Não informado',
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
        buildReadOnlyField(
          label: 'Telefone',
          value: telefoneController.text,
        ),
        buildReadOnlyField(
          label: 'Celular',
          value: celularController.text,
        ),
        buildReadOnlyField(
          label: 'Email',
          value: emailController.text,
        ),
      ],
    );
  }

  Widget formularioinformacoesGerais() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildReadOnlyDropdownField(
          label: 'Categoria de Público*',
          value: controller.categoriaPublicoSelecionada?.name ?? 'Não informado',
        ),
        buildReadOnlyDropdownField(
          label: 'Categoria por Atividade Produtiva',
          value: controller.categoriaAtividadeProdutivaSelecionada?.name ?? 'Não informado',
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
                          backgroundColor: Colors.grey.shade100,
                        ))
                    .toList(),
              ),
            ),
          ),
        buildReadOnlyDropdownField(
          label: 'Produto',
          value: controller.produtoSelecionado?.name ?? 'Não informado',
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
                          backgroundColor: Colors.grey.shade100,
                        ))
                    .toList(),
              ),
            ),
          ),
        buildReadOnlyDropdownField(
          label: 'Subprodutos/Derivados',
          value: controller.subProdutoSelecionado?.name ?? 'Não informado',
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
                          backgroundColor: Colors.grey.shade100,
                        ))
                    .toList(),
              ),
            ),
          ),
        Text('CAF', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade50,
          ),
          child: Text(
            controller.cafBool == true ? 'SIM' : 'NÃO',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
        Observer(builder: (_) {
          if (controller.cafBool == true) {
            return buildCafOpcoes();
          } else {
            return SizedBox();
          }
        }),
        buildReadOnlyField(
          label: 'Cadastro Nacional da Agricultura Familiar - CAF',
          value: cadastroNacionalController.text,
        ),
        buildReadOnlyDropdownField(
          label: 'Programas Governamentais',
          value: controller.programasGovernamentaisSelecionado?.name ?? 'Não informado',
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
                          backgroundColor: Colors.grey.shade100,
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
        buildReadOnlyDropdownField(
          label: 'Motivo Cadastro*',
          value: controller.motivoRegistroSelecionado?.name ?? 'Não informado',
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
                          backgroundColor: Colors.grey.shade100,
                        ))
                    .toList(),
              ),
            ),
          ),
        buildReadOnlyDropdownField(
          label: 'Situação Cadastro*',
          value: controller.registroStatusSelecionado?.name ?? 'Não informado',
        ),
      ],
    );
  }

  Widget buildCafOpcoes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        buildReadOnlyDropdownField(
          label: 'Enquadramento do CAF',
          value: controller.EnqCafSelecionada?.name ?? 'Não informado',
        ),
        buildReadOnlyDropdownField(
          label: 'Entidade responsável pela emissão do CAF',
          value: controller.EntidadeCafSelecionada?.name ?? 'Não informado',
        ),
      ],
    );
  }

  Widget buildReadOnlyField({
    required String label,
    required String value,
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade50,
            ),
            child: Text(
              value.isEmpty ? 'Não informado' : value,
              style: TextStyle(
                fontSize: 16,
                color: value.isEmpty ? Colors.grey.shade500 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReadOnlyDropdownField({
    required String label,
    required String value,
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade50,
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
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

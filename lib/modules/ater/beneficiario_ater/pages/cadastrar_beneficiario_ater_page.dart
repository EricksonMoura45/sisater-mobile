import 'package:intl/intl.dart';
import 'package:esig_utils/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shimmer/shimmer.dart';
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
//MOTIVO DA PAGINA NÃO SER MODULARIZADA: Cada campo desses tem uma particularidade no backend, ou seja, torna-se difícil criar uma função, widget generalista para a página.
class CadastrarBeneficiarioAterPage extends StatefulWidget {
  const CadastrarBeneficiarioAterPage({super.key});

  @override
  State<CadastrarBeneficiarioAterPage> createState() =>
      _CadastrarBeneficiarioAterPageState();
}

class _CadastrarBeneficiarioAterPageState
    extends State<CadastrarBeneficiarioAterPage> {

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

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  final List<Widget> opcoesCAF = <Widget>[
  Text('NÃO'),
  Text('SIM'),
];

  final List<bool> opcoesCafBool = <bool>[false, false];

  int currentStep = 0;

  BeneficiarioAterController controller = Modular.get();

  BeneficiarioAterPost? beneficiarioAterPost;

  @override
  void initState() {
    controller.carregaDadosSelecionaveis();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      appBar: formAppBar(context, 'Beneficiários de ATER', false, ''),
      body: Observer(
        builder: (_) {
          if (controller.statusCarregaDadosPagina == Status.AGUARDANDO) {
            return SingleChildScrollView(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 6,
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

          if (controller.statusCarregaDadosPagina == Status.CONCLUIDO) {
            return Column(
              children: [
                // Progress indicator
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (index) {
                      bool isActive = index <= currentStep;
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isActive ? Themes.verdeBotao : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStepTitle(currentStep),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '*Todos os campos obrigatórios devem ser preenchidos.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 20),
                
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: _getStepContent(currentStep),
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

          if (controller.statusCarregaDadosPagina == Status.ERRO) {
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
          if (controller.statusCarregaDadosPagina == Status.CONCLUIDO) {
            return Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: currentStep > 0 ? () => _previousStep() : null,
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
                  child: currentStep < 4 
                    ? ElevatedButton(
                        onPressed: () => _nextStep(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Themes.verdeBotao,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Próximo',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : botaoCadastrar(context),
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

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Informações Pessoais';
      case 1:
        return 'Informações de Endereço';
      case 2:
        return 'Informações de Contato';
      case 3:
        return 'Informações Gerais';
      case 4:
        return 'Informações de Registro';
      default:
        return 'Informações Pessoais';
    }
  }

  Widget _getStepContent(int step) {
    switch (step) {
      case 0:
        return formularioDadosPessoais();
      case 1:
        return formularioInformacoesEndereco();
      case 2:
        return formularioinformacoesContato();
      case 3:
        return formularioinformacoesGerais();
      case 4:
        return formularioInformacoesRegistro();
      default:
        return formularioDadosPessoais();
    }
  }

  void _nextStep() {
    if (currentStep < 4) {
      setState(() {
        currentStep++;
      });
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  void _abrirSelecaoNaturalidade() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // Ordenar naturalidades alfabeticamente
            final naturalidadesOrdenadas = List<Naturalidade>.from(controller.listaNaturalidade)
              ..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
            
            // Estado para pesquisa
            String termoPesquisa = '';
            List<Naturalidade> naturalidadesFiltradas = List<Naturalidade>.from(naturalidadesOrdenadas);
            
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Selecionar Naturalidade',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (controller.naturalidadeSelecionada != null)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                controller.changeNaturalidadeSelecionada(null);
                              });
                            },
                            child: const Text(
                              'Limpar',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Divider(),
                  // Campo de pesquisa
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Pesquisar naturalidade...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onChanged: (value) {
                        setState(() {
                          termoPesquisa = value.toLowerCase();
                          if (termoPesquisa.isEmpty) {
                            naturalidadesFiltradas = List<Naturalidade>.from(naturalidadesOrdenadas);
                          } else {
                            naturalidadesFiltradas = naturalidadesOrdenadas
                                .where((naturalidade) =>
                                    naturalidade.name?.toLowerCase().contains(termoPesquisa) ?? false)
                                .toList();
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Lista de naturalidades filtradas
                  Expanded(
                    child: naturalidadesFiltradas.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Nenhuma naturalidade encontrada',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'Tente ajustar sua pesquisa',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: naturalidadesFiltradas.length,
                            itemBuilder: (BuildContext context, int index) {
                              final naturalidade = naturalidadesFiltradas[index];
                              final isSelected = controller.naturalidadeSelecionada?.id == naturalidade.id;
                              return ListTile(
                                title: Text(
                                  naturalidade.name ?? 'Nome não informado',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isSelected ? const Color(0xFF28A745) : Colors.black87,
                                  ),
                                ),
                                leading: Icon(
                                  isSelected ? Icons.check_circle : Icons.location_city_outlined,
                                  color: isSelected ? const Color(0xFF28A745) : Colors.grey.shade600,
                                ),
                                onTap: () {
                                  setState(() {
                                    controller.changeNaturalidadeSelecionada(naturalidade);
                                  });
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 16),
                  // Botões de ação
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFE9ECEF)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                color: Color(0xFF212529),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF28A745),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Confirmar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
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
        Form(
          key: formKey,
          child: buildInputField(
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
        // Campo de Naturalidade com seleção modal
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Naturalidade*',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _abrirSelecaoNaturalidade(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: controller.naturalidadeSelecionada == null 
                          ? const Color(0xFFE9ECEF)
                          : const Color(0xFF28A745),
                      width: controller.naturalidadeSelecionada == null ? 1 : 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          controller.naturalidadeSelecionada?.name ?? 'Selecione a naturalidade',
                          style: TextStyle(
                            color: controller.naturalidadeSelecionada == null
                                ? const Color(0xFF6C757D)
                                : const Color(0xFF212529),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Icon(
                        controller.naturalidadeSelecionada != null 
                            ? Icons.check_circle
                            : Icons.keyboard_arrow_down,
                        color: controller.naturalidadeSelecionada != null 
                            ? const Color(0xFF28A745)
                            : const Color(0xFF6C757D),
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.naturalidadeSelecionada == null) ...[
                const SizedBox(height: 4),
                const Text(
                  'Campo obrigatório',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
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
        const SizedBox(height: 20),
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

        Text('UF*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<UF>(
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
           key: const ValueKey('ufEnderecoDropdown'),
           isExpanded: true,
           value: controller.ufEnderecoSelecionado,
           items: controller.listaUF.map(
            (e) => DropdownMenuItem<UF>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeUfEnderecoSelecionada
          ),
          SizedBox(height: 10,),

          Observer(builder: (_){
            if(controller.statusCarregaMunicipios == Status.AGUARDANDO){
              return Center(child: CircularProgressIndicator(color: Themes.verdeBotao,),);
            }
            else if(controller.statusCarregaMunicipios == Status.CONCLUIDO){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('Município*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<Municipio>(
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
           value: controller.municipioSelecionado,
           items: controller.listaMunicipios.map(
            (e) => DropdownMenuItem<Municipio>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeMunicipioSelecionada
          ),
          SizedBox(height: 10,),
                ],
              );
            }
            else if(controller.statusCarregaMunicipios == Status.ERRO){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Município*',
                    style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      border: Border.all(color: Colors.red.shade200),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade600, size: 24),
                        const SizedBox(height: 8),
                        Text(
                          'Erro ao carregar municípios',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tente selecionar o UF novamente',
                          style: TextStyle(
                            color: Colors.red.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }
            else{
              return SizedBox();
            }
          }),

          buildInputField(
          label: 'CEP',
          controller: cepEndController,
          formatters: [cepMask]
        ), 

         Observer(builder: (_){

          if(controller.statusCarregaComunidades == Status.AGUARDANDO){
              return Center(child: CircularProgressIndicator(color: Themes.verdeBotao,),);
          }
          else if(controller.statusCarregaComunidades == Status.CONCLUIDO){
           return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Comunidade',
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
          items: controller.subComunidades.map(
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
         else if(controller.statusCarregaComunidades == Status.ERRO){
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text('Comunidade',
                 style: const TextStyle(
                   fontSize: 18, fontWeight: FontWeight.bold)),
               Container(
                 width: double.infinity,
                 padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                   color: Colors.red.shade50,
                   border: Border.all(color: Colors.red.shade200),
                   borderRadius: BorderRadius.circular(10),
                 ),
                 child: Column(
                   children: [
                     Icon(Icons.error_outline, color: Colors.red.shade600, size: 24),
                     const SizedBox(height: 8),
                     Text(
                       'Erro ao carregar comunidades',
                       style: TextStyle(
                         color: Colors.red.shade700,
                         fontWeight: FontWeight.w600,
                       ),
                     ),
                     const SizedBox(height: 4),
                     Text(
                       'Tente selecionar o município novamente',
                       style: TextStyle(
                         color: Colors.red.shade600,
                         fontSize: 12,
                       ),
                     ),
                   ],
                 ),
               ),
               const SizedBox(height: 10),
             ],
           );
         }
         else{
           return SizedBox();
         }})
      ],
    );
  }

  Widget formularioinformacoesContato() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
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

         Text('Categoria de Público*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<CategoriaPublico>(
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
           key: const ValueKey('categoriaPublicoDropdown'),
           isExpanded: true,
           value: controller.categoriaPublicoSelecionada,
          items: controller.listaCategoriaPublico.map(
            (e) => DropdownMenuItem<CategoriaPublico>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeCategoriaPublicoSelecionada
          ),
          SizedBox(height: 10,),

          Text('Categoria por Atividade Produtiva',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<CategoriaAtividadeProdutiva>(
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
           key: const ValueKey('categoriaAtivudadeDropdown'),
           isExpanded: true,
           value: controller.categoriaAtividadeProdutivaSelecionada,
          items: controller.listaCategoriaAtividadeProdutiva.map(
            (e) => DropdownMenuItem<CategoriaAtividadeProdutiva>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeAtividadeProdutivaSelecionada
          ),
          SizedBox(height: 10,),

          controller.categoriasAtividadeProdutivaSelecionadas.isEmpty ? 
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

          Text('Produto',
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
           key: const ValueKey('ProdutoDropdown'),
           isExpanded: true,
           value: controller.produtoSelecionado,
          items: controller.listaProdutos.map(
            (e) => DropdownMenuItem<Produto>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeProdutoSelecionada
          ),
          SizedBox(height: 10,),

          controller.produtosSelecionados.isEmpty ? 
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
            
          Text('Subprodutos/Derivados',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<SubProduto>(
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
           key: const ValueKey('subProdutoDropdown'),
           isExpanded: true,
           value: controller.subProdutoSelecionado,
          items: controller.listaSubprodutos.map(
            (e) => DropdownMenuItem<SubProduto>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeSubProdutoSelecionada
          ),
          SizedBox(height: 10,),

          controller.subProdutosSelecionados.isEmpty ? 
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

          Text('CAF',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          ToggleButtons(
            borderRadius: BorderRadius.circular(8),
            selectedBorderColor: Colors.black,
            selectedColor: Colors.white,
            fillColor: Themes.verdeBotao,
            color: Colors.black,
            constraints: BoxConstraints(minHeight: 40, minWidth: 80),
            onPressed: (int index){
              setState(() {
                for (int i = 0; i < opcoesCafBool.length; i++) {
                opcoesCafBool[i] = i == index;

                if(opcoesCafBool[1] == true){
                  setState(() {
                    controller.cafBool = true;
                  });
                }
                else{
                  setState(() {
                    controller.cafBool = false;
                  });
                }
              }
              });
            },
            isSelected: opcoesCafBool, 
            children: opcoesCAF),

            Observer(builder: (_){
              if(controller.cafBool == true){
                return buildCafOpcoes();
              }
              else{
                return SizedBox();
              }
            }),

            SizedBox(height: 20,),

        buildInputField(
          label: 'Cadastro Nacional da Agricultura Familiar - CAF',
          controller: cadastroNacionalController,


        ),

          Text('Programas Governamentais',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<ProgramasGovernamentais>(
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
           key: const ValueKey('progGovDropdown'),
           isExpanded: true,
           value: controller.programasGovernamentaisSelecionado,
          items: controller.listaProgramasGovernamentais.map(
            (e) => DropdownMenuItem<ProgramasGovernamentais>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeProgGovSelecionada
          ),
          SizedBox(height: 10,),  

          controller.programasGovernamentaisSelecionados.isEmpty ? 
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

  Widget formularioInformacoesRegistro (){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Text('Motivo Cadastro*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<MotivoRegistro>(
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
           value: controller.motivoRegistroSelecionado,
          items: controller.listaMotivoRegistro.map(
            (e) => DropdownMenuItem<MotivoRegistro>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeMotivoRegistroSelecionada
          ),
          SizedBox(height: 10,),

          controller.motivosRegistroSelecionados.isEmpty ? 
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

          Text('Situação Cadastro*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<RegistroStatus>(
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
           key: const ValueKey('registroStatusDropdown'),
           isExpanded: true,
           value: controller.registroStatusSelecionado,
          items: controller.listaRegistroStatus.map(
            (e) => DropdownMenuItem<RegistroStatus>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeRegistroStatusSelecionada
          ),
          SizedBox(height: 10,),
      ]
    );
  }

  Widget buildCafOpcoes(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
        Text('Enquadramento do CAF',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<EnqCaf>(
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
           key: const ValueKey('enqCafDropdown'),
           isExpanded: true,
           value: controller.EnqCafSelecionada,
          items: controller.listaEnqCaf.map(
            (e) => DropdownMenuItem<EnqCaf>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeEnqCafSelecionada
          ),
          SizedBox(height: 10,),

           Text('Entidade responsável pela emissão do CAF',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<EntidadeCaf>(
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
           key: const ValueKey('EntidadeCafDropdown'),
           isExpanded: true,
           value: controller.EntidadeCafSelecionada,
          items: controller.listaEntidadeCaf.map(
            (e) => DropdownMenuItem<EntidadeCaf>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeEntidadeCafSelecionada
          ),
          SizedBox(height: 10,),
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



  Widget botaoCadastrar(BuildContext context) {
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
            'Cadastrar',
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

  void verificaCamposObrigatorios() async{
    
    if(nomeController.text != '' && controller.sexoSelecionado != null && cpfController.text != '' && controller.estadoCivilSelecionado != null && controller.escolaridadeSelecionada != null && controller.nacionalidadeSelecionada != null && controller.naturalidadeSelecionada != null){
      if(lougradouroController.text != '' && numeroController.text != '' && controller.ufEnderecoSelecionado != null){
        if(controller.categoriaPublicoSelecionada != null){
          if(controller.motivoRegistroSelecionado != null && controller.registroStatusSelecionado != null){
          //Apto para fazer POST

          beneficiarioAterPost = BeneficiarioAterPost(
            document: cpfController.text,
            name: nomeController.text,
            type: controller.sexoSelecionado!.id,
            street: lougradouroController.text,
            number: numeroController.text,
            complement: complementoController.text,
            neighborhood: bairroController.text,
            cityCode: controller.municipioSelecionado?.code ?? '1502509', //MOCK
            postalCode: cepEndController.text,
            phone: telefoneController.text,
            cellphone: celularController.text,
            email: emailController.text,
            communityId: controller.comunidadeSelecionada?.id,
            targetPublicId: controller.categoriaPublicoSelecionada?.id ?? 1, //MOCK
            hasDap: (controller.cafBool ?? false) ? 0 : 1,
            nis: '', //MOCK
            dapId: controller.EnqCafSelecionada?.id,
            dapOriginId: controller.EntidadeCafSelecionada?.id,
            caf: cadastroNacionalController.text,
            reasonMultiples: controller.motivosRegistroSelecionados.map((e) => e.id.toString()).toList(),
            officeId: 1, //MOCK
            registrationStatusId: controller.registroStatusSelecionado?.id ?? 4,//MOCK
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
              birthDate: '${controller.dataNascimentoPicked.year}-${controller.dataNascimentoPicked.month}-${controller.dataNascimentoPicked.day}', //MOCK
              issuingEntity: orgaoRGController.text,
              issueDate: '${controller.dataEmissaoRGPicked.year}-${controller.dataEmissaoRGPicked.month}-${controller.dataEmissaoRGPicked.day}', //MOCK
              scholarityId: controller.escolaridadeSelecionada!.id,
              mothersName: nomeMaeController.text,
              issuingUf: controller.ufSelecionado?.code,
            )
          );

          if (mounted) {
          FocusScope.of(context).unfocus();

          await controller.postBeneficiarios(beneficiarioAterPost);

          }
          else{
            ToastAvisosErro('Campos obrigatórios(*) não preenchidos');
          }
          
          }
          else{
            //Campos de registro obrigatórios não preenchidos
            ToastAvisosErro('Campos obrigatórios(*) em "Informações de Registro" não preenchidos');
          }
        }
        else{
          //Campos de informações gerais obrigatórios não preenchidos
          ToastAvisosErro('Campos obrigatórios(*) em "Informações Gerais" não preenchidos');
        }
      }
      else{
        //Campos de endereço obrigatórios não preenchidos
        ToastAvisosErro('Campos obrigatórios(*) em "Informações de Endereço" não preenchidos');
      }
    }
    else{
      //Campos de dados pessoais obrigatórios não preenchidos
      ToastAvisosErro('Campos obrigatórios(*) em "Informações Pessoais" não preenchidos');
    }
    
  }

  Widget errorWidget(){
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
}

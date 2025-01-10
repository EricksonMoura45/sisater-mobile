import 'package:esig_utils/size_screen.dart';
import 'package:esig_utils/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sisater_mobile/models/beneficiarios/beneficiario_ater.dart';
import 'package:sisater_mobile/models/beneficiarios/beneficiario_ater_post.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/categoria_atividade_produtiva.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/categoria_publico.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/comunidade.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/enq_caf.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/entidade_caf.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/escolaridade.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/estado_civil.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/motivo_registro.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/municipio.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/nacionalidade.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/naturalidade.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/produto.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/registro_status.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/sexo.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/subproduto.dart';
import 'package:sisater_mobile/models/beneficiarios/campos_selecionaveis/uf.dart';
import 'package:sisater_mobile/modules/beneficiario_ater/beneficiario_ater_controller.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';
import 'package:sisater_mobile/shared/utils/widgets/input_widget.dart';
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_erro.dart';

class EditarBeneficiarioPage extends StatefulWidget {
  const EditarBeneficiarioPage({super.key});

  @override
  State<EditarBeneficiarioPage> createState() => _EditarBeneficiarioPageState();
}
//Praticamente uma cópia do BeneficiariosAterPage, mas com os campos preenchidos com os dados do beneficiário selecionado
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
  final TextEditingController cepMaeController = TextEditingController();

  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController emailController = TextEditingController();     
  
  final TextEditingController cadastroNacionalController = TextEditingController();



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
    controller.editBeneficiarioAter(beneficiarioAter.id!);
    controller.carregaDadosSelecionaveis();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: formAppBar(context, 'Editar Beneficiários'),

      body: Observer(
        builder: (_){
          if(controller.statusCarregaDadosPagina == Status.AGUARDANDO){
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
        if(controller.statusCarregaDadosPagina == Status.CONCLUIDO){

          return Column(
          children: [
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 0, 2),
              child: Text('Todos os campos com obrigatórios devem ser preenchidos.(*)', 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: buildStepper(),
              ),
            ),
          ],
        );
        }

        if(controller.statusCarregaDadosPagina == Status.ERRO){

          return Center(child: Text('Erro ao carregar a página.'),);

        }

        else {

          return Center(child: Text('Erro ao carregar a página.'),);
          
        }  
        }, 
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
        child: botaoEditar(context)
      ),
    );
  }

  Widget buildStepper() {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(primary: Themes.verdeBotao),
      ),
      child: Stepper(
        physics: const ClampingScrollPhysics(),
        currentStep: currentStep,
        onStepTapped: (step) => setState(() => currentStep = step),
        onStepContinue: nextStep,
        onStepCancel: previousStep,
        type: StepperType.vertical,
        steps: [
          buildStep(
              title: 'Informações Pessoais', 
              content: formularioDadosPessoais()),
          buildStep(
              title: 'Informações de Endereço',
              content: formularioInformacoesEndereco()),
          buildStep(
              title: 'Informações de Contato',
              content: formularioinformacoesContato()),
          buildStep(
              title: 'Informações Gerais',
              content: formularioinformacoesGerais()),
          buildStep(
              title: 'Informações de Registro',
              content: formularioInformacoesRegistro()),    
        ],
        controlsBuilder: (context, details) => const SizedBox(),
      ),
    );
  }

  Step buildStep({required String title, required Widget content}) {
    return Step(
      isActive: currentStep >= 0,
      state: currentStep > 3 ? StepState.complete : StepState.indexed,
      title: Text(title),
      content: content,
    );
  }

  Widget formularioDadosPessoais() {

    nomeController.text = controller.beneficiarioAterEdit?.name ?? '';
    apelidoController.text = controller.beneficiarioAterEdit?.physicalPerson?.nickname ?? '';
    controller.sexoSelecionado = controller.listaSexo.firstWhere((element) => element.id == controller.beneficiarioAterEdit?.physicalPerson?.gender, orElse: () => Sexo(id: 0, name: ''));
    controller.estadoCivilSelecionado = controller.listaEstadoCivil.firstWhere((element) => element.id == controller.beneficiarioAterEdit?.physicalPerson?.civilStatus, orElse: () => EstadoCivil(id: 0, name: ''));
    controller.escolaridadeSelecionada = controller.listaEscolaridade.firstWhere((element) => element.id == controller.beneficiarioAterEdit?.physicalPerson?.scholarityId, orElse: () => Escolaridade(id: 0, name: ''));
    controller.nacionalidadeSelecionada = controller.listaNacionalidade.firstWhere((element) => element.id == controller.beneficiarioAterEdit?.physicalPerson?.nationalityId, orElse: () => Nacionalidade(id: 0, name: ''));
    controller.naturalidadeSelecionada = controller.listaNaturalidade.firstWhere((element) => element.id == controller.beneficiarioAterEdit?.physicalPerson?.naturalnessId, orElse: () => Naturalidade(id: 0, name: ''));
    controller.ufSelecionado = controller.listaUF.firstWhere((element) => element.name == controller.beneficiarioAterEdit?.physicalPerson?.issuingUf, orElse: () => UF(name: ''));
    dataNascimentoController.text = controller.beneficiarioAterEdit?.physicalPerson?.birthDate ?? '';
    cpfController.text = controller.beneficiarioAterEdit?.document ?? '';
    rgController.text = controller.beneficiarioAterEdit?.physicalPerson?.nationalityId.toString() ?? '';
    orgaoRGController.text = controller.beneficiarioAterEdit?.physicalPerson?.issuingEntity ?? '';
    nomeMaeController.text = controller.beneficiarioAterEdit?.physicalPerson?.mothersName ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        buildInputField(
          label: 'Nome*',
          controller: nomeController,
        ),
        buildInputField(
          label: 'Apelido',
          controller: apelidoController,
        ),

        Text('Sexo*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<Sexo>(
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
           value: controller.sexoSelecionado,
          items: controller.listaSexo.map(
            (e) => DropdownMenuItem<Sexo>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeSexoSelecionada
          ),
          SizedBox(height: 10,),

        buildInputField(
          label: 'Data de Nascimento*',
          controller: dataNascimentoController,
          formatters: [maskDataNascimento],
        ),
        buildInputField(
          label: 'CPF*',
          controller: cpfController,
          formatters: [maskCpf],
        ),

        Text('Estado Civil*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<EstadoCivil>(
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
           key: const ValueKey('estadoCivilDropdown'),
           isExpanded: true,
           value: controller.estadoCivilSelecionado,
          items: controller.listaEstadoCivil.map(
            (e) => DropdownMenuItem<EstadoCivil>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeEstadoCivilSelecionada
          ),
          SizedBox(height: 10,),

        buildInputField(
          label: 'RG',
          controller: rgController,
        ),
        buildInputField(
          label: 'Data de Emissão',
          controller: dataEmissaoController,
          formatters: [maskDataNascimento],
        ),
        buildInputField(
          label: 'Órgão de Emissão',
          controller: orgaoRGController,
        ),
        Text('Estado de Emissão',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<UF>(
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
           key: const ValueKey('ufDropdown'),
           isExpanded: true,
           value: controller.ufSelecionado,
          items: controller.listaUF.map(
            (e) => DropdownMenuItem<UF>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeUfSelecionada
          ),
          SizedBox(height: 10,),

        Text('Escolaridade*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<Escolaridade>(
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
           value: controller.escolaridadeSelecionada,
          items: controller.listaEscolaridade.map(
            (e) => DropdownMenuItem<Escolaridade>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeEscolaridadeSelecionada
          ),
          SizedBox(height: 10,),

          Text('Nacionalidade*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<Nacionalidade>(
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
           key: const ValueKey('nacionalioadeDropdown'),
           isExpanded: true,
           value: controller.nacionalidadeSelecionada,
          items: controller.listaNacionalidade.map(
            (e) => DropdownMenuItem<Nacionalidade>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeNacionalidadeSelecionada
          ),
          SizedBox(height: 10,),

          Text('Naturalidade*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<Naturalidade>(
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
           key: const ValueKey('NaturalidadeDropdown'),
           isExpanded: true,
           value: controller.naturalidadeSelecionada,
          items: controller.listaNaturalidade.map(
            (e) => DropdownMenuItem<Naturalidade>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeNaturalidadeSelecionada
          ),
          SizedBox(height: 10,),

        buildInputField(
          label: 'Nome da Mãe',
          controller: nomeMaeController,
        ),
      ],
    );
  }

  Widget formularioInformacoesEndereco() {

    lougradouroController.text = controller.beneficiarioAterEdit?.street ?? '';
    numeroController.text = controller.beneficiarioAterEdit?.number ?? '';
    controller.ufEnderecoSelecionado = controller.listaUF.firstWhere((element) => element.name == controller.beneficiarioAterEdit?.physicalPerson?.issuingUf, orElse: () => UF(name: ''));
    controller.municipioSelecionado = controller.municipioUF.firstWhere((element) => element.code == controller.beneficiarioAterEdit?.cityCode, orElse: () => Municipio(code: '', name: ''));
    controller.comunidadeSelecionada = controller.listaComunidade.firstWhere((element) => element.id == controller.beneficiarioAterEdit?.communityId, orElse: () => Comunidade(id: 0, name: ''));
    complementoController.text = controller.beneficiarioAterEdit?.complement ?? '';
    bairroController.text = controller.beneficiarioAterEdit?.neighborhood ?? '';
    cepMaeController.text = controller.beneficiarioAterEdit?.postalCode ?? '';

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
            if(controller.ufEnderecoSelecionado != null){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('Município*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<Municipio>(
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
           items: controller.municipioUF.map(
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
            else{
              return SizedBox();
            }
          }),

          buildInputField(
          label: 'CEP',
          controller: cepMaeController,
          formatters: [cepMask]
        ), 

         Text('Comunidade',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<Comunidade>(
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
           key: const ValueKey('municipiocomunidadeDropdown'),
           isExpanded: true,
           value: controller.comunidadeSelecionada,
          items: controller.listaComunidade.map(
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

  Widget formularioinformacoesContato() {

    telefoneController.text = controller.beneficiarioAterEdit?.phone ?? '';
    celularController.text = controller.beneficiarioAterEdit?.cellphone ?? '';
    emailController.text = controller.beneficiarioAterEdit?.email ?? '';

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

    controller.categoriaPublicoSelecionada = controller.listaCategoriaPublico.firstWhere((element) => element.id == controller.beneficiarioAterEdit?.targetPublicId, orElse: () => CategoriaPublico(id: 0, name: ''));
    //controller.categoriaAtividadeProdutivaSelecionada = controller.listaCategoriaAtividadeProdutiva.firstWhere((element) => element.id == controller.beneficiarioAterEdit?.productiveActivityCategoryId, orElse: () => CategoriaAtividadeProdutiva(id: 0, name: ''));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

         Text('Categoria de Público*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<CategoriaPublico>(
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

          Text('Produto',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<Produto>(
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

          Text('Subprodutos/Derivados',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<SubProduto>(
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

            // Wrap(
            //   spacing: 8.0,
            //   runSpacing: 4.0,
            //   children: controller.motivoRegistroSelecionadoLista!
            //       .map((item) => Chip(
            //             label: Text(item.name ?? ''),
            //             deleteIcon: Icon(Icons.close),
            //             onDeleted: () {
            //               setState(() {
            //                 controller.motivoRegistroSelecionadoLista!.remove(item);
            //               });
            //             },
            //           ))
            //       .toList(),
            // ),

      ],
    );
  }

  Widget formularioInformacoesRegistro (){

    controller.motivoRegistroSelecionado = controller.listaMotivoRegistro.firstWhere((element) => element.id.toString() == controller.beneficiarioAterEdit!.reasonMultiples.toString(), orElse: () => MotivoRegistro(id: 0, name: ''));
    controller.registroStatusSelecionado = controller.listaRegistroStatus.firstWhere((element) => element.id == controller.beneficiarioAterEdit!.registrationStatusId, orElse: () => RegistroStatus(id: 0, name: ''));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Text('Motivo Cadastro*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<MotivoRegistro>(
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

          Text('Situação Cadastro*',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<RegistroStatus>(
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
           value: controller.enqCaf,
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
           value: controller.entidadeCaf,
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
          ),
        ],
      ),
    );
  }

  void nextStep() {
    if (currentStep < 6) {
      setState(() {
        currentStep++;
      });
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  Widget botaoEditar(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.all(17),
      minWidth: SizeScreen.perWidth(context, 90),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      colorBrightness: Brightness.dark,
      color: Themes.verdeBotao,
      onPressed: () async {
        verificaCamposObrigatorios();
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
            else{
              return Text(
            'Confirmar Edição',
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

  void verificaCamposObrigatorios() async{
    
    if(nomeController.text != '' && controller.sexoSelecionado != null && dataNascimentoController.text != '' && cpfController.text != '' && controller.estadoCivilSelecionado != null && controller.escolaridadeSelecionada != null && controller.nacionalidadeSelecionada != null && controller.naturalidadeSelecionada != null){
      if(lougradouroController.text != '' && numeroController.text != '' && controller.ufEnderecoSelecionado != null){
        if(controller.categoriaPublicoSelecionada != null && controller.motivoRegistroSelecionado != null && controller.registroStatusSelecionado != null){
          //Apto para fazer POST

          beneficiarioAterPost = BeneficiarioAterPost(
            document: cpfController.text,
            name: nomeController.text,
            type: controller.sexoSelecionado!.id,
            street: lougradouroController.text,
            number: numeroController.text,
            complement: complementoController.text,
            neighborhood: bairroController.text,
            cityCode: controller.comunidadeSelecionada!.cityCode,
            postalCode: cepMaeController.text,
            phone: telefoneController.text,
            cellphone: celularController.text,
            email: emailController.text,
            communityId: controller.comunidadeSelecionada!.id,
            targetPublicId: controller.categoriaPublicoSelecionada!.id,
            hasDap: false, //MOCK
            nis: '', //MOCK
            dapId: controller.enqCaf!.id,
            dapOriginId: controller.entidadeCaf!.id,
            caf: cadastroNacionalController.text,
            reasonMultiples: ['${controller.motivoRegistroSelecionado!.id}'],
            officeId: 1, //MOCK
            registrationStatusId: 4,
            physicalPerson: PhysicalPerson(
              nickname: apelidoController.text,
              gender: controller.sexoSelecionado!.id,
              civilStatus: controller.estadoCivilSelecionado!.id,
              nationalityId: controller.nacionalidadeSelecionada!.id,
              nationalIdentity: rgController.text,
              naturalnessId: controller.naturalidadeSelecionada!.id,
              birthDate: dataNascimentoController.text,
              issuingEntity: orgaoRGController.text,
              issueDate: dataEmissaoController.text,
              scholarityId: controller.escolaridadeSelecionada!.id,
              mothersName: nomeMaeController.text
            )
          );

          await controller.postBeneficiarios(beneficiarioAterPost);

        }
      }
      else{
        //Campos de endereço obrigatórios não preenchidos
        ToastAvisosErro('Campos de endereço obrigatórios não preenchidos(*).');
      }
    }
    else{
      //Campos de dados pessoais obrigatórios não preenchidos
      ToastAvisosErro('Campos de dados pessoais obrigatórios não preenchidos(*).');
    }
    
  }
}
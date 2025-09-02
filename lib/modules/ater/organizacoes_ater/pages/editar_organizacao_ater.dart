import 'package:esig_utils/size_screen.dart';
import 'package:esig_utils/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/categoria_atividade_produtiva.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/categoria_publico.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/comunidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/motivo_registro.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/municipio.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/registro_status.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/uf.dart';
import 'package:sisater_mobile/models/comunidades/comunidade_selecionavel.dart';
import 'package:sisater_mobile/models/organizacoes_ater/campos_selecionaveis/tipo_organizacao.dart';
import 'package:sisater_mobile/models/organizacoes_ater/organizacao_ater_post.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/eslocs.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/widgets/build_input_field.dart';
import 'package:sisater_mobile/modules/ater/organizacoes_ater/organizacoes_ater_controller.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_erro.dart';

class EditarOrganizacaoAter extends StatefulWidget {
  const EditarOrganizacaoAter({super.key});

  @override
  State<EditarOrganizacaoAter> createState() => _EditarOrganizacaoAterState();
}

class _EditarOrganizacaoAterState extends State<EditarOrganizacaoAter> {

   int idOrganizaoAter = Modular.args.data ?? 0;

   OrganizacoesAterController controller = Modular.get();
  
  int currentStep = 0;
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController siglaController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController numeroAfiliadosController = TextEditingController();
  final TextEditingController nomeResponsavelController = TextEditingController();
  final TextEditingController logradouroController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController complementoController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController celularController = TextEditingController();

  final maskCnpj = MaskTextInputFormatter(
      mask: "##.###.###/####-##", filter: {"#": RegExp(r'[0-9]')});
  final maskDataNascimento = MaskTextInputFormatter(
      mask: "##/##/####", filter: {"#": RegExp(r'[0-9]')});

  final maskTelefone = MaskTextInputFormatter(
      mask: "(##)####-####", filter: {"#": RegExp(r'[0-9]')});

  final maskCelular = MaskTextInputFormatter(
      mask: "(##)#####-####", filter: {"#": RegExp(r'[0-9]')});

  final cepMask = MaskTextInputFormatter(
      mask: "#####-###", filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {

    controller.carregaOrganizacao(idOrganizaoAter).then((_) {
      setState(() {
        preencheDadosEdit();
         controller.statusCarregaOrganizacao = Status.CONCLUIDO;
      });
    });
    

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: formAppBar(context, 'Editar Organização', false, ''),
      body: Observer(
        builder: (_){

          if(controller.statusCarregaOrganizacao == Status.AGUARDANDO){
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
        if(controller.statusCarregaOrganizacao == Status.CONCLUIDO){

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
            Observer(builder: (_){
              return errorWidget();
                        }) 
          ],
        );
        }

        if(controller.statusCarregaOrganizacao == Status.ERRO){

          return Center(child: Text('Erro ao carregar a página.'),);

        }

        else {

          return Center(child: Text('Erro ao carregar a página.'),);
          
        }  
        }, 
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
        child: Observer(builder: (_){
           if(controller.statusCarregaOrganizacao == Status.CONCLUIDO){
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
              title: 'Informações Organizacionais', 
              content: formularioOrganizacionais()),
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

  Widget formularioOrganizacionais() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        buildInputField(
          label: 'Nome*',
          controller: nomeController,
        ),
        buildInputField(
          label: 'Sigla',
          controller: siglaController,
        ),

        buildInputField(
          label: 'CNPJ',
          controller: cnpjController,
          formatters: [maskCnpj],
        ),

        buildInputField(
          label: 'Número de afiliados',
          controller: numeroAfiliadosController,
        ),

        Text('Tipo de Organização',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<TipoOrganizacao>(
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
           key: const ValueKey('tipoOrgDropdown'),
           isExpanded: true,
           value: controller.tipoOrganizacaoSelecionada,
          items: controller.listaTiposOrganizacao.map(
            (e) => DropdownMenuItem<TipoOrganizacao>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeTipoOrganizacaoSelecionada
          ),
         SizedBox(height: 10,),

         buildInputField(
          label: 'Nome Responsável',
          controller: nomeResponsavelController,
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
          controller: logradouroController,
        ),
        buildInputField(
          label: 'Nº *',
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
           key: const ValueKey('ufEnderecoOrgDropdown'),
           isExpanded: true,
           value: controller.ufSelecionado,
           items: controller.listaUF.map(
            (e) => DropdownMenuItem<UF>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeUfEnderecoSelecionada
          ),
          SizedBox(height: 10,),

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

         buildInputField(
          label: 'CEP',
          controller: cepController,
        ),

        
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
        const SizedBox(height: 20),
        Text('Município da Comunidade',
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
           key: const ValueKey('ufMunOrgDropdown'),
           isExpanded: true,
           value: controller.municipioSelecionadoInfoGerais,
           items: controller.listaMunicipiosInfoGerais.map(
            (e) => DropdownMenuItem<ComunidadeSelecionavel>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeMunicipioInfoGeraisSelecionada
          ),
          SizedBox(height: 10,),

           Observer(builder: (_){

          if(controller.statusCarregaComunidades == Status.AGUARDANDO){
              return Center(child: CircularProgressIndicator(color: Themes.verdeBotao,),);
          }
          if(controller.statusCarregaComunidades == Status.CONCLUIDO){
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
           value: controller.comunidadeSelecionadaInfoGerais,
          items: controller.listaComunidades.map(
            (e) => DropdownMenuItem<Comunidade>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeComunidadeInfoGeraisSelecionada
          ),
          SizedBox(height: 10,),
            ],
           ); 
         }
         else{
           return SizedBox();
         }}),

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
           value: controller.categoriaPublicoSelecionado,
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
      ],
    );
  }

  Widget formularioInformacoesRegistro (){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
Text('Lotação (Eslocs)',
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
           key: const ValueKey('EslocsDropdown'),
           isExpanded: true,
           value: controller.eslocSelecionado,
          items: controller.listaEslocs.map(
            (e) => DropdownMenuItem<Eslocs>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeEslocSelecionada
          ),
          SizedBox(height: 10,),

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
          items: controller.listaMotivosRegistro.map(
            (e) => DropdownMenuItem<MotivoRegistro>(
              value: e,
              key: ValueKey(e.name),
              child: Text(e.name ?? 'Sem nome'),
              )).toList(), 
          onChanged: controller.changeMotivoSelecionado
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
          onChanged: controller.changeRegistroStatus
          ),
          SizedBox(height: 10,),
      ]
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
        verificaCamposObrigatorios();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Observer(builder: (_){

            if(controller.statusCadastrarOrganizacaoAter == Status.AGUARDANDO){
              return CircularProgressIndicator(
                color: Colors.white,
              );
            }
            else if(controller.statusCadastrarOrganizacaoAter == Status.ERRO){
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

   Widget errorWidget(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            controller.mensagemError,
            style: TextStyle(color: Colors.red),
            ),
        )
      ],
    );
  }
  
  void verificaCamposObrigatorios(){
    if(nomeController.text.isEmpty || nomeController.text == ''){
      ToastAvisosErro('Campos obrigatórios(*) em "Informações Organizacionais" não preenchidos');
    } else if (logradouroController.text.isEmpty || logradouroController.text == '' || numeroController.text.isEmpty || numeroAfiliadosController.text == '' || controller.ufSelecionado == null || controller.municipioSelecionado == null){
      ToastAvisosErro('Campos obrigatórios(*) em "Informações de Endereço" não preenchidos');
    } else if(controller.listaCategoriaPublico.isEmpty || controller.categoriaPublicoSelecionado == null){
      ToastAvisosErro('Campos obrigatórios(*) em "Informações Gerais" não preenchidos');
    } else if(controller.motivoRegistroSelecionado == null || controller.motivosRegistroSelecionados.isEmpty || controller.registroStatusSelecionado == null){
      ToastAvisosErro('Campos obrigatórios(*) em "Informações Gerais" não preenchidos');
    } else{
      
      controller.organizacaoPut(
        OrganizacaoAterPost(
          id: idOrganizaoAter,
          beneficiaryId: idOrganizaoAter,
          name: nomeController.text,
          document: cnpjController.text,
          street: logradouroController.text,
          number: numeroController.text,
          complement: complementoController.text,
          neighborhood: bairroController.text,
          postalCode: cepController.text,
          cityCode: controller.municipioSelecionado?.code,
          phone: telefoneController.text,
          cellphone: celularController.text,
          email: emailController.text, 
          communityId: controller.comunidadeSelecionadaInfoGerais?.id,
          targetPublicId: controller.categoriaPublicoSelecionado?.id,
          hasDap: 0,
          reasonMultiples: controller.motivosRegistroSelecionados.map((e) => e.id.toString()).toList(),
          officeId: controller.eslocSelecionado?.id,
          registrationStatusId: controller.registroStatusSelecionado?.id,
          type: controller.tipoOrganizacaoSelecionada?.id,
          socialOrganization: SocialOrganization(
            initials: siglaController.text,
            numberOfAffiliated: numeroAfiliadosController.text.isEmpty ? null : int.tryParse(numeroAfiliadosController.text),
            responsibleName: nomeResponsavelController.text,
            organizationTypeId: controller.tipoOrganizacaoSelecionada?.id,
          )

        ), 
        idOrganizaoAter
      );
    }
  }

  void preencheDadosEdit(){
     //Preenche os campos com os dados do beneficiário a ser editado
    
    nomeController.text = controller.editarOrganizacaoAter?.name ?? '';
    siglaController.text = controller.editarOrganizacaoAter?.socialOrganization?.initials ?? '';
    cnpjController.text = controller.editarOrganizacaoAter?.document ?? '';
    numeroAfiliadosController.text = controller.editarOrganizacaoAter?.socialOrganization?.numberOfAffiliated?.toString() ?? '';
    nomeResponsavelController.text = controller.editarOrganizacaoAter?.socialOrganization?.responsibleName ?? '';
    logradouroController.text = controller.editarOrganizacaoAter?.street ?? '';
    numeroController.text = controller.editarOrganizacaoAter?.number ?? '';
    complementoController.text = controller.editarOrganizacaoAter?.complement ?? '';
    bairroController.text = controller.editarOrganizacaoAter?.neighborhood ?? '';
    cepController.text = controller.editarOrganizacaoAter?.postalCode ?? '';
    telefoneController.text = controller.editarOrganizacaoAter?.phone ?? '';
    celularController.text = controller.editarOrganizacaoAter?.cellphone ?? '';
    emailController.text = controller.editarOrganizacaoAter?.email ?? '';

    
  }
}
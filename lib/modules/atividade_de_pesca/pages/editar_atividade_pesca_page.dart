import 'package:esig_utils/size_screen.dart';
import 'package:esig_utils/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/models/atividade_de_pesca/atividade_pesca.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/widgets/build_input_field.dart';
import 'package:sisater_mobile/modules/atividade_de_pesca/atividade_de_pesca_controller.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';

class EditarAtividadePescaPage extends StatefulWidget {
  const EditarAtividadePescaPage({super.key});

  @override
  State<EditarAtividadePescaPage> createState() => _EditarAtividadePescaPageState();
}

class _EditarAtividadePescaPageState extends State<EditarAtividadePescaPage> {
  AtividadePesca? atividadePescaGlobal = Modular.args.data;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AtividadeDePescaController controller = Modular.get();

  final nomeEmbarcacaoController = TextEditingController();
  final nomeAnteriorController = TextEditingController();
  final comprimentoController = TextEditingController();
  final bocaController = TextEditingController();
  final pontalController = TextEditingController();
  final tonLiquidaController = TextEditingController();
  final tonBrutaController = TextEditingController();
  final matCascoController = TextEditingController();
  final anoConstrucaoController = TextEditingController();
  final situacaoAtualController = TextEditingController();
  final tripulatesController = TextEditingController();
  final propulsaoController = TextEditingController();
  final inscCapitaniaController = TextEditingController();

  @override
  void initState() {
    preencherDadosEdit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      appBar: formAppBar(context, 'Editar Atividade de Pesca', false, ''),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 0, 2),
                child: Text(
                  'Todos os campos com obrigatórios devem ser preenchidos.(*)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(height: 20),
              buildFields(),
            ],
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
            if (formKey.currentState!.validate()) {
              FocusScope.of(context).unfocus();

              // Criar um novo objeto Fisherman com os dados editados
              final fishermanEditado = Fisherman(
                beneficiaryId: atividadePescaGlobal?.fisherman?.beneficiaryId,
                currentVesselName: nomeEmbarcacaoController.text,
                previousVesselName: nomeAnteriorController.text,
                length: int.tryParse(comprimentoController.text),
                beam: bocaController.text,
                depth: pontalController.text,
                netTon: tonLiquidaController.text,
                grossTon: tonBrutaController.text,
                hullMaterial: matCascoController.text,
                constructionYear: int.tryParse(anoConstrucaoController.text),
                currentStatus: situacaoAtualController.text,
                crewNumber: int.tryParse(tripulatesController.text),
                propulsion: propulsaoController.text,
                captaincyRegistration: inscCapitaniaController.text,
              );

              AtividadePesca atividadePescaPost = AtividadePesca(
                isFisherman: true,
                fisherman: fishermanEditado,
              );

              await controller.putAtividadePesca(atividadePescaPost, atividadePescaGlobal!.id!);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Observer(builder: (_) {
                if (controller.statusPostAtividadePesca == Status.AGUARDANDO) {
                  return CircularProgressIndicator(
                    color: Colors.white,
                  );
                } else {
                  return Text(
                    'Editar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFields() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Campo Município (somente visualização)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Município do Beneficiário',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Informação não disponível',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 20),

          // Campo Beneficiário (somente visualização)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Beneficiário',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'ID: ${atividadePescaGlobal?.fisherman?.beneficiaryId ?? 'Não informado'}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 20),

          // Campos da embarcação (editáveis)
          buildInputField(
            label: 'Nome atual da Embarcação',
            controller: nomeEmbarcacaoController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório.';
              }
              return null;
            },
          ),
          buildInputField(
            label: 'Nome anterior da Embarcação',
            controller: nomeAnteriorController,
          ),
          buildInputField(
            label: 'Comprimento (m)',
            controller: comprimentoController,
            inputType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório.';
              }
              return null;
            },
          ),
          buildInputField(
            label: 'Boca (m)',
            controller: bocaController,
            inputType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório.';
              }
              return null;
            },
          ),
          buildInputField(
            label: 'Pontal (m)',
            controller: pontalController,
            inputType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório.';
              }
              return null;
            },
          ),
          buildInputField(
            label: 'Tonelada Líquida (t)',
            controller: tonLiquidaController,
            inputType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório.';
              }
              return null;
            },
          ),
          buildInputField(
            label: 'Tonelada Bruta (t)',
            controller: tonBrutaController,
            inputType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório.';
              }
              return null;
            },
          ),
          buildInputField(
            label: 'Material do Casco',
            controller: matCascoController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório.';
              }
              return null;
            },
          ),
          buildInputField(
            label: 'Ano de Construção',
            controller: anoConstrucaoController,
            inputType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório.';
              }
              return null;
            },
          ),
          buildInputField(
            label: 'Situação Atual',
            controller: situacaoAtualController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório.';
              }
              return null;
            },
          ),
          buildInputField(
            label: 'Nº de tripulantes *',
            controller: tripulatesController,
            inputType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório.';
              }
              return null;
            },
          ),
          buildInputField(
            label: 'Propulsão',
            controller: propulsaoController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório.';
              }
              return null;
            },
          ),
          buildInputField(
            label: 'Inscrição na Capitania dos Portos',
            controller: inscCapitaniaController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório.';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  void preencherDadosEdit() {
    if (atividadePescaGlobal != null) {
      nomeEmbarcacaoController.text = atividadePescaGlobal!.fisherman?.currentVesselName ?? '';
      nomeAnteriorController.text = atividadePescaGlobal!.fisherman?.previousVesselName ?? '';
      comprimentoController.text = atividadePescaGlobal!.fisherman?.length?.toString() ?? '';
      bocaController.text = atividadePescaGlobal!.fisherman?.beam ?? '';
      pontalController.text = atividadePescaGlobal!.fisherman?.depth ?? '';
      tonLiquidaController.text = atividadePescaGlobal!.fisherman?.netTon ?? '';
      tonBrutaController.text = atividadePescaGlobal!.fisherman?.grossTon ?? '';
      matCascoController.text = atividadePescaGlobal!.fisherman?.hullMaterial ?? '';
      anoConstrucaoController.text = atividadePescaGlobal!.fisherman?.constructionYear?.toString() ?? '';
      situacaoAtualController.text = atividadePescaGlobal!.fisherman?.currentStatus ?? '';
      tripulatesController.text = atividadePescaGlobal!.fisherman?.crewNumber?.toString() ?? '';
      propulsaoController.text = atividadePescaGlobal!.fisherman?.propulsion ?? '';
      inscCapitaniaController.text = atividadePescaGlobal!.fisherman?.captaincyRegistration ?? '';
    }
  }
}
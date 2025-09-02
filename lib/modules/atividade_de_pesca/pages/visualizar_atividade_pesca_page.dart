import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/models/atividade_de_pesca/atividade_pesca.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';

class VisualizarAtividadePescaPage extends StatefulWidget {
  const VisualizarAtividadePescaPage({super.key});

  @override
  State<VisualizarAtividadePescaPage> createState() => _VisualizarAtividadePescaPageState();
}

class _VisualizarAtividadePescaPageState extends State<VisualizarAtividadePescaPage> {
  late AtividadePesca atividadeOriginal;

  @override
  void initState() {
    super.initState();
    atividadeOriginal = Modular.args.data as AtividadePesca;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      appBar: formAppBar(context, 'Visualizar Atividade de Pesca', false, ''),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 0, 2),
                child: Text(
                  'Dados da Atividade de Pesca',
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
          minWidth: double.infinity,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          colorBrightness: Brightness.dark,
          color: Themes.verdeBotao,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Voltar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFields() {
    return Column(
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
            'ID: ${atividadeOriginal.fisherman?.beneficiaryId ?? 'Não informado'}',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(height: 20),

        // Campos da embarcação (somente visualização)
        _buildReadOnlyField('Nome atual da Embarcação', atividadeOriginal.fisherman?.currentVesselName ?? 'Não informado'),
        _buildReadOnlyField('Nome anterior da Embarcação', atividadeOriginal.fisherman?.previousVesselName ?? 'Não informado'),
        _buildReadOnlyField('Comprimento (m)', atividadeOriginal.fisherman?.length?.toString() ?? 'Não informado'),
        _buildReadOnlyField('Boca (m)', atividadeOriginal.fisherman?.beam ?? 'Não informado'),
        _buildReadOnlyField('Pontal (m)', atividadeOriginal.fisherman?.depth ?? 'Não informado'),
        _buildReadOnlyField('Tonelada Líquida (t)', atividadeOriginal.fisherman?.netTon ?? 'Não informado'),
        _buildReadOnlyField('Tonelada Bruta (t)', atividadeOriginal.fisherman?.grossTon ?? 'Não informado'),
        _buildReadOnlyField('Material do Casco', atividadeOriginal.fisherman?.hullMaterial ?? 'Não informado'),
        _buildReadOnlyField('Ano de Construção', atividadeOriginal.fisherman?.constructionYear?.toString() ?? 'Não informado'),
        _buildReadOnlyField('Situação Atual', atividadeOriginal.fisherman?.currentStatus ?? 'Não informado'),
        _buildReadOnlyField('Nº de tripulantes', atividadeOriginal.fisherman?.crewNumber?.toString() ?? 'Não informado'),
        _buildReadOnlyField('Propulsão', atividadeOriginal.fisherman?.propulsion ?? 'Não informado'),
        _buildReadOnlyField('Inscrição na Capitania dos Portos', atividadeOriginal.fisherman?.captaincyRegistration ?? 'Não informado'),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
            value,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

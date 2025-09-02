import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/models/organizacoes_fater/organizacao_fater_list.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';

class EditarOrganizacaoFaterPage extends StatefulWidget {
  const EditarOrganizacaoFaterPage({super.key});

  @override
  State<EditarOrganizacaoFaterPage> createState() => _EditarOrganizacaoFaterPageState();
}

class _EditarOrganizacaoFaterPageState extends State<EditarOrganizacaoFaterPage> {
  late OrganizacaoFaterList organizacaoOriginal;
  final _formKey = GlobalKey<FormState>();
  
  // Controllers para os campos de texto
  late TextEditingController _nomeController;
  late TextEditingController _codigoController;
  late TextEditingController _anoController;
  late TextEditingController _dataAtendimentoController;

  @override
  void initState() {
    super.initState();
    organizacaoOriginal = Modular.args.data as OrganizacaoFaterList;
    
    // Inicializar controllers com os dados existentes
    _nomeController = TextEditingController(text: organizacaoOriginal.communities ?? '');
    _codigoController = TextEditingController(text: organizacaoOriginal.code?.toString() ?? '');
    _anoController = TextEditingController(text: organizacaoOriginal.year?.toString() ?? '');
    _dataAtendimentoController = TextEditingController(text: organizacaoOriginal.action_date ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _codigoController.dispose();
    _anoController.dispose();
    _dataAtendimentoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      appBar: formAppBar(context, 'Editar Organização FATER', true, ''),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoSection('Informações Básicas', [
                _buildTextField('Nome da Organização', _nomeController, 'Digite o nome da organização'),
                _buildTextField('Código', _codigoController, 'Digite o código', isNumber: true),
                _buildTextField('Ano', _anoController, 'Digite o ano', isNumber: true),
                _buildTextField('Data do Atendimento', _dataAtendimentoController, 'Digite a data do atendimento'),
              ]),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Themes.verdeBotao,
                  side: BorderSide(color: Themes.verdeBotao, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _salvarAlteracoes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Themes.verdeBotao,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Salvar',
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
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Themes.verdeBotao, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Este campo é obrigatório';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  void _salvarAlteracoes() {
    if (_formKey.currentState!.validate()) {
      // Aqui você implementaria a lógica para salvar as alterações
      // Por exemplo, chamar um método do controller para atualizar a organização
      
      // Mostrar mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Organização atualizada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Voltar para a página anterior
      Navigator.of(context).pop();
    }
  }
}

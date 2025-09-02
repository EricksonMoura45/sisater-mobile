import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sisater_mobile/modules/app_store.dart';
import 'package:sisater_mobile/modules/fater/beneficiario_fater/beneficiario_fater_controller.dart';
import 'package:sisater_mobile/modules/fater/beneficiario_fater/repository/beneficiario_fater_repository.dart';
import 'package:sisater_mobile/shared/utils/custom_dio.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:esig_utils/status.dart';

class OfflineCadastrarBeneficiarioFaterPage extends StatefulWidget {
  const OfflineCadastrarBeneficiarioFaterPage({super.key});

  @override
  State<OfflineCadastrarBeneficiarioFaterPage> createState() => _OfflineCadastrarBeneficiarioFaterPageState();
}

class _OfflineCadastrarBeneficiarioFaterPageState extends State<OfflineCadastrarBeneficiarioFaterPage> {
  final AppStore appStore = Modular.get<AppStore>();
  late final BeneficiarioFaterController controller;

  @override
  void initState() {
    super.initState();
    final repository = BeneficiarioFaterRepository(CustomDio().dio);
    controller = BeneficiarioFaterController(beneficiarioFaterRepository: repository);
    _carregarDadosOffline();
  }

  Future<void> _carregarDadosOffline() async {
    if (appStore.hasOfflineData) {
      // Carregar dados offline para o controller
      await controller.carregaDadosPagina();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Beneficiário FATER - Offline'),
        backgroundColor: Themes.verdeBotao,
        foregroundColor: Colors.white,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text(
                  'OFFLINE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (controller.statusCarregaDadosPagina == Status.AGUARDANDO) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Carregando dados offline...'),
                ],
              ),
            );
          }

          if (controller.statusCarregaDadosPagina == Status.ERRO) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar dados offline',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.mensagemError,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _carregarDadosOffline,
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Aviso offline
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange.shade600),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Esta página está funcionando no modo offline. Os dados serão salvos localmente e sincronizados quando a conexão for restaurada.',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Formulário simplificado para modo offline
                _buildFormularioOffline(),

                const SizedBox(height: 24),

                // Botão de salvar offline
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _salvarOffline(),
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar Offline'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Themes.verdeBotao,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Lista de cadastros offline
                if (appStore.offlineBeneficiarios.isNotEmpty) ...[
                  Text(
                    'Cadastros Offline Pendentes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildListaCadastrosOffline(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormularioOffline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Formulário de Cadastro',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 16),

        // Campo de descrição
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Descrição do Atendimento',
            border: OutlineInputBorder(),
            hintText: 'Descreva o atendimento realizado',
          ),
          maxLines: 3,
        ),

        const SizedBox(height: 16),

        // Campo de data
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Data do Atendimento',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          readOnly: true,
          onTap: () {
            // Mostrar date picker
            _showDatePicker();
          },
        ),

        const SizedBox(height: 16),

        // Campo de observações
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Observações',
            border: OutlineInputBorder(),
            hintText: 'Observações adicionais',
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildListaCadastrosOffline() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: appStore.offlineBeneficiarios.length,
      itemBuilder: (context, index) {
        final beneficiario = appStore.offlineBeneficiarios[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: beneficiario.isSynced ? Colors.green : Colors.orange,
              child: Icon(
                beneficiario.isSynced ? Icons.check : Icons.schedule,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Cadastro ${beneficiario.id.substring(0, 8)}...',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Criado em: ${_formatDate(beneficiario.createdAt)}'),
                Text(
                  beneficiario.isSynced ? 'Sincronizado' : 'Pendente sincronização',
                  style: TextStyle(
                    color: beneficiario.isSynced ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                if (!beneficiario.isSynced) ...[
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Excluir', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _editarCadastro(beneficiario);
                } else if (value == 'delete') {
                  _excluirCadastro(beneficiario.id);
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
  }

  void _editarCadastro(dynamic beneficiario) {
    // Implementar edição do cadastro offline
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade de edição será implementada'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _excluirCadastro(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja excluir este cadastro offline?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              appStore.deleteOfflineBeneficiario(id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cadastro excluído com sucesso'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _salvarOffline() {
    // Implementar salvamento offline
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade de salvamento será implementada'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

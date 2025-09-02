import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/agendamento/agendamento_controller.dart';
import 'package:sisater_mobile/models/agendamento/agendamento_lista.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:esig_utils/status.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';

class VisualizarAgendamentoPage extends StatefulWidget {
  const VisualizarAgendamentoPage({super.key});

  @override
  State<VisualizarAgendamentoPage> createState() => _VisualizarAgendamentoPageState();
}

class _VisualizarAgendamentoPageState extends State<VisualizarAgendamentoPage> {
  final AgendamentoController controller = Modular.get();
  late AgendamentoLista agendamentoOriginal;
  List<BeneficiarioAter> beneficiariosMapeados = [];

  @override
  void initState() {
    super.initState();
    agendamentoOriginal = Modular.args.data as AgendamentoLista;
    _carregarBeneficiarios();
  }

  Future<void> _carregarBeneficiarios() async {
    await controller.getBeneficiariosAterEsloc();
    if (mounted) {
      _mapearBeneficiarios();
    }
  }

  void _mapearBeneficiarios() {
    setState(() {
      beneficiariosMapeados.clear();
      
      // Tentar mapear usando beneficiarios (BeneficiarioAgendamento)
      if (agendamentoOriginal.beneficiarios != null && agendamentoOriginal.beneficiarios!.isNotEmpty) {
        beneficiariosMapeados = controller.beneficiariosAterEsloc.where((beneficiarioAter) =>
          agendamentoOriginal.beneficiarios!.any((beneficiarioAgendamento) => 
            beneficiarioAgendamento.id == beneficiarioAter.id
          )
        ).toList();
      }
      
      // Se não encontrou usando beneficiarios, tentar usando beneficiariesMultiples
      if (beneficiariosMapeados.isEmpty && agendamentoOriginal.beneficiariesMultiples != null && agendamentoOriginal.beneficiariesMultiples!.isNotEmpty) {
        beneficiariosMapeados = controller.beneficiariosAterEsloc.where((beneficiarioAter) =>
          agendamentoOriginal.beneficiariesMultiples!.contains(beneficiarioAter.id.toString())
        ).toList();
      }
    });
  }

  String _formatDate(String? date) {
    if (date == null) return '-';
    try {
      final d = DateTime.parse(date);
      return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    } catch (_) {
      return date;
    }
  }

  String _formatTime(String? time) {
    if (time == null) return '-';
    try {
      return time.substring(0, 5); // Mostrar apenas HH:MM
    } catch (_) {
      return time;
    }
  }

  Widget _buildBeneficiariosInfo() {
    if (beneficiariosMapeados.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Beneficiários:',
          style: TextStyle(
            fontWeight: FontWeight.w600, 
            fontSize: 14,
            color: Color(0xFF212529),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: beneficiariosMapeados.map((beneficiario) {
            return Container(
              constraints: const BoxConstraints(maxWidth: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Themes.corBaseApp.withOpacity(0.5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Text(
                  beneficiario.name ?? 'Nome não informado',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: formAppBar(
        context,
        'Visualizar Agendamento',
        false,
        null,
      ),
      body: Observer(
        builder: (_) {
          // Se ainda está carregando, mostrar loading
          if (controller.statusCarregaBeneficiarios == Status.AGUARDANDO) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Themes.verdeBotao),
                  SizedBox(height: 16),
                  Text('Carregando dados...'),
                ],
              ),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Informações do Agendamento',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 18,
                    color: Color(0xFF212529),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Campo Título
                const Text(
                  'Título',
                  style: TextStyle(
                    fontWeight: FontWeight.w600, 
                    fontSize: 14,
                    color: Color(0xFF212529),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: const Color(0xFFE9ECEF)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    agendamentoOriginal.title ?? 'Não informado',
                    style: const TextStyle(
                      color: Color(0xFF212529),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Campo Descrição
                const Text(
                  'Descrição',
                  style: TextStyle(
                    fontWeight: FontWeight.w600, 
                    fontSize: 14,
                    color: Color(0xFF212529),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: const Color(0xFFE9ECEF)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    agendamentoOriginal.description ?? 'Não informado',
                    style: const TextStyle(
                      color: Color(0xFF212529),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Campo Beneficiários
                const Text(
                  'Beneficiários',
                  style: TextStyle(
                    fontWeight: FontWeight.w600, 
                    fontSize: 14,
                    color: Color(0xFF212529),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: const Color(0xFFE9ECEF)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    beneficiariosMapeados.isNotEmpty 
                        ? beneficiariosMapeados.map((b) => b.name ?? 'Nome não informado').join(', ')
                        : 'Não informado',
                    style: const TextStyle(
                      color: Color(0xFF212529),
                      fontSize: 16,
                    ),
                  ),
                ),
                
                _buildBeneficiariosInfo(),
                
                // Campo Data da visita
                const Text(
                  'Data da visita',
                  style: TextStyle(
                    fontWeight: FontWeight.w600, 
                    fontSize: 14,
                    color: Color(0xFF212529),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: const Color(0xFFE9ECEF)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _formatDate(agendamentoOriginal.startDate),
                    style: const TextStyle(
                      color: Color(0xFF212529),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Campo Horário Inicial
                const Text(
                  'Horário Inicial',
                  style: TextStyle(
                    fontWeight: FontWeight.w600, 
                    fontSize: 14,
                    color: Color(0xFF212529),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: const Color(0xFFE9ECEF)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _formatTime(agendamentoOriginal.startTime),
                    style: const TextStyle(
                      color: Color(0xFF212529),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Campo Horário Final
                const Text(
                  'Horário Final',
                  style: TextStyle(
                    fontWeight: FontWeight.w600, 
                    fontSize: 14,
                    color: Color(0xFF212529),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: const Color(0xFFE9ECEF)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _formatTime(agendamentoOriginal.endTime),
                    style: const TextStyle(
                      color: Color(0xFF212529),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Campo Status
                const Text(
                  'Status',
                  style: TextStyle(
                    fontWeight: FontWeight.w600, 
                    fontSize: 14,
                    color: Color(0xFF212529),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: const Color(0xFFE9ECEF)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(agendamentoOriginal.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(agendamentoOriginal.status),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE9ECEF), width: 1),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Themes.verdeBotao,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Voltar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getStatusText(String? status) {
    if (status == null) return 'Não informado';
    switch (status.toLowerCase()) {
      case 'pendente':
        return 'Pendente';
      case 'confirmado':
        return 'Concluído';
      default:
        return status;
    }
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Themes.cinzaTexto;
    switch (status.toLowerCase()) {
      case 'pendente':
        return Colors.orange;
      case 'confirmado':
        return Colors.green;
      default:
        return Themes.cinzaTexto;
    }
  }
}

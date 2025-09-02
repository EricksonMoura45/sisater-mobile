import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/agendamento/agendamento_controller.dart';
import 'package:sisater_mobile/models/agendamento/agendamento_lista.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:esig_utils/status.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_erro.dart';
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_sucesso.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';

class EditarAgendamentoPage extends StatefulWidget {
  const EditarAgendamentoPage({super.key});

  @override
  State<EditarAgendamentoPage> createState() => _EditarAgendamentoPageState();
}

class _EditarAgendamentoPageState extends State<EditarAgendamentoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  String? dataVisita;
  String? horarioInicial;
  String? horarioFinal;
  List<BeneficiarioAter> beneficiariosSelecionados = [];

  final AgendamentoController controller = Modular.get();
  late AgendamentoLista agendamentoOriginal;

  @override
  void initState() {
    super.initState();
    agendamentoOriginal = Modular.args.data as AgendamentoLista;
    _carregarBeneficiarios();
    _preencherCampos();
  }

  void _preencherCampos() {
    tituloController.text = agendamentoOriginal.title ?? '';
    descricaoController.text = agendamentoOriginal.description ?? '';
    if (agendamentoOriginal.startDate != null) {
      try {
        final dt = DateTime.parse(agendamentoOriginal.startDate!);
        dataVisita = DateFormat('dd/MM/yyyy').format(dt);
      } catch (_) {
        dataVisita = agendamentoOriginal.startDate;
      }
    }
    
    // Validar e definir horários
    horarioInicial = agendamentoOriginal.startTime;
    horarioFinal = agendamentoOriginal.endTime;
    
    // Tentar preencher campos do beneficiário se já temos os dados
    _preencherCamposBeneficiario();
  }
  
  void _preencherCamposBeneficiario() {
    print('=== DEBUG: Preenchendo campos do beneficiário ===');
    print('Beneficiários no agendamento: ${agendamentoOriginal.beneficiarios?.length ?? 0}');
    
    // Se temos beneficiários no agendamento, tentar preencher os campos
    if (agendamentoOriginal.beneficiarios != null && agendamentoOriginal.beneficiarios!.isNotEmpty) {
      final beneficiarioAgendamento = agendamentoOriginal.beneficiarios!.first;
      print('Nome do beneficiário: ${beneficiarioAgendamento.nome}');
      // Os beneficiários serão mapeados quando a lista for carregada
    } else {
      print('Nenhum beneficiário encontrado no agendamento');
    }
    print('=== FIM DEBUG ===');
  }

  Future<void> _carregarBeneficiarios() async {
    await controller.getBeneficiariosAterEsloc();
    if (mounted) {
      _mapearBeneficiarios();
    }
  }

  void _mapearBeneficiarios() {
    setState(() {
      beneficiariosSelecionados.clear(); // Limpar seleção anterior
      
      // Debug: verificar estrutura dos dados
      print('=== DEBUG MAPPING BENEFICIÁRIOS ===');
      print('Agendamento ID: ${agendamentoOriginal.id}');
      print('Beneficiários (BeneficiarioAgendamento): ${agendamentoOriginal.beneficiarios?.map((b) => '${b.id}: ${b.nome}').toList()}');
      print('Beneficiaries Multiples (String): ${agendamentoOriginal.beneficiariesMultiples}');
      print('Beneficiários disponíveis: ${controller.beneficiariosAterEsloc.map((b) => '${b.id}: ${b.name}').toList()}');
      
      // Tentar mapear usando beneficiarios (BeneficiarioAgendamento)
      if (agendamentoOriginal.beneficiarios != null && agendamentoOriginal.beneficiarios!.isNotEmpty) {
        print('Tentando mapear usando beneficiarios...');
        beneficiariosSelecionados = controller.beneficiariosAterEsloc.where((beneficiarioAter) =>
          agendamentoOriginal.beneficiarios!.any((beneficiarioAgendamento) => 
            beneficiarioAgendamento.id == beneficiarioAter.id
          )
        ).toList();
        print('Resultado mapeamento beneficiarios: ${beneficiariosSelecionados.map((b) => '${b.id}: ${b.name}').toList()}');
      }
      
      // Se não encontrou usando beneficiarios, tentar usando beneficiariesMultiples
      if (beneficiariosSelecionados.isEmpty && agendamentoOriginal.beneficiariesMultiples != null && agendamentoOriginal.beneficiariesMultiples!.isNotEmpty) {
        print('Tentando mapear usando beneficiariesMultiples...');
        beneficiariosSelecionados = controller.beneficiariosAterEsloc.where((beneficiarioAter) =>
          agendamentoOriginal.beneficiariesMultiples!.contains(beneficiarioAter.id.toString())
        ).toList();
        print('Resultado mapeamento beneficiariesMultiples: ${beneficiariosSelecionados.map((b) => '${b.id}: ${b.name}').toList()}');
      }
      
      print('Beneficiários selecionados finais: ${beneficiariosSelecionados.map((b) => '${b.id}: ${b.name}').toList()}');
      print('=== FIM DEBUG ===');
      
      // Os beneficiários já estão mapeados na lista beneficiariosSelecionados
      // Não precisamos preencher campos individuais pois usaremos o dropdown
      
      // Forçar rebuild da UI para mostrar os campos preenchidos
      if (mounted) {
        setState(() {});
      }
    });
  }

  List<String> _gerarHorarios() {
    List<String> lista = [];
    final inicio = TimeOfDay(hour: 8, minute: 0);
    final fim = TimeOfDay(hour: 18, minute: 0); // Extendido para 18:00
    var atual = inicio;
    while (atual.hour < fim.hour || (atual.hour == fim.hour && atual.minute <= fim.minute)) {
      final hora = atual.hour.toString().padLeft(2, '0');
      final minuto = atual.minute.toString().padLeft(2, '0');
      lista.add('$hora:$minuto:00');
      int minutos = atual.minute + 30;
      int horas = atual.hour + (minutos ~/ 60);
      minutos = minutos % 60;
      atual = TimeOfDay(hour: horas, minute: minutos);
    }
    
    // Adicionar os horários específicos do agendamento se não estiverem na lista
    if (horarioInicial != null && !lista.contains(horarioInicial)) {
      lista.add(horarioInicial!);
    }
    if (horarioFinal != null && !lista.contains(horarioFinal)) {
      lista.add(horarioFinal!);
    }
    
    // Ordenar a lista
    lista.sort();
    
    return lista;
  }

  void _toggleBeneficiario(BeneficiarioAter beneficiario) {
    setState(() {
      if (beneficiariosSelecionados.contains(beneficiario)) {
        beneficiariosSelecionados.remove(beneficiario);
      } else {
        beneficiariosSelecionados.add(beneficiario);
      }
    });
  }

  Widget _buildBeneficiariosSelecionados() {
    if (beneficiariosSelecionados.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Beneficiários selecionados:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: beneficiariosSelecionados.map((beneficiario) {
            return Container(
              constraints: const BoxConstraints(maxWidth: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Themes.corBaseApp.withOpacity(0.5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        beneficiario.name ?? 'Nome não informado',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _toggleBeneficiario(beneficiario),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _selecionarData() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('pt', 'BR'),
    );
    setState(() {
      dataVisita = DateFormat('dd/MM/yyyy').format(picked!);
    });
  }

  String? _gerarDataHora(String? data, String? hora) {
    if (data == null || hora == null) return null;
    try {
      final partesData = data.split('/');
      final partesHora = hora.split(':');
      final dt = DateTime(
        int.parse(partesData[2]),
        int.parse(partesData[1]),
        int.parse(partesData[0]),
        int.parse(partesHora[0]),
        int.parse(partesHora[1]),
      );
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final horarios = _gerarHorarios();
    
    // Validar se os horários selecionados estão na lista
    if (horarioInicial != null && !horarios.contains(horarioInicial)) {
      horarioInicial = null;
    }
    if (horarioFinal != null && !horarios.contains(horarioFinal)) {
      horarioFinal = null;
    }
    
    return Scaffold(
      appBar: formAppBar(
        context,
        'Editar agendamento',
        false,
        null,
      ),
      body: Observer(
        builder: (_) {
          // Mapear beneficiários quando estiverem carregados
          if (controller.statusCarregaBeneficiarios == Status.CONCLUIDO && beneficiariosSelecionados.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              print('Observer detectou beneficiários carregados, mapeando...');
              _mapearBeneficiarios();
            });
          }
          
          // Se ainda está carregando, mostrar loading
          if (controller.statusCarregaBeneficiarios == Status.AGUARDANDO) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Themes.verdeBotao),
                  SizedBox(height: 16),
                  Text('Carregando beneficiários...'),
                ],
              ),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
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
                  const SizedBox(height: 4),
                  RichText(
                    text: const TextSpan(
                      text: '*Todos os campos obrigatórios devem ser preenchidos.',
                      style: TextStyle(
                        fontSize: 12, 
                        color: Colors.red,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Campo Título
                  const Text(
                    'Título *',
                    style: TextStyle(
                      fontWeight: FontWeight.w600, 
                      fontSize: 14,
                      color: Color(0xFF212529),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: tituloController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF007BFF)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF212529),
                      fontSize: 16,
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Campo Descrição
                  const Text(
                    'Descrição *',
                    style: TextStyle(
                      fontWeight: FontWeight.w600, 
                      fontSize: 14,
                      color: Color(0xFF212529),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: descricaoController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF007BFF)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF212529),
                      fontSize: 16,
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Campo Beneficiários
                  const Text(
                    'Beneficiários *',
                    style: TextStyle(
                      fontWeight: FontWeight.w600, 
                      fontSize: 14,
                      color: Color(0xFF212529),
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: beneficiariosSelecionados.isNotEmpty ? beneficiariosSelecionados.first.id.toString() : null,
                    items: controller.beneficiariosAterEsloc.map((beneficiario) => DropdownMenuItem(
                      value: beneficiario.id.toString(),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          beneficiario.name ?? 'Nome não informado',
                          style: const TextStyle(
                            color: Color(0xFF212529),
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    )).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        final beneficiario = controller.beneficiariosAterEsloc.firstWhere(
                          (b) => b.id.toString() == value,
                        );
                        setState(() {
                          beneficiariosSelecionados = [beneficiario];
                        });
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF007BFF)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF6C757D),
                      ),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF212529),
                      fontSize: 16,
                    ),
                    validator: (v) => beneficiariosSelecionados.isEmpty ? 'Campo obrigatório' : null,
                    isExpanded: true,
                  ),
                  const SizedBox(height: 16),
                  
                  _buildBeneficiariosSelecionados(),
                  
                  // Campo Data da visita
                  const Text(
                    'Data da visita*',
                    style: TextStyle(
                      fontWeight: FontWeight.w600, 
                      fontSize: 14,
                      color: Color(0xFF212529),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _selecionarData,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF007BFF)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            color: Color(0xFF6C757D),
                          ),
                        ),
                        controller: TextEditingController(text: dataVisita ?? ''),
                        style: const TextStyle(
                          color: Color(0xFF212529),
                          fontSize: 16,
                        ),
                        validator: (v) => (dataVisita == null || dataVisita!.isEmpty) ? 'Campo obrigatório' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Campo Horário Inicial
                  const Text(
                    'Horário Inicial *',
                    style: TextStyle(
                      fontWeight: FontWeight.w600, 
                      fontSize: 14,
                      color: Color(0xFF212529),
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: horarioInicial,
                    items: horarios.map((h) => DropdownMenuItem(
                      value: h, 
                      child: Text(
                        h.substring(0, 5), // Mostrar apenas HH:MM
                        style: const TextStyle(
                          color: Color(0xFF212529),
                          fontSize: 16,
                        ),
                      )
                    )).toList(),
                    onChanged: (v) => setState(() => horarioInicial = v),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF007BFF)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF6C757D),
                      ),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF212529),
                      fontSize: 16,
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Campo Horário Final
                  const Text(
                    'Horário Final *',
                    style: TextStyle(
                      fontWeight: FontWeight.w600, 
                      fontSize: 14,
                      color: Color(0xFF212529),
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: horarioFinal,
                    items: horarios.map((h) => DropdownMenuItem(
                      value: h, 
                      child: Text(
                        h.substring(0, 5), // Mostrar apenas HH:MM
                        style: const TextStyle(
                          color: Color(0xFF212529),
                          fontSize: 16,
                        ),
                      )
                    )).toList(),
                    onChanged: (v) => setState(() => horarioFinal = v),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF007BFF)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF6C757D),
                      ),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF212529),
                      fontSize: 16,
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
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
                onPressed: controller.statusEditarAgendamento == Status.AGUARDANDO
                    ? null
                    : () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final agendamentoEditado = AgendamentoLista(
                            id: agendamentoOriginal.id,
                            title: tituloController.text.isNotEmpty ? tituloController.text : 'Visita Técnica',
                            description: descricaoController.text.isNotEmpty ? descricaoController.text : 'Visita técnica agendada',
                            startDate: _gerarDataHora(dataVisita, horarioInicial),
                            endDate: _gerarDataHora(dataVisita, horarioFinal),
                            startTime: horarioInicial,
                            endTime: horarioFinal,
                            userId: agendamentoOriginal.userId,
                            beneficiariesMultiples: beneficiariosSelecionados.map((b) => b.id.toString()).toList(),
                          );
                          controller.editarAgendamento(
                            agendamentoOriginal.id!,
                            agendamentoEditado,
                            () {
                              ToastAvisosSucesso('Agendamento atualizado com sucesso!');
                              Future.delayed(const Duration(milliseconds: 1500), () {
                                Modular.to.pop();
                                controller.getAgendamentos();
                              });
                            },
                            (erro) {
                              ToastAvisosErro(erro);
                            },
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF28A745),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: controller.statusEditarAgendamento == Status.AGUARDANDO
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text(
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
}
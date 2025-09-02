import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/agendamento/agendamento_controller.dart';
import 'package:sisater_mobile/models/agendamento/agendamento_lista.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater.dart';
import 'package:sisater_mobile/models/atendimento/chat_card.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:esig_utils/status.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';

class AgendarVisita extends StatefulWidget {
  const AgendarVisita({super.key});

  @override
  State<AgendarVisita> createState() => _AgendarVisitaState();
}

class _AgendarVisitaState extends State<AgendarVisita> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  String? dataVisita;
  String? horarioInicial;
  String? horarioFinal;
  List<BeneficiarioAter> beneficiariosSelecionados = [];
  ChatCard? chatRecebido;

  final AgendamentoController controller = Modular.get();

  List<String> _gerarHorarios() {
    List<String> lista = [];
    final inicio = TimeOfDay(hour: 8, minute: 0);
    final fim = TimeOfDay(hour: 17, minute: 0);
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
    return lista;
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

  void _toggleBeneficiario(BeneficiarioAter beneficiario) {
    setState(() {
      if (beneficiariosSelecionados.contains(beneficiario)) {
        beneficiariosSelecionados.remove(beneficiario);
      } else {
        beneficiariosSelecionados.add(beneficiario);
      }
    });
  }

  void _abrirSelecaoBeneficiarios() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Selecione os Beneficiários',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (beneficiariosSelecionados.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                beneficiariosSelecionados.clear();
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
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.beneficiariosAterEsloc.length,
                      itemBuilder: (BuildContext context, int index) {
                        // Ordenar beneficiários alfabeticamente por nome
                        final beneficiariosOrdenados = List<BeneficiarioAter>.from(controller.beneficiariosAterEsloc)
                          ..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
                        
                        final beneficiario = beneficiariosOrdenados[index];
                        final isSelected = beneficiariosSelecionados.any((b) => b.id == beneficiario.id);
                        return ListTile(
                          title: Text(
                            beneficiario.name ?? 'Nome não informado',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          leading: Checkbox(
                            value: isSelected,
                            activeColor: const Color(0xFF28A745),
                            onChanged: (bool? newValue) {
                              setState(() {
                                if (newValue!) {
                                  if (!beneficiariosSelecionados.any((b) => b.id == beneficiario.id)) {
                                    beneficiariosSelecionados.add(beneficiario);
                                  }
                                } else {
                                  beneficiariosSelecionados.removeWhere((b) => b.id == beneficiario.id);
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
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
                              // Atualizar o estado da página principal
                              this.setState(() {});
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

  @override
  void initState() {
    super.initState();
    _carregarBeneficiarios();
  }

  Future<void> _carregarBeneficiarios() async {
    // Verificar se recebeu um chat como argumento
    chatRecebido = Modular.args.data as ChatCard?;
    
    await controller.getBeneficiariosAterEsloc();
    if (mounted) {
      setState(() {});
      
      // Se recebeu um chat, tentar preencher automaticamente o beneficiário
      if (chatRecebido != null && chatRecebido!.creatorId != null) {
        _tentarPreencherBeneficiarioAutomaticamente();
      }
    }
  }

  void _tentarPreencherBeneficiarioAutomaticamente() {
    // Verificar se os beneficiários foram carregados
    if (controller.statusCarregaBeneficiarios != Status.CONCLUIDO) {
      print('Beneficiários ainda não foram carregados, tentando novamente em 200ms...');
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _tentarPreencherBeneficiarioAutomaticamente();
        }
      });
      return;
    }
    
    _preencherBeneficiarioAutomaticamente();
  }

  void _preencherBeneficiarioAutomaticamente() {
    if (chatRecebido?.creatorId == null) return;
    
    print('Tentando preencher beneficiário automaticamente para creatorId: ${chatRecebido!.creatorId}');
    print('Beneficiários disponíveis: ${controller.beneficiariosAterEsloc.length}');
    
    // Procurar o beneficiário que corresponde ao creatorId do chat
    final beneficiarioEncontrado = controller.beneficiariosAterEsloc
        .where((beneficiario) => beneficiario.id == chatRecebido!.creatorId)
        .firstOrNull;
    
    if (beneficiarioEncontrado != null) {
      setState(() {
        beneficiariosSelecionados = [beneficiarioEncontrado];
      });
      print('Beneficiário preenchido automaticamente: ${beneficiarioEncontrado.name} (ID: ${beneficiarioEncontrado.id})');
    } else {
      print('Nenhum beneficiário encontrado para o creatorId: ${chatRecebido!.creatorId}');
      print('IDs disponíveis: ${controller.beneficiariosAterEsloc.map((b) => b.id).toList()}');
      
      // Tentar buscar por nome do beneficiário se disponível no chat
      if (chatRecebido!.beneficiario != null && chatRecebido!.beneficiario!.isNotEmpty) {
        final beneficiarioPorNome = controller.beneficiariosAterEsloc
            .where((beneficiario) => 
                beneficiario.name?.toLowerCase().contains(chatRecebido!.beneficiario!.toLowerCase()) == true ||
                chatRecebido!.beneficiario!.toLowerCase().contains(beneficiario.name?.toLowerCase() ?? ''))
            .firstOrNull;
        
        if (beneficiarioPorNome != null) {
          setState(() {
            beneficiariosSelecionados = [beneficiarioPorNome];
          });
          print('Beneficiário encontrado por nome: ${beneficiarioPorNome.name} (ID: ${beneficiarioPorNome.id})');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final horarios = _gerarHorarios();
    
    return Scaffold(
      appBar: formAppBar(
        context,
        'Agendamento de visita técnica',
        false,
        null,
      ),
      body: Observer(
        builder: (_) {
          // Debug: verificar status
          print('Status carrega beneficiários: ${controller.statusCarregaBeneficiarios}');
          print('Quantidade de beneficiários: ${controller.beneficiariosAterEsloc.length}');
          
          // Mostrar shimmer apenas se estiver aguardando
          if (controller.statusCarregaBeneficiarios == Status.AGUARDANDO) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  children: List.generate(8, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        height: 60,
                        width: double.infinity,
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

          // Mostrar erro se houver problema
          if (controller.statusCarregaBeneficiarios == Status.ERRO) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Erro ao carregar beneficiários'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _carregarBeneficiarios();
                    },
                    child: const Text('Tentar novamente', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          // Se chegou até aqui, mostrar o formulário (mesmo se não há beneficiários)
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
                  GestureDetector(
                    onTap: () => _abrirSelecaoBeneficiarios(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: beneficiariosSelecionados.isEmpty 
                              ? const Color(0xFFE9ECEF)
                              : const Color(0xFF28A745),
                          width: beneficiariosSelecionados.isEmpty ? 1 : 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  beneficiariosSelecionados.isEmpty
                                      ? 'Selecione os beneficiários'
                                      : '${beneficiariosSelecionados.length} beneficiário(s) selecionado(s)',
                                  style: TextStyle(
                                    color: beneficiariosSelecionados.isEmpty
                                        ? const Color(0xFF6C757D)
                                        : const Color(0xFF212529),
                                    fontSize: 16,
                                  ),
                                ),
                                if (beneficiariosSelecionados.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    beneficiariosSelecionados.map((b) => b.name ?? 'Nome não informado').join(', '),
                                    style: const TextStyle(
                                      color: Color(0xFF6C757D),
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Icon(
                            beneficiariosSelecionados.isNotEmpty 
                                ? Icons.check_circle
                                : Icons.keyboard_arrow_down,
                            color: beneficiariosSelecionados.isNotEmpty 
                                ? const Color(0xFF28A745)
                                : const Color(0xFF6C757D),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Mensagem de validação
                  if (beneficiariosSelecionados.isEmpty) ...[
                    const SizedBox(height: 4),
                    const Text(
                      'Campo obrigatório',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ],
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
                  const SizedBox(height: 24),
                  
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
                  'Voltar',
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
                onPressed: controller.statusAgendarVisita == Status.AGUARDANDO
                    ? null
                    : () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          final currentContext = context;
                          final agendamento = AgendamentoLista(
                            title: tituloController.text.isNotEmpty ? tituloController.text : 'Visita Técnica',
                            description: descricaoController.text.isNotEmpty ? descricaoController.text : 'Visita técnica agendada',
                            startDate: _gerarDataHora(dataVisita, horarioInicial),
                            endDate: _gerarDataHora(dataVisita, horarioFinal),
                            userId: controller.appStore.usuarioDados?.id,
                            startTime: horarioInicial,
                            endTime: horarioFinal,
                            beneficiariesMultiples: beneficiariosSelecionados.map((b) => b.id.toString()).toList(),
                            chatId: chatRecebido?.id, // Adicionar chat_id se veio de um chat
                          );
                          final sucesso = await controller.agendarVisita(
                            agendamento,
                            veioDoChat: chatRecebido != null, // Indicar se veio do chat
                          );
                          
                          if (sucesso && mounted) {
                            // Se veio do chat, retornar true para atualizar mensagens
                            if (chatRecebido != null) {
                              Navigator.of(currentContext).pop(true);
                            } else {
                              // Se não veio do chat, retornar true para indicar que deve atualizar
                              Navigator.of(currentContext).pop(true);
                            }
                          }
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
                child: controller.statusAgendarVisita == Status.AGUARDANDO
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text(
                        'Agendar',
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
}
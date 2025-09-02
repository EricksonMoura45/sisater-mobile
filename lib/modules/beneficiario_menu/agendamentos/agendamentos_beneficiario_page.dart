import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/beneficiario_menu/beneficiario_controller.dart';
import 'package:sisater_mobile/shared/utils/widgets/custom_card_widget.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:esig_utils/status.dart';
import 'package:shimmer/shimmer.dart';

class AgendamentosBeneficiarioPage extends StatefulWidget {
  const AgendamentosBeneficiarioPage({super.key});

  @override
  State<AgendamentosBeneficiarioPage> createState() => _AgendamentosBeneficiarioPageState();
}

class _AgendamentosBeneficiarioPageState extends State<AgendamentosBeneficiarioPage> {
  final BeneficiarioController controller = Modular.get();

  String filtroSelecionado = 'todos';
  String pesquisa = '';
  final TextEditingController pesquisaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.getAgendamentos();
  }

  List<dynamic> getAgendamentosFiltrados() {
    List<dynamic> filtrados = filtroSelecionado == 'todos'
        ? controller.agendamentos
        : controller.agendamentos.where((agendamento) => 
            agendamento.status?.toLowerCase() == filtroSelecionado.toLowerCase()
          ).toList();
    
    if (pesquisa.isNotEmpty) {
      filtrados = filtrados.where((agendamento) => 
        (agendamento.title ?? '').toLowerCase().contains(pesquisa.toLowerCase()) ||
        (agendamento.description ?? '').toLowerCase().contains(pesquisa.toLowerCase())
      ).toList();
    }
    
    filtrados.sort((a, b) {
      DateTime? dataA = a.startDate != null ? DateTime.tryParse(a.startDate!) : null;
      DateTime? dataB = b.startDate != null ? DateTime.tryParse(b.startDate!) : null;
      if (dataA == null && dataB == null) return 0;
      if (dataA == null) return 1;
      if (dataB == null) return -1;
      return dataB.compareTo(dataA);
    });
    
    return filtrados;
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      leading: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Themes.verdeBotao,
          ),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.keyboard_arrow_left,
                size: 32, color: Colors.white),
          ),
        ),
        onTap: () {
          Modular.to.pop();
        }
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTitulo(context, 'Meus agendamentos'),
        ],
      ),      
    );
  }

  Widget _buildTitulo(BuildContext context, String titulo) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: Text(
        titulo,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: MediaQuery.of(context).size.width / 20,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  String _getMensagemVazio() {
    switch (filtroSelecionado) {
      case 'todos':
        return 'Nenhum agendamento encontrado';
      case 'pendente':
        return 'Nenhum agendamento pendente';
      case 'Confirmado':
        return 'Nenhum agendamento concluído';
      default:
        return 'Nenhum agendamento encontrado';
    }
  }

  String _getMensagemSubtitulo() {
    switch (filtroSelecionado) {
      case 'todos':
        return 'Você ainda não possui agendamentos';
      case 'pendente':
        return 'Não há agendamentos aguardando confirmação';
      case 'confirmado':
        return 'Não há agendamentos finalizados';
      default:
        return 'Você ainda não possui agendamentos';
    }
  }

  Widget _buildFiltroBalao(String valor, String texto) {
    final bool selecionado = filtroSelecionado == valor;
    return GestureDetector(
      onTap: () {
        setState(() {
          filtroSelecionado = valor;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selecionado ? Themes.verdeBotao : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          texto,
          style: TextStyle(
            color: selecionado ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      appBar: _buildAppBar(context),
      body: Observer(
        builder: (_) {
          if (controller.statusCarregaAgendamentos == Status.AGUARDANDO) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  children: List.generate(5, (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )),
                ),
              ),
            );
          }
          if (controller.statusCarregaAgendamentos == Status.ERRO) {
            return Center(child: Text(controller.errorMessage ?? 'Erro ao carregar agendamentos'));
          }
          if (controller.statusCarregaAgendamentos == Status.CONCLUIDO) {
            final agendamentosFiltrados = getAgendamentosFiltrados();
            
            return Column(
              children: [
                const SizedBox(height: 12),
                // Balões de filtro de status
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFiltroBalao('todos', 'Todos'),
                        const SizedBox(width: 8),
                        _buildFiltroBalao('pendente', 'Pendente'),
                        const SizedBox(width: 8),
                        _buildFiltroBalao('Confirmado', 'Confirmado'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Barra de pesquisa
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: pesquisaController,
                    decoration: InputDecoration(
                      hintText: 'Pesquisar agendamento...',
                      prefixIcon: Icon(Icons.search, color: Themes.cinzaTexto),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Themes.verdeBotao),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Themes.verdeBotao),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Themes.verdeBotao, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        pesquisa = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.getAgendamentos();
                    },
                    child: agendamentosFiltrados.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 64,
                                  color: Themes.cinzaTexto,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _getMensagemVazio(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Themes.cinzaTexto,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _getMensagemSubtitulo(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Themes.cinzaTexto,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: agendamentosFiltrados.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final agendamento = agendamentosFiltrados[index];
                              
                              return CustomCardWidget(
                                badgeText: 'Visita Técnica',
                                badgeColor: Themes.corBaseApp,
                                title: 'Data:  ${_formatDate(agendamento.startDate)}',
                                subtitle: '',
                                fields: [
                                  CardField(label: 'Titulo', value: agendamento.title ?? '-'),
                                  CardField(label: 'Técnico', value: agendamento.beneficiarios?.isNotEmpty == true ? agendamento.beneficiarios![0].nome ?? '-' : '-'),
                                  CardField(label: 'Horário', value: '${agendamento.startTime} - ${agendamento.endTime}' ?? '-'),
                                  CardField(label: 'Descrição: ', value: agendamento.description ?? '-'), 
                                  CardField(
                                    label: 'Status', 
                                    value: _getStatusText(agendamento.status),
                                    valueColor: _getStatusColor(agendamento.status),
                                  ),
                                ],
                                actions: const [], // Sem ações para beneficiário
                                customWidgets: [
                                  if (agendamento.beneficiarios != null && agendamento.beneficiarios!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Beneficiários: ',
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                          ),
                                          Expanded(
                                            child: _buildBeneficiariosWidget(agendamento.beneficiarios),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
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

  String _getStatusText(String? status) {
    if (status == null) return 'Não informado';
    switch (status.toLowerCase()) {
      case 'pendente':
        return 'Pendente';
      case 'Confirmado':
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
      case 'Confirmado':
        return Colors.green;
      default:
        return Themes.cinzaTexto;
    }
  }

  Widget _buildBeneficiariosWidget(List<dynamic>? beneficiarios) {
    if (beneficiarios == null || beneficiarios.isEmpty) {
      return const Text('-', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13));
    }

    final List<Widget> beneficiarioWidgets = [];
    for (var i = 0; i < beneficiarios.length; i++) {
      final beneficiario = beneficiarios[i];
      beneficiarioWidgets.add(
        Padding(
          padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Themes.corBaseApp.withOpacity(0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              child: Text(
                beneficiario.nome ?? 'Nome não informado',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    return Wrap(
      spacing: 0,
      runSpacing: 4,
      children: beneficiarioWidgets,
    );
  }
} 
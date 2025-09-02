import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/agendamento/agendamento_controller.dart';
import 'package:sisater_mobile/shared/utils/widgets/custom_card_widget.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:esig_utils/status.dart';
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_erro.dart';
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_sucesso.dart';
import 'package:shimmer/shimmer.dart';

class AgendamentosPage extends StatefulWidget {
  const AgendamentosPage({super.key});

  @override
  State<AgendamentosPage> createState() => _AgendamentosPageState();
}

class _AgendamentosPageState extends State<AgendamentosPage> {
  final AgendamentoController controller = Modular.get();

  // Adicionando estado para filtro selecionado
  String filtroSelecionado = 'todos'; // 'todos', 'pendente', 'confirmado'
  // Estado para pesquisa
  String pesquisa = '';
  final TextEditingController pesquisaController = TextEditingController();
  // Estado para ordenação (true = crescente, false = decrescente)
  bool ordenacaoCrescente = true;

  @override
  void initState() {
    super.initState();
    controller.getAgendamentos();
  }

  // Função para filtrar os agendamentos conforme o filtro selecionado e pesquisa
  List<dynamic> getAgendamentosFiltrados() {
    List<dynamic> filtrados;
    
    if (filtroSelecionado == 'todos') {
      filtrados = List.from(controller.agendamentos);
    } else {
      filtrados = controller.agendamentos.where((agendamento) {
        final status = agendamento.status?.toLowerCase() ?? '';
        final filtro = filtroSelecionado.toLowerCase();
        
        // Tratar diferentes variações do status
        if (filtro == 'confirmado') {
          // Aceitar tanto 'confirmado' quanto 'concluído' para o filtro confirmado
          return status == 'confirmado' || status == 'concluído';
        }
        
        return status == filtro;
      }).toList();
    }
    
    if (pesquisa.isNotEmpty) {
      filtrados = filtrados.where((agendamento) => 
        (agendamento.title ?? '').toLowerCase().contains(pesquisa.toLowerCase()) ||
        (agendamento.description ?? '').toLowerCase().contains(pesquisa.toLowerCase())
      ).toList();
    }
    
    // Ordenar por startDate conforme a ordenação selecionada
    filtrados.sort((a, b) {
      DateTime? dataA = a.startDate != null ? DateTime.tryParse(a.startDate!) : null;
      DateTime? dataB = b.startDate != null ? DateTime.tryParse(b.startDate!) : null;
      
      if (dataA == null && dataB == null) return 0;
      if (dataA == null) return 1;
      if (dataB == null) return -1;
      
      // Ordenar conforme a seleção do usuário
      if (ordenacaoCrescente) {
        // Ordem crescente (do mais antigo para o mais recente)
        return dataA.compareTo(dataB);
      } else {
        // Ordem decrescente (do mais recente para o mais antigo)
        return dataB.compareTo(dataA);
      }
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
          //_buildAddButton()
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

  Widget _buildAddButton() {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Themes.verdeBotao),
          borderRadius: BorderRadius.circular(6),
          color: Colors.transparent,
        ),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.add,
              size: 32, color: Themes.verdeBotao),
        ),
      ),
      onTap: () async {
        final resultado = await Navigator.pushNamed(context, '/agendamentos/agendar_visita');
        // Se retornou true, significa que um novo agendamento foi criado
        if (resultado == true) {
          // Atualizar a lista de agendamentos
          controller.getAgendamentos();
        }
      },
    );
  }

  // Método auxiliar para obter mensagem de vazio baseada no filtro
  String _getMensagemVazio() {
    switch (filtroSelecionado) {
      case 'todos':
        return 'Nenhum agendamento encontrado';
      case 'pendente':
        return 'Nenhum agendamento pendente';
      case 'confirmado':
        return 'Nenhum agendamento confirmado';
      default:
        return 'Nenhum agendamento encontrado';
    }
  }

  // Método auxiliar para obter subtítulo baseado no filtro
  String _getMensagemSubtitulo() {
    switch (filtroSelecionado) {
      case 'todos':
        return 'Você ainda não possui agendamentos';
      case 'pendente':
        return 'Não há agendamentos aguardando confirmação';
      case 'confirmado':
        return 'Não há agendamentos confirmados';
      default:
        return 'Você ainda não possui agendamentos';
    }
  }

  // Widget auxiliar para os balões de filtro
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
          color: selecionado ? Themes.verdeTags : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          texto,
          style: TextStyle(
            color: Colors.grey,
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
          if (controller.statusCarregaAgendamentos == Status.CONCLUIDO && controller.agendamentos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 64,
                    color: Themes.cinzaTexto,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhum agendamento encontrado',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Themes.cinzaTexto,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Você ainda não possui agendamentos',
                    style: TextStyle(
                      fontSize: 14,
                      color: Themes.cinzaTexto,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Themes.verdeBotao,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        icon: const Icon(Icons.add_circle, size: 24, color: Colors.white),
                        label: const Text('Criar primeiro agendamento'),
                        onPressed: () async {
                          final resultado = await Navigator.pushNamed(context, '/agendamentos/agendar_visita');
                          // Se retornou true, significa que um novo agendamento foi criado
                          if (resultado == true) {
                            // Atualizar a lista de agendamentos
                            controller.getAgendamentos();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          if (controller.statusCarregaAgendamentos == Status.CONCLUIDO) {
            final agendamentosFiltrados = getAgendamentosFiltrados();
            
            if (agendamentosFiltrados.isEmpty) {
              return Center(
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
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Themes.verdeBotao,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          icon: const Icon(Icons.add_circle, size: 24, color: Colors.white),
                          label: const Text('Criar novo agendamento'),
                          onPressed: () async {
                            final resultado = await Navigator.pushNamed(context, '/agendamentos/agendar_visita');
                            // Se retornou true, significa que um novo agendamento foi criado
                            if (resultado == true) {
                              // Atualizar a lista de agendamentos
                              controller.getAgendamentos();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                const SizedBox(height: 12),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Themes.verdeBotao,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    icon: const Icon(Icons.add_circle, size: 24, color: Colors.white,),
                    label: const Text('Agendar visita técnica'),
                    onPressed: () async {
                      final resultado = await Navigator.pushNamed(context, '/agendamentos/agendar_visita');
                      // Se retornou true, significa que um novo agendamento foi criado
                      if (resultado == true) {
                        // Atualizar a lista de agendamentos
                        controller.getAgendamentos();
                      }
                    },
                  ),
                ),
              ),
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
                        _buildFiltroBalao('confirmado', 'Confirmado'),
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
                 // Botão de ordenação
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                   child: Row(
                     children: [
                       Expanded(
                         child: ElevatedButton.icon(
                           style: ElevatedButton.styleFrom(
                             backgroundColor: Colors.white,
                             foregroundColor: Themes.verdeBotao,
                             padding: const EdgeInsets.symmetric(vertical: 12),
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(8),
                               side: BorderSide(color: Themes.verdeBotao),
                             ),
                             textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                           ),
                           icon: Icon(
                             ordenacaoCrescente ? Icons.arrow_upward : Icons.arrow_downward,
                             size: 20,
                             color: Themes.verdeBotao,
                           ),
                           label: Text(
                             ordenacaoCrescente ? 'Mais antigos primeiro' : 'Mais recentes primeiro',
                           ),
                           onPressed: () {
                             setState(() {
                               ordenacaoCrescente = !ordenacaoCrescente;
                             });
                           },
                         ),
                       ),
                     ],
                   ),
                 ),
                 const SizedBox(height: 8),
                 Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.getAgendamentos();
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: agendamentosFiltrados.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final agendamento = agendamentosFiltrados[index];
                        
                        return CustomCardWidget(
                          badgeText: 'Visita Técnica',
                          badgeColor: Themes.corBaseApp,
                          title: 'Data: ${_formatDate(agendamento.startDate)}',
                          subtitle: '',
                          fields: [
                            CardField(label: 'Titulo', value: agendamento.title ?? '-'),
                            //CardField(label: 'Técnico', value: agendamento.beneficiarios?.isNotEmpty == true ? agendamento.beneficiarios![0].nome ?? '-' : '-'),
                            CardField(label: 'Horário', value: '${agendamento.startTime} - ${agendamento.endTime}' ?? '-'),
                            CardField(label: 'Descrição: ', value: agendamento.description ?? '-'), 
                            CardField(
                              label: 'Status', 
                              value: _getStatusText(agendamento.status),
                              valueColor: _getStatusColor(agendamento.status),
                            ),
                          ],
                          actions: [
                            // Botão de visualização
                            CardAction(
                              icon: Icons.remove_red_eye_outlined,
                              tooltip: 'Visualizar',
                              onPressed: () {
                                Modular.to.pushNamed('/agendamentos/visualizar', arguments: agendamento);
                              },
                            ),
                            if (!(agendamento.status?.toLowerCase() == 'confirmado' || agendamento.status?.toLowerCase() == 'concluído'))
                              CardAction(
                                icon: Icons.edit_calendar_outlined,
                                tooltip: 'Reagendar/Cancelar',
                                onPressed: () {
                                  Modular.to.pushNamed('/agendamentos/editar_agendamento', arguments: agendamento);
                                },
                              ),
                            CardAction(
                              icon: Icons.delete_outline,
                              tooltip: 'Cancelar',
                              onPressed: () async {
                                final agendamentoId = agendamento.id;
                                if (agendamentoId != null) {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Confirmar deleção'),
                                      content: const Text('Tem certeza que deseja deletar este agendamento?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                                          child: const Text('Deletar'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    controller.deletarAgendamento(
                                      agendamentoId,
                                      () {
                                        ToastAvisosSucesso('Agendamento deletado com sucesso!');
                                        controller.getAgendamentos();
                                      },
                                      (erro) {
                                        ToastAvisosErro(erro);
                                      },
                                    );
                                  }
                                }
                              },
                            ),
                          ],
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

  String _formatHourRange(String? start, String? end) {
    if (start == null || end == null) return '-';
    try {
      final s = DateTime.parse(start);
      final e = DateTime.parse(end);
      return '${s.hour.toString().padLeft(2, '0')}:${s.minute.toString().padLeft(2, '0')} - ${e.hour.toString().padLeft(2, '0')}:${e.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '-';
    }
  }

  String _getStatusText(String? status) {
    if (status == null) return 'Não informado';
    switch (status.toLowerCase()) {
      case 'pendente':
        return 'Pendente';
      case 'confirmado':
        return 'Confirmado';
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
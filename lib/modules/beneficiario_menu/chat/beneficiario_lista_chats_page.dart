import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:esig_utils/status.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sisater_mobile/modules/beneficiario_menu/beneficiario_controller.dart';
import 'package:sisater_mobile/models/atendimento/chat_card.dart';
import 'package:sisater_mobile/modules/atendimento/widgets/chat_card.dart';
import 'package:sisater_mobile/modules/autenticacao/autenticacao_controller.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';
import 'dart:developer' as developer;

class BeneficiarioListaChatsPage extends StatefulWidget {
  const BeneficiarioListaChatsPage({super.key});

  @override
  State<BeneficiarioListaChatsPage> createState() => _BeneficiarioListaChatsPageState();
}

class _BeneficiarioListaChatsPageState extends State<BeneficiarioListaChatsPage> {
  BeneficiarioController controller = Modular.get();
  AutenticacaoController autenticacaoController = Modular.get();

  // Estado para filtro de status
  String filtroSelecionado = 'todas'; // 'todas', 'aberto', 'em_progresso', 'fechado'
  // Estado para pesquisa
  String pesquisa = '';
  final TextEditingController pesquisaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('BeneficiarioListaChatsPage: initState chamado');
    try {
      controller.getChats();
    } catch (e) {
      print('Erro ao carregar chats: $e');
    }
  }

  // Função para filtrar, buscar e ordenar os chats
  List<ChatCard> getChatsFiltrados() {
    List<ChatCard> filtrados = filtroSelecionado == 'todas'
        ? controller.chats
        : controller.chats.where((chat) => chat.status == filtroSelecionado).toList();
    if (pesquisa.isNotEmpty) {
      filtrados = filtrados.where((chat) => (chat.title ?? '').toLowerCase().contains(pesquisa.toLowerCase())).toList();
    }
    // Ordenar do mais recente para o mais antigo
    filtrados.sort((a, b) {
      DateTime? dataA = a.createdAt != null ? DateTime.tryParse(a.createdAt!) : null;
      DateTime? dataB = b.createdAt != null ? DateTime.tryParse(b.createdAt!) : null;
      if (dataA == null && dataB == null) return 0;
      if (dataA == null) return 1;
      if (dataB == null) return -1;
      return dataB.compareTo(dataA); // mais recente primeiro
    });
    return filtrados;
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

  String formatarData(String? dataString) {
    if (dataString == null || dataString.isEmpty) {
      return 'Data não disponível';
    }
    try {
      DateTime data = DateTime.parse(dataString);
      return DateFormat('dd/MM/yyyy', 'pt_BR').format(data);
    } catch (e) {
      return 'Data inválida';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: formAppBar(context, 'Atendimentos', false, null),
      body: Observer(
        builder: (_) {
          developer.log('Status do carregamento: \\${controller.statusCarregaChats}');
          developer.log('Quantidade de chats: \\${controller.chats.length}');
          developer.log('Erro: \\${controller.mensagemError}');
          switch (controller.statusCarregaChats) {
            case Status.AGUARDANDO:
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
            case Status.ERRO:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Themes.vermelhoTexto,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Erro ao carregar conversas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Themes.vermelhoTexto,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.mensagemError,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Themes.vermelhoTexto,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => controller.getChats(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Themes.verdeBotao,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              );
            case Status.CONCLUIDO:
              if (controller.chats.isEmpty) {
                return Column(
                  children: [
                    const SizedBox(height: 12),
                    // Botão de nova conversa (sempre visível)
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
                          label: const Text('Iniciar novo atendimento'),
                          onPressed: () async {
                            // Exibe um dialog para digitar o título
                            String? titulo = await showDialog<String>(
                              context: context,
                              builder: (context) {
                                String tempTitulo = '';
                                return AlertDialog(
                                  title: const Text('Nova conversa'),
                                  content: TextField(
                                    autofocus: true,
                                    decoration: const InputDecoration(hintText: 'Digite o título da conversa'),
                                    onChanged: (value) => tempTitulo = value,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(tempTitulo),
                                      child: const Text('Criar'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (titulo != null && titulo.trim().isNotEmpty) {
                              final sucesso = await controller.repository.criarChat(titulo.trim());
                              if (sucesso) {
                                await controller.getChats();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Erro ao criar nova conversa')),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Mensagem de lista vazia
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Themes.cinzaTexto,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Nenhuma conversa encontrada',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Themes.cinzaTexto,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Você ainda não possui conversas ativas',
                              style: TextStyle(
                                fontSize: 14,
                                color: Themes.cinzaTexto,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
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
                          _buildFiltroBalao('todas', 'Todas'),
                          const SizedBox(width: 8),
                          _buildFiltroBalao('aberto', 'Não Atendido'),
                          const SizedBox(width: 8),
                          _buildFiltroBalao('em_progresso', 'Em Andamento'),
                          const SizedBox(width: 8),
                          _buildFiltroBalao('fechado', 'Encerrado'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Botão de nova conversa
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
                        label: const Text('Iniciar novo atendimento'),
                        onPressed: () async {
                          // Exibe um dialog para digitar o título
                          String? titulo = await showDialog<String>(
                            context: context,
                            builder: (context) {
                              String tempTitulo = '';
                              return AlertDialog(
                                title: const Text('Nova conversa'),
                                content: TextField(
                                  autofocus: true,
                                  decoration: const InputDecoration(hintText: 'Digite o título da conversa'),
                                  onChanged: (value) => tempTitulo = value,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Cancelar'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.of(context).pop(tempTitulo),
                                    child: const Text('Criar'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (titulo != null && titulo.trim().isNotEmpty) {
                            final sucesso = await controller.repository.criarChat(titulo.trim());
                            if (sucesso) {
                              await controller.getChats();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Erro ao criar nova conversa')),
                              );
                            }
                          }
                        },
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
                        hintText: 'Pesquisar conversa...',
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
                      onRefresh: () => controller.getChats(),
                      color: Themes.verdeBotao,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: getChatsFiltrados().length,
                        itemBuilder: (context, index) {
                          ChatCard chat = getChatsFiltrados()[index];
                          return GestureDetector(
                            onTap: () {
                              print('=== DEBUG BENEFICIARIO LISTA CHATS: Card tocado, chat: ${chat.id} - ${chat.title} ===');
                              // Redirecionar para a página de chat passando o chat selecionado
                              Modular.to.pushNamed('/beneficiario/chat_detalhes', arguments: chat);
                            },
                            child: ChatCardWidget(chat: chat),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
} 
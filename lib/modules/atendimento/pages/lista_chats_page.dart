import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:esig_utils/status.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sisater_mobile/modules/atendimento/atendimento_controller.dart';
import 'package:sisater_mobile/models/atendimento/chat_card.dart';
import 'package:sisater_mobile/modules/atendimento/widgets/chat_card.dart';
import 'package:sisater_mobile/modules/autenticacao/autenticacao_controller.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';
import 'dart:developer' as developer;
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_erro.dart';
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_sucesso.dart';

class ListaChatsPage extends StatefulWidget {
  const ListaChatsPage({super.key});

  @override
  State<ListaChatsPage> createState() => _ListaChatsPageState();
}

class _ListaChatsPageState extends State<ListaChatsPage> {
  AtendimentoController controller = Modular.get();

  AutenticacaoController autenticacaoController = Modular.get();

  // Adicionando estado para filtro selecionado
  String filtroSelecionado = 'todas'; // 'todas', 'aberto', 'em_progresso', 'fechado'
  // Estado para pesquisa
  String pesquisa = '';
  final TextEditingController pesquisaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.getChats();
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
    // Função para filtrar os chats conforme o filtro selecionado e pesquisa
    List<ChatCard> getChatsFiltrados() {
      List<ChatCard> filtrados = filtroSelecionado == 'todas'
          ? controller.chats
          : controller.chats.where((chat) => chat.status == filtroSelecionado).toList();
      if (pesquisa.isNotEmpty) {
        filtrados = filtrados.where((chat) => (chat.title ?? '').toLowerCase().contains(pesquisa.toLowerCase())).toList();
      }
      // Ordenar do mais recente para o mais antigo baseado na última atualização
      filtrados.sort((a, b) {
        DateTime? dataA = a.updatedAt != null ? DateTime.tryParse(a.updatedAt!) : 
                         (a.createdAt != null ? DateTime.tryParse(a.createdAt!) : null);
        DateTime? dataB = b.updatedAt != null ? DateTime.tryParse(b.updatedAt!) : 
                         (b.createdAt != null ? DateTime.tryParse(b.createdAt!) : null);
        if (dataA == null && dataB == null) return 0;
        if (dataA == null) return 1;
        if (dataB == null) return -1;
        return dataB.compareTo(dataA); // mais recente primeiro
      });
      return filtrados;
    }

    return Scaffold(
      appBar: formAppBar(context, 'Atendimentos', false, null),
      body: Observer(

        builder: (_) {

          developer.log('Status do carregamento: ${controller.statusCarregaChats}');
          developer.log('Quantidade de chats: ${controller.chats.length}');
          developer.log('Erro: ${controller.mensagemError}');
          
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
              // Verifica se há chats para o filtro selecionado
              List<ChatCard> chatsFiltrados = getChatsFiltrados();
             return Column(
               children: [
                 const SizedBox(height: 12),
                 // Balões de filtro de status (sempre visíveis)
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
                 if (chatsFiltrados.isEmpty)
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
                     ),
                   )
                 else
                   Expanded(
                     child: RefreshIndicator(
                       onRefresh: () => controller.getChats(),
                       color: Themes.verdeBotao,
                       child: ListView.builder(
                         padding: const EdgeInsets.all(16),
                         itemCount: chatsFiltrados.length,
                         itemBuilder: (context, index) {
                           ChatCard chat = chatsFiltrados[index];
                           return ChatCardWidget(
                             chat: chat,
                             onTap: () async {
                               final status = (chat.status ?? '').toLowerCase().trim();
                               if (['aberto', 'nao atendido', 'não atendido', 'open'].contains(status)) {
                                 final confirm = await showDialog<bool>(
                                   context: context,
                                   builder: (context) => AlertDialog(
                                     title: const Text('Ingressar na conversa'),
                                     content: const Text('Deseja ingressar nesta conversa?'),
                                     actions: [
                                       TextButton(
                                         onPressed: () => Navigator.of(context).pop(false),
                                         child: const Text('Cancelar'),
                                       ),
                                       TextButton(
                                         onPressed: () => Navigator.of(context).pop(true),
                                         style: TextButton.styleFrom(foregroundColor: Colors.green),
                                         child: const Text('Sim'),
                                       ),
                                     ],
                                   ),
                                 );
                                 if (confirm == true) {
                                   final sucesso = await controller.joinChat(chat.id!);
                                   if (sucesso) {
                                     ToastAvisosSucesso('Você ingressou na conversa!');
                                     Modular.to.pushNamed('/atendimento/chat', arguments: chat);
                                     controller.getChats(); // Atualiza em background
                                   } else {
                                     ToastAvisosErro('Erro ao ingressar na conversa');
                                   }
                                 }
                               } else {
                                 Modular.to.pushNamed('/atendimento/chat', arguments: chat);
                               }
                             },
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

  // Método auxiliar para obter mensagem de vazio baseada no filtro
  String _getMensagemVazio() {
    switch (filtroSelecionado) {
      case 'todas':
        return 'Nenhuma conversa encontrada';
      case 'aberto':
        return 'Nenhuma conversa não atendida';
      case 'em_progresso':
        return 'Nenhuma conversa em andamento';
      case 'fechado':
        return 'Nenhuma conversa concluída';
      default:
        return 'Nenhuma conversa encontrada';
    }
  }

  // Método auxiliar para obter subtítulo baseado no filtro
  String _getMensagemSubtitulo() {
    switch (filtroSelecionado) {
      case 'todas':
        return 'Você ainda não possui conversas ativas';
      case 'aberto':
        return 'Não há conversas aguardando atendimento';
      case 'em_progresso':
        return 'Não há conversas em andamento no momento';
      case 'fechado':
        return 'Não há conversas finalizadas';
      default:
        return 'Você ainda não possui conversas ativas';
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
          color: selecionado ? Themes.verdeTags : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          texto,
          style: TextStyle(
            color: selecionado ? Colors.grey : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

 
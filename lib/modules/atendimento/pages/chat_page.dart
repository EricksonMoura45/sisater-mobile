import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:esig_utils/status.dart';
import 'package:sisater_mobile/modules/atendimento/atendimento_controller.dart';
import 'package:sisater_mobile/models/atendimento/chat_card.dart';
import 'package:sisater_mobile/models/atendimento/mensagem.dart';
import 'package:sisater_mobile/modules/autenticacao/autenticacao_controller.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/chat_appbar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  
  final AtendimentoController atendimentoController = Modular.get();
  final AutenticacaoController autenticacaoController = Modular.get();
  final TextEditingController _mensagemController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  ChatCard? chat;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recebe o chat selecionado via arguments
    chat = Modular.args.data as ChatCard?;
    if (chat != null) {
      atendimentoController.setChatSelecionado(chat);
      // Garante que os dados do usuário estejam carregados
      if (autenticacaoController.usuarioDados == null) {
        autenticacaoController.carregaUsuario().then((_) {
          atendimentoController.getMensagens(chat!.id!);
        });
      } else {
        atendimentoController.getMensagens(chat!.id!);
      }
    }
  }
  
  void _enviarMensagem() async {
    final texto = _mensagemController.text.trim();
    if (texto.isEmpty || chat == null) return;
    final sucesso = await atendimentoController.enviarMensagem(chat!.id!, texto);
    if (sucesso) {
      _mensagemController.clear();
      // Scroll para o final após enviar
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  String formatarHora(String? dataString) {
    if (dataString == null || dataString.isEmpty) return '';
    try {
      DateTime data = DateTime.parse(dataString);
      return DateFormat('HH:mm').format(data);
    } catch (e) {
      return '';
    }
  }

  bool isMinhaMensagem(Mensagem mensagem) {
    final userId = autenticacaoController.usuarioDados?.id;
    final isMinha = mensagem.userId == userId;
    
    // Log para debug
    print('Mensagem ID: ${mensagem.userId}, Usuário atual ID: $userId, É minha: $isMinha');
    
    return isMinha;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: chatAppBar(
        context,
        chat?.title ?? 'Chat',
        showFinalizarButton: chat?.status?.toLowerCase() != 'fechado' && chat?.status?.toLowerCase() != 'encerrado',
        showAgendamentoButton: true,
        onFinalizarPressed: () async {
          if (chat == null) return;
          // Navega para FinalizarAtendimentoPage e espera resultado
          final result = await Modular.to.pushNamed(
            '/atendimento/finalizar_atendimento',
            arguments: chat,
          );
          if (result == true) {
            // Atendimento finalizado com sucesso, recarrega mensagens e status
            await atendimentoController.getChats();
            await atendimentoController.getMensagens(chat!.id!);
            setState(() {}); // Atualiza UI
          }
        },
        onAgendamentoPressed: () async {
          // Navega para a página de agendamento e aguarda resultado
          final result = await Modular.to.pushNamed('/agendamentos/agendar_visita', arguments: chat);
          if (result == true) {
            // Agendamento realizado com sucesso, atualizar mensagens
            await atendimentoController.getMensagens(chat!.id!);
            setState(() {}); // Atualiza UI
          }
        },
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/chat_background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Overlay branco para clarear a imagem
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.5), // ajuste a opacidade conforme desejar
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Observer(
                  builder: (_) {
                    switch (atendimentoController.statusCarregaMensagens) {
                      case Status.AGUARDANDO:
                        return const Center(child: CircularProgressIndicator(color: Themes.verdeBotao));
                      case Status.ERRO:
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, size: 64, color: Themes.vermelhoTexto),
                              const SizedBox(height: 16),
                              const Text('Erro ao carregar mensagens', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Themes.vermelhoTexto)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => atendimentoController.getMensagens(chat?.id ?? 0),
                                style: ElevatedButton.styleFrom(backgroundColor: Themes.verdeBotao, foregroundColor: Colors.white),
                                child: const Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        );
                      case Status.CONCLUIDO:
                        final mensagens = atendimentoController.mensagens;
                        if (mensagens.isEmpty) {
                          return const Center(
                            child: Text('Nenhuma mensagem ainda.', style: TextStyle(color: Themes.cinzaTexto)),
                          );
                        }
                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                          itemCount: mensagens.length,
                          itemBuilder: (context, index) {
                            final mensagem = mensagens[index];
                            final minha = isMinhaMensagem(mensagem);
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment: minha ? MainAxisAlignment.end : MainAxisAlignment.start,
                                children: [
                                  if (!minha) ...[
                                    // Avatar para mensagens de outros usuários
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Themes.verdeBotao.withOpacity(0.3),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        color: Themes.verdeBotao,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Flexible(
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                                      decoration: BoxDecoration(
                                        color: minha ? Themes.verdeBotao : Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(16),
                                          topRight: const Radius.circular(16),
                                          bottomLeft: minha ? const Radius.circular(16) : const Radius.circular(4),
                                          bottomRight: minha ? const Radius.circular(4) : const Radius.circular(16),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.04),
                                            blurRadius: 2,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: minha ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if (mensagem.message != null && mensagem.message!.isNotEmpty)
                                                Flexible(
                                                  child: Text(
                                                    mensagem.message!,
                                                    style: TextStyle(
                                                      color: minha ? Colors.white : Themes.pretoTexto,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              const SizedBox(width: 8),
                                              Column(
                                                crossAxisAlignment: minha ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    formatarHora(mensagem.createdAt),
                                                    style: TextStyle(
                                                      color: minha ? Colors.white70 : Themes.cinzaTexto,
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  if (!minha) ...[
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      'Você',
                                                      style: TextStyle(
                                                        color: Themes.cinzaTexto,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (minha) ...[
                                    const SizedBox(width: 8),
                                    // Avatar para mensagens do usuário atual
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Themes.verdeBotao,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        );
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              _buildInputArea(),
            ],
          ),
        ],
      ),
      backgroundColor: const Color(0xFFe8fdec),
    );
  }

  Widget _buildInputArea() {
    final status = chat?.status?.toLowerCase();
    final isFechado = status == 'fechado' || status == 'encerrado';
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _mensagemController,
                minLines: 1,
                maxLines: 5,
                readOnly: isFechado,
                decoration: InputDecoration(
                  hintText: isFechado ? 'Atendimento encerrado' : 'Digite aqui... ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.grey[100],
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
                onSubmitted: (_) { if (!isFechado) _enviarMensagem(); },
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: Themes.verdeBotao,
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: isFechado ? null : _enviarMensagem,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sisater_mobile/models/atendimento/chat_card.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';

class ChatCardWidget extends StatelessWidget {
  final ChatCard chat;
  final VoidCallback? onTap;

  const ChatCardWidget({
    super.key,
    required this.chat,
    this.onTap,
  });

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

  String formatarHora(String? dataString) {
    if (dataString == null || dataString.isEmpty) {
      return '';
    }
    
    try {
      DateTime data = DateTime.parse(dataString);
      return DateFormat('HH:mm', 'pt_BR').format(data);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definir cor e texto do status  (em_progresso, aberto, fechado)
    Color statusColor;
    String statusText;
    switch (chat.status) {
      case 'em_progresso':
        statusColor = Colors.green;
        statusText = 'Em Andamento';
        break;
      case 'aberto':
        statusColor = Colors.red;
        statusText = 'Não Atendido';
        break;
      case 'fechado':
        statusColor = Colors.blue;
        statusText = 'Encerrado';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Desconhecido';
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Themes.cinzaBackground,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chat.title ?? 'Nome do Título não disponível',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      chat.tecnico ?? 'Técnico não disponível',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatarData(chat.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        formatarHora(chat.updatedAt ?? chat.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (chat.beneficiario != null && chat.beneficiario!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                  child: Text(
                    'Beneficiário: ${chat.beneficiario}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              const SizedBox(height: 8),
              // Segunda linha: Status
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Terceira linha: Ícone de check e última mensagem
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.ultimaMensagem?.message ?? 'Mensagem não disponível',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Atualizado em: ${formatarData(chat.updatedAt ?? chat.createdAt)}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
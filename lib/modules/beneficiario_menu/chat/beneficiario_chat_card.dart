import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:sisater_mobile/models/atendimento/chat_card.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';

class BeneficiarioChatCardWidget extends StatelessWidget {
  final ChatCard chat;

  const BeneficiarioChatCardWidget({
    super.key,
    required this.chat,
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Modular.to.pushNamed('/chat_detalhes', arguments: chat);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Themes.verdeBotao,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Chat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formatarData(chat.createdAt),
                    style: TextStyle(
                      color: Themes.cinzaTexto,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                chat.title ?? 'Chat sem título',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Themes.pretoTexto,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Status: ${chat.status ?? 'Ativo'}',
                style: TextStyle(
                  fontSize: 14,
                  color: chat.status == 'active' ? Themes.verdeBotao : Themes.cinzaTexto,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_outlined,
                        size: 16,
                        color: Themes.verdeBotao,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Criado em: ${formatarData(chat.createdAt)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Themes.cinzaTexto,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Themes.cinzaTexto,
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
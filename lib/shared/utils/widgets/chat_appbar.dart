import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';

PreferredSizeWidget? chatAppBar(
  BuildContext context, 
  String titulo, 
  {
    bool showFinalizarButton = false,
    bool showAgendamentoButton = false,
    VoidCallback? onFinalizarPressed,
    VoidCallback? onAgendamentoPressed,
  }
) {
  return AppBar(
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
        _buildTitulo(context, titulo),
        Row(
          children: [
            // Botão de finalizar atendimento (se habilitado)
            if (showFinalizarButton)
              GestureDetector(
                onTap: onFinalizarPressed,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Themes.verdeBotao),
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.transparent,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.check_circle_outline,
                        size: 24, color: Themes.verdeBotao),
                  ),
                ),
              ),
            // Espaçamento entre botões
            if (showFinalizarButton && showAgendamentoButton)
              const SizedBox(width: 8),
            // Botão de agendamento (se habilitado)
            if (showAgendamentoButton)
              GestureDetector(
                onTap: onAgendamentoPressed,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Themes.verdeBotao),
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.transparent,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.calendar_month,
                        size: 24, color: Themes.verdeBotao),
                  ),
                ),
              ),
          ],
        ),
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
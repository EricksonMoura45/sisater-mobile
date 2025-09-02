import 'package:flutter/material.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';

class CustomCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<CardField> fields;
  final List<CardAction> actions;
  final Color? badgeColor;
  final String? badgeText;
  final List<Widget>? customWidgets;

  const CustomCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.fields,
    required this.actions,
    this.badgeColor,
    this.badgeText,
    this.customWidgets,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge
            if (badgeText != null)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor ?? const Color(0xFFE6F4EA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badgeText!,
                      style: TextStyle(
                        color: badgeColor != null ? Colors.white : Themes.verdeBotao,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            if (badgeText != null) const SizedBox(height: 8),
            
            // Title
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            
            // Subtitle
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Themes.cinzaTexto,
                ),
              ),
            if (subtitle.isNotEmpty) const SizedBox(height: 8),
            
            // Fields
            ...fields.map((field) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (field.label.isNotEmpty) ...[
                    Flexible(
                      flex: 0,
                      child: Text(
                        '${field.label}: ',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  Expanded(
                    child: Text(
                      field.value,
                      style: TextStyle(
                        fontWeight: field.isBold ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                        fontStyle: field.isItalic ? FontStyle.italic : FontStyle.normal,
                        color: field.valueColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            )),
            
            // Custom Widgets
            if (customWidgets != null) ...customWidgets!,
            
            const SizedBox(height: 10),
            
            // Actions
            if (actions.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions.map((action) => IconButton(
                    icon: Icon(action.icon, color: action.color ?? Themes.cinzaTexto),
                    tooltip: action.tooltip,
                    onPressed: action.onPressed,
                  )).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CardField {
  final String label;
  final String value;
  final bool isBold;
  final bool isItalic;
  final Color? valueColor;

  const CardField({
    required this.value,
    this.label = '',
    this.isBold = false,
    this.isItalic = false,
    this.valueColor,
  });
}

class CardAction {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final Color? color;

  const CardAction({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.color,
  });
} 
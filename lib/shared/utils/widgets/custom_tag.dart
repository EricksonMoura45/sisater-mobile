import 'package:flutter/material.dart';

class CustomTag extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const CustomTag({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFA6D0C1), // #A6D0C1
        borderRadius: borderRadius ?? BorderRadius.circular(5),
        border: Border.all(
          color: backgroundColor ?? const Color(0xFFA6D0C1),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.grey[700], // Cor de fonte cinza
          fontSize: fontSize ?? 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Widget específico para tag de Beneficiário
class BeneficiarioTag extends StatelessWidget {
  const BeneficiarioTag({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomTag(
      text: 'Beneficiário',
      backgroundColor: Color(0xFFA6D0C1),
      textColor: Colors.white, // Mantém branco como no exemplo original
    );
  }
}

// Widget específico para tag de Organização
class OrganizacaoTag extends StatelessWidget {
  const OrganizacaoTag({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomTag(
      text: 'Organização',
      backgroundColor: Color(0xFFA6D0C1),
    );
  }
}

// Widget específico para tag de Comunidade
class ComunidadeTag extends StatelessWidget {
  const ComunidadeTag({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomTag(
      text: 'Comunidade',
      backgroundColor: Color(0xFFA6D0C1),
    );
  }
}

// Widget específico para tag de Atividade
class AtividadeTag extends StatelessWidget {
  const AtividadeTag({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomTag(
      text: 'Atividade',
      backgroundColor: Color(0xFFA6D0C1),
    );
  }
}

// Widget específico para tag de Unidade de Produção
class UnidadeProducaoTag extends StatelessWidget {
  const UnidadeProducaoTag({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomTag(
      text: 'Unidade de Produção',
      backgroundColor: Color(0xFFA6D0C1),
    );
  }
} 
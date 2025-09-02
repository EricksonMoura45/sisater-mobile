import 'package:flutter/material.dart';

class BeneficiarioSearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;

  const BeneficiarioSearchBar({super.key, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Buscar',
          hintText: 'Nome, CPF ou telefone',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: onSearchChanged,
      ),
    );
  }
}

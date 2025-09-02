import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sisater_mobile/shared/utils/widgets/input_widget.dart';

Widget buildInputField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType? inputType,

    
    List<TextInputFormatter>? formatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          InputWidget(
            inputType: TextInputType.text,
            controller: controller,
            formatters: formatters,
            validator: validator,
          ),
        ],
      ),
    );
  }
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/beneficiario_ater_controller.dart';

// ignore: must_be_immutable
class DatePickerWidget extends StatefulWidget {

  final String label;
  int? formfield;

  DatePickerWidget({
    super.key,
    required this.label, 
    this.formfield,
  });

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {

  BeneficiarioAterController beneficiarioAterController = Modular.get();
  

  // Variável para armazenar a data selecionada
  DateTime selectedDate = DateTime.now();

  // Função para abrir o DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(1900);
    final DateTime lastDate = now; // ou outra lógica, mas nunca menor que initialDate

    final DateTime initialDate = 
        (selectedDate.isBefore(lastDate))
          ? selectedDate
          : lastDate;

    // Exibe o DatePicker
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    // Se o usuário selecionar uma data, atualiza a variável
    if (picked != null && picked != selectedDate) {
      //Gambiarra para atualizar o valor do campo no controller do beneficiário
      setState(() {
        selectedDate = picked;
        if(widget.formfield == 1){
          beneficiarioAterController.dataNascimentoPicked = selectedDate;
        } else if(widget.formfield == 2){
          beneficiarioAterController.dataEmissaoRGPicked = selectedDate;
        } else if(widget.formfield == 3){
          beneficiarioAterController.dataNascimentoFamiliarPicked = selectedDate;
        }

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
        TextField(
              onTap: () => _selectDate(context), // Ao clicar, abre o DatePicker
              readOnly: true, // Impede a digitação manual
              decoration: InputDecoration(
                fillColor: Colors.white,
                //labelText: 'Selecione uma data...',
                hintText: selectedDate != null
                    ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                    : 'Selecione uma data',
                suffixIcon: Icon(Icons.calendar_today),
               enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        labelStyle: TextStyle(color: Colors.black),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
        border: InputBorder.none,
        errorStyle: TextStyle(color: Colors.black),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ), 
              ),
            ),
             SizedBox(height: 20),
      ],
    );
  }

  
}
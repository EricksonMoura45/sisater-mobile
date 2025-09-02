import 'package:sisater_mobile/models/agendamento/beneficiario_agendamento.dart';

class AgendamentoLista {

  int? id;
  String? title;
  String? description;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? status;
  int? createdAt;
  int? userId;
  List<BeneficiarioAgendamento>? beneficiarios;
  List<String>? beneficiariesMultiples;
  int? chatId;

  AgendamentoLista({this.id, this.title, this.description, this.startDate, this.endDate, this.status, this. startTime, this.endTime, this.createdAt, this.userId, this.beneficiarios, this.beneficiariesMultiples, this.chatId});

  factory AgendamentoLista.fromJson(Map<String, dynamic> json) {
    return AgendamentoLista(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      status: json['status'],
      createdAt: json['created_at'],
      userId: json['user_id'],
      //beneficiariesMultiples: json['beneficiaries_multiples'] != null ? (json['beneficiaries_multiples'] as List).map((a) => a.toString()).toList() : [],
      beneficiarios: json['beneficiaries'] != null ? (json['beneficiaries'] as List).map((a) => BeneficiarioAgendamento.fromJson(a)).toList() : null,
      //chatId: json['chat_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'id': id,
      'title': title,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
      'created_at': createdAt,
      'user_id': userId,
      'chat_id': chatId,
    };
    
    // Se temos beneficiary_multiples, usar ele. Senão, usar beneficiaries
    if (beneficiariesMultiples != null && beneficiariesMultiples!.isNotEmpty) {
      json['beneficiary_multiples'] = beneficiariesMultiples;
    } else if (beneficiarios != null && beneficiarios!.isNotEmpty) {
      json['beneficiaries'] = beneficiarios!.map((a) => a.toJson()).toList();
    }
    
    return json;
  }
}
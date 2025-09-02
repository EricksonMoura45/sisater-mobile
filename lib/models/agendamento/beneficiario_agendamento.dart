class BeneficiarioAgendamento {

  int? id;
  String? nome;
  String? document;

  BeneficiarioAgendamento({this.id, this.nome, this.document});

  factory BeneficiarioAgendamento.fromJson(Map<String, dynamic> json) {
    
    return BeneficiarioAgendamento(
      id: json['id'],
      nome: json['name'],
      document: json['document'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': nome,
      'document': document,
    };
  }
}
class Meta {
  final String? descricao;
  final double? valor;
  final String? unidade;

  Meta({
    this.descricao,
    this.valor,
    this.unidade,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': descricao,
      'amount': valor,
      'unit_of_measure_id': unidade,
    };
  }

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      descricao: json['name'],
      valor: json['amount']?.toDouble(),
      unidade: json['unit_of_measure_id']?.toString(),
    );
  }
}

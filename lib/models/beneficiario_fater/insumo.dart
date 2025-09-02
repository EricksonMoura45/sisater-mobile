class Insumo {
  final String? insumo;
  final double? quantidade;
  final String? unidadeMedida;
  final String? timestamp;

  Insumo({
    this.insumo,
    this.quantidade,
    this.unidadeMedida,
    this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'descricao': insumo,
      'amount': quantidade,
      'unit_of_measure_id': unidadeMedida,
    };
  }

  factory Insumo.fromJson(Map<String, dynamic> json) {
    return Insumo(
      insumo: json['descricao'],
      quantidade: json['amount']?.toDouble(),
      unidadeMedida: json['unit_of_measure_id']?.toString(),
    );
  }
} 
class Atividade {
  final String? produto;
  final String? situacao;
  final String? recomendacoes;
  final String? timestamp;

  Atividade({
    this.produto,
    this.situacao,
    this.recomendacoes,
    this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': produto,
      'situacao': situacao,
      'recomendacoes': recomendacoes,
    };
  }

  factory Atividade.fromJson(Map<String, dynamic> json) {
    return Atividade(
      produto: json['product_id']?.toString(),
      situacao: json['situacao'],
      recomendacoes: json['recomendacoes'],
    );
  }
} 
class Foto {
  final String? caminho;
  final String? nome;
  final DateTime? dataAdicao;

  Foto({this.caminho, this.nome, this.dataAdicao});

  Map<String, dynamic> toJson() {
    return {
      'caminho': caminho,
      'nome': nome,
      'data_adicao': dataAdicao?.toIso8601String(),
    };
  }

  factory Foto.fromJson(Map<String, dynamic> json) {
    return Foto(
      caminho: json['caminho'],
      nome: json['nome'],
      dataAdicao: json['data_adicao'] != null 
          ? DateTime.parse(json['data_adicao']) 
          : null,
    );
  }
} 
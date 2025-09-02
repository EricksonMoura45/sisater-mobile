class UnidadeMedida {
  int? id;
  String? name;

  UnidadeMedida({this.id, this.name});

  factory UnidadeMedida.fromJson(Map<String, dynamic> json) {
    return UnidadeMedida(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
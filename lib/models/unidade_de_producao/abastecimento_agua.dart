class AbastecimentoAgua {
  int? id;
  String? name;

  AbastecimentoAgua({this.id, this.name});

  factory AbastecimentoAgua.fromJson(Map<String, dynamic> json) {
    return AbastecimentoAgua(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
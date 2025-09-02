class Dominio {
  int? id;
  String? name;

  Dominio({this.id, this.name});

  factory Dominio.fromJson(Map<String, dynamic> json) {
    return Dominio(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
class EnergiaEletrica {
  int? id;
  String? name;

  EnergiaEletrica({this.id, this.name});

  factory EnergiaEletrica.fromJson(Map<String, dynamic> json) {
    return EnergiaEletrica(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
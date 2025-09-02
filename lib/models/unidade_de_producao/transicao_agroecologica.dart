class TransicaoAgroecologica {
  int? id;
  String? name;

  TransicaoAgroecologica({this.id, this.name});

  factory TransicaoAgroecologica.fromJson(Map<String, dynamic> json) {
    return TransicaoAgroecologica(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
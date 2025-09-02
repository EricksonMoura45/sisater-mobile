class PoliticasPublicas {
  int? id;
  String? name;

  PoliticasPublicas({
    this.id,
    this.name,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory PoliticasPublicas.fromJson(Map<String, dynamic> map) {
    return PoliticasPublicas(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }
}
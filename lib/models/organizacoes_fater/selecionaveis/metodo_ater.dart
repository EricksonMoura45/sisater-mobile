class MetodoAter {
  int? id;
  String? name;

  MetodoAter({
    this.id,
    this.name,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory MetodoAter.fromJson(Map<String, dynamic> map) {
    return MetodoAter(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }
}
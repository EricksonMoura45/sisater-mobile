class TecnicaAter {
  int? id;
  String? name;

  TecnicaAter({
    this.id,
    this.name,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory TecnicaAter.fromJson(Map<String, dynamic> map) {
    return TecnicaAter(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }
}
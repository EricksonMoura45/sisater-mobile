class Parentesco {
  int id;
  String name;
  
  Parentesco({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Parentesco.fromJson(Map<String, dynamic> map) {
    return Parentesco(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}

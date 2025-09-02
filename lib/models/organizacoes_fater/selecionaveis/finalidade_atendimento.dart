// ignore_for_file: public_member_api_docs, sort_constructors_first

class FinalidadeAtendimento {
  
  int? id;
  String? name;
  FinalidadeAtendimento({
    this.id,
    this.name,
  });


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory FinalidadeAtendimento.fromJson(Map<String, dynamic> map) {
    return FinalidadeAtendimento(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

}

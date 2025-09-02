// ignore_for_file: public_member_api_docs, sort_constructors_first

class OrganizacaoAterList {
  int id;
  String? document;
  String? name;
  String? cellphone;

  OrganizacaoAterList({
    required this.id,
    this.document,
    this.name,
    this.cellphone,
  });


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'document': document,
      'name': name,
      'cellphone': cellphone,
    };
  }

  factory OrganizacaoAterList.fromJson(Map<String, dynamic> map) {
    return OrganizacaoAterList(
      id: map['id'] as int,
      document: map['document'] ?? '',
      name: map['name'] ?? '',
      cellphone: map['cellphone'] ?? '',
    );
  }

}

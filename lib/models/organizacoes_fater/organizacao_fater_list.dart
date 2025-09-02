// ignore_for_file: public_member_api_docs, sort_constructors_first

class OrganizacaoFaterList {

  int id;
  int? year;
  int? code;
  String? communities;
  String? action_date;

  OrganizacaoFaterList({
    required this.id,
    this.year,
    this.code,
    this.communities,
    this.action_date,
  });
  

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'year': year,
      'code': code,
      'communities': communities,
      'action_date': action_date,
    };
  }

  factory OrganizacaoFaterList.fromJson(Map<String, dynamic> map) {
    return OrganizacaoFaterList(
      id: map['id'] as int,
      year: map['year'] ?? 'Nao informado',
      code: map['code'] ?? 'Nao informado',
      communities: map['communities'] ?? 'Nao informado',
      action_date: map['action_date'] ?? 'Nao informado',
    );
  }

}

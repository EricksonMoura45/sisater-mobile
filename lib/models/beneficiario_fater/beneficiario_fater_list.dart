// ignore_for_file: public_member_api_docs, sort_constructors_first

class BeneficiarioFaterList {

  int id;
  int? year;
  int? code;
  int? officeId;
  String? cityCode;
  String? communities;
  String? action_date;

  BeneficiarioFaterList({
    required this.id,
    this.cityCode,
    this.year,
    this.code,
    this.communities,
    this.action_date, required officeId,
  });


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'year': year,
      'code': code,
      'city_code': cityCode,
      'office_id': officeId,
      'communities': communities,
      'action_date': action_date,
    };
  }

  factory BeneficiarioFaterList.fromJson(Map<String, dynamic> map) {
    return BeneficiarioFaterList(
      id: map['id'],
      cityCode: map['city_code'] ?? 'Nao informado',
      year: map['year'] ?? 'Nao informado',
      code: map['code'] ?? 'Nao informado',
      officeId: map['office_id'] ?? 'Nao informado',
      communities: map['communities'] ?? 'Nao informado',
      action_date: map['action_date'] ?? 'Nao informado',
    );
  }

}

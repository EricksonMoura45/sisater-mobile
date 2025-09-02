class MembroFamiliarPut {
  int? beneficiary_id;
  String? name;
  int? relatednessId;
  int? gender;
  int? scholarityId;
  String? document;
  String? birthDate;

  MembroFamiliarPut(
      {
      this.beneficiary_id,  
      this.name,
      this.relatednessId,
      this.gender,
      this.scholarityId,
      this.document,
      this.birthDate});

  MembroFamiliarPut.fromJson(Map<String, dynamic> json) {
    beneficiary_id = json['beneficiary_id'];
    name = json['name'];
    relatednessId = json['relatedness_id'];
    gender = json['gender'];
    scholarityId = json['scholarity_id'];
    document = json['document'];
    birthDate = json['birth_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['beneficiary_id'] = beneficiary_id;
    data['name'] = name;
    data['relatedness_id'] = relatednessId;
    data['gender'] = gender;
    data['scholarity_id'] = scholarityId;
    data['document'] = document;
    data['birth_date'] = birthDate;
    return data;
  }
}
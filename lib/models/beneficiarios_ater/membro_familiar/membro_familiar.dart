class MembroFamiliar {
  int? id;
  int? beneficiaryId;
  String? name;
  int? relatednessId;
  int? gender;
  int? scholarityId;
  String? document;
  int? createdAt;
  int? updatedAt;
  int? createdBy;
  int? updatedBy;
  String? birthDate;
  String? genderText;

  MembroFamiliar(
      {this.id,
      this.beneficiaryId,
      this.name,
      this.relatednessId,
      this.gender,
      this.scholarityId,
      this.document,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.birthDate,
      this.genderText});

  MembroFamiliar.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    beneficiaryId = json['beneficiary_id'];
    name = json['name'];
    relatednessId = json['relatedness_id'];
    gender = json['gender'];
    scholarityId = json['scholarity_id'];
    document = json['document'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    birthDate = json['birth_date'];
    genderText = json['genderText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['beneficiary_id'] = beneficiaryId;
    data['name'] = name;
    data['relatedness_id'] = relatednessId;
    data['gender'] = gender;
    data['scholarity_id'] = scholarityId;
    data['document'] = document;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['birth_date'] = birthDate;
    data['genderText'] = genderText;
    return data;
  }
}
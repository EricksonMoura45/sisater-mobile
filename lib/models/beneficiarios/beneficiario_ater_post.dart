class BeneficiarioAterPost {
  int? id;
  String? document;
  String? name;
  int? type;
  String? street;
  String? number;
  String? complement;
  String? neighborhood;
  String? cityCode;
  String? postalCode;
  String? phone;
  String? cellphone;
  String? email;
  int? communityId;
  int? targetPublicId;
  bool? hasDap;
  String? nis;
  int? dapId;
  int? dapOriginId;
  String? caf;
  List<String>? reasonMultiples;
  int? officeId;
  int? registrationStatusId;
  PhysicalPerson? physicalPerson;

  BeneficiarioAterPost(
      {this.document,
      this.name,
      this.type,
      this.street,
      this.number,
      this.complement,
      this.neighborhood,
      this.cityCode,
      this.postalCode,
      this.phone,
      this.cellphone,
      this.email,
      this.communityId,
      this.targetPublicId,
      this.hasDap,
      this.nis,
      this.dapId,
      this.dapOriginId,
      this.caf,
      this.reasonMultiples,
      this.officeId,
      this.registrationStatusId,
      this.physicalPerson});

  BeneficiarioAterPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    document = json['document'];
    name = json['name'];
    type = json['type'];
    street = json['street'];
    number = json['number'];
    complement = json['complement'];
    neighborhood = json['neighborhood'];
    cityCode = json['city_code'];
    postalCode = json['postal_code'];
    phone = json['phone'];
    cellphone = json['cellphone'];
    email = json['email'];
    communityId = json['community_id'];
    targetPublicId = json['target_public_id'];
    hasDap = json['has_dap'];
    nis = json['nis'];
    dapId = json['dap_id'];
    dapOriginId = json['dap_origin_id'];
    caf = json['caf'];
    reasonMultiples = json['reason_multiples'].cast<String>();
    officeId = json['office_id'];
    registrationStatusId = json['registration_status_id'];
    physicalPerson = json['physicalPerson'] != null
        ? PhysicalPerson.fromJson(json['physicalPerson'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['document'] = document;
    data['name'] = name;
    data['type'] = type;
    data['street'] = street;
    data['number'] = number;
    data['complement'] = complement;
    data['neighborhood'] = neighborhood;
    data['city_code'] = cityCode;
    data['postal_code'] = postalCode;
    data['phone'] = phone;
    data['cellphone'] = cellphone;
    data['email'] = email;
    data['community_id'] = communityId;
    data['target_public_id'] = targetPublicId;
    data['has_dap'] = hasDap;
    data['nis'] = nis;
    data['dap_id'] = dapId;
    data['dap_origin_id'] = dapOriginId;
    data['caf'] = caf;
    data['reason_multiples'] = reasonMultiples;
    data['office_id'] = officeId;
    data['registration_status_id'] = registrationStatusId;
    if (physicalPerson != null) {
      data['physicalPerson'] = physicalPerson!.toJson();
    }
    return data;
  }
}

class PhysicalPerson {
  String? nickname;
  int? gender;
  int? civilStatus;
  int? nationalityId;
  int? naturalnessId;
  String? birthDate;
  String? nationalIdentity;
  String? issuingEntity;
  String? issuingUf;
  String? issueDate;
  int? scholarityId;
  String? mothersName;

  PhysicalPerson(
      {this.nickname,
      this.gender,
      this.civilStatus,
      this.nationalityId,
      this.naturalnessId,
      this.birthDate,
      this.nationalIdentity,
      this.issuingEntity,
      this.issuingUf,
      this.issueDate,
      this.scholarityId,
      this.mothersName});

  PhysicalPerson.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    gender = json['gender'];
    civilStatus = json['civil_status'];
    nationalityId = json['nationality_id'];
    naturalnessId = json['naturalness_id'];
    birthDate = json['birth_date'];
    nationalIdentity = json['national_identity'];
    issuingEntity = json['issuing_entity'];
    issuingUf = json['issuing_uf'];
    issueDate = json['issue_date'];
    scholarityId = json['scholarity_id'];
    mothersName = json['mothers_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nickname'] = nickname;
    data['gender'] = gender;
    data['civil_status'] = civilStatus;
    data['nationality_id'] = nationalityId;
    data['naturalness_id'] = naturalnessId;
    data['birth_date'] = birthDate;
    data['national_identity'] = nationalIdentity;
    data['issuing_entity'] = issuingEntity;
    data['issuing_uf'] = issuingUf;
    data['issue_date'] = issueDate;
    data['scholarity_id'] = scholarityId;
    data['mothers_name'] = mothersName;
    return data;
  }
}
class BeneficiarioAter {
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
  List<String>? reasonMultiples;
  int? officeId;
  int? registrationStatusId;
  int? createdAt;
  int? updatedAt;


  BeneficiarioAter(
      {id,
      document,
      name,
      type,
      street,
      number,
      complement,
      neighborhood,
      cityCode,
      postalCode,
      phone,
      cellphone,
      email,
      communityId,
      targetPublicId,
      hasDap,
      nis,
      dapId,
      dapOriginId,
      reasonMultiples,
      officeId,
      registrationStatusId,
      createdAt,
      updatedAt,
      });

  BeneficiarioAter.fromJson(Map<String, dynamic> json) {
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
    reasonMultiples = json['reason_multiples'].cast<String>();
    officeId = json['office_id'];
    registrationStatusId = json['registration_status_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
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
    data['reason_multiples'] = reasonMultiples;
    data['office_id'] = officeId;
    data['registration_status_id'] = registrationStatusId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
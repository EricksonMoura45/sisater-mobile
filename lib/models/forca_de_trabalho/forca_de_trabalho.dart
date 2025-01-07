class ForcaTrabalho {
  int? id;
  String? registry;
  String? name;
  String? email;
  String? phone;
  int? gender;
  String? document;
  String? nationalIdentity;
  String? issuingEntity;
  String? birthDate;
  int? capacityId;
  int? officeId;
  int? positionId;
  int? occupationId;
  int? functionalStatusId;
  String? address;
  String? postalCode;
  String? admissionDate;
  int? status;
  int? admin;
  int? createdAt;
  int? updatedAt;
  String? cbo;
  int? educationLevelId;
  int? admissionId;
  int? rewardFunctionId;
  int? linkTypeId;
  String? doe;
  int? integrationRegionId;

  ForcaTrabalho(
      {id,
      registry,
      name,
      email,
      phone,
      gender,
      document,
      nationalIdentity,
      issuingEntity,
      birthDate,
      capacityId,
      officeId,
      positionId,
      occupationId,
      functionalStatusId,
      address,
      postalCode,
      admissionDate,
      status,
      admin,
      createdAt,
      updatedAt,
      cbo,
      educationLevelId,
      admissionId,
      rewardFunctionId,
      linkTypeId,
      doe,
      integrationRegionId,
      });

  ForcaTrabalho.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    registry = json['registry'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    document = json['document'];
    nationalIdentity = json['national_identity'];
    issuingEntity = json['issuing_entity'];
    birthDate = json['birth_date'];
    capacityId = json['capacity_id'];
    officeId = json['office_id'];
    positionId = json['position_id'];
    occupationId = json['occupation_id'];
    functionalStatusId = json['functional_status_id'];
    address = json['address'];
    postalCode = json['postal_code'];
    admissionDate = json['admission_date'];
    status = json['status'];
    admin = json['admin'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cbo = json['cbo'];
    educationLevelId = json['education_level_id'];
    admissionId = json['admission_id'];
    rewardFunctionId = json['reward_function_id'];
    linkTypeId = json['link_type_id'];
    doe = json['doe'];
    integrationRegionId = json['integration_region_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['registry'] = registry;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['gender'] = gender;
    data['document'] = document;
    data['national_identity'] = nationalIdentity;
    data['issuing_entity'] = issuingEntity;
    data['birth_date'] = birthDate;
    data['capacity_id'] = capacityId;
    data['office_id'] = officeId;
    data['position_id'] = positionId;
    data['occupation_id'] = occupationId;
    data['functional_status_id'] = functionalStatusId;
    data['address'] = address;
    data['postal_code'] = postalCode;
    data['admission_date'] = admissionDate;
    data['status'] = status;
    data['admin'] = admin;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['cbo'] = cbo;
    data['education_level_id'] = educationLevelId;
    data['admission_id'] = admissionId;
    data['reward_function_id'] = rewardFunctionId;
    data['link_type_id'] = linkTypeId;
    data['doe'] = doe;
    data['integration_region_id'] = integrationRegionId;
    return data;
  }
}
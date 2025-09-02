import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater_post.dart';

class OrganizacaoAterPost {
  int? id;
  int? beneficiaryId;
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
  int? hasDap;
  int? nis;
  int? dapId;
  int? dapOriginId;
  bool? caf;
  List<String>? derivativesMultiples;
  List<String>? reasonMultiples;
  List<String>? productiveActivityMultiples;
  List<String>? productMultiples;
  List<String>? governmentProgramsMultiples;
  List<String>? targetPublicMultiples;
  int? officeId;
  int? registrationStatusId;
  SocialOrganization? socialOrganization;
  PhysicalPerson? physicalPerson;

  OrganizacaoAterPost(
      {this.id,
      this.beneficiaryId,
      this.document,
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
      this.socialOrganization,
      this.derivativesMultiples,
      this.productiveActivityMultiples,
      this.productMultiples,
      this.governmentProgramsMultiples,
      this.targetPublicMultiples,
      this.physicalPerson,

      });

  OrganizacaoAterPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    beneficiaryId = json['beneficiary_id'];
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
    derivativesMultiples = json['derivatives_multiples'] != null
        ? json['derivatives_multiples'].cast<String>()
        : [];
    productiveActivityMultiples = json['productive_activity_multiples'] != null
        ? json['productive_activity_multiples'].cast<String>()
        : [];
    productMultiples = json['product_multiples'] != null
        ? json['product_multiples'].cast<String>()
        : [];
    governmentProgramsMultiples = json['government_programs_multiples'] != null
        ? json['government_programs_multiples'].cast<String>()
        : [];
    targetPublicMultiples = json['target_public_multiples'] != null
        ? json['target_public_multiples'].cast<String>()
        : [];        
    officeId = json['office_id'];
    registrationStatusId = json['registration_status_id'];
    physicalPerson = json['physical_person'] != null
        ? PhysicalPerson.fromJson(json['physical_person'])
        : null;
    socialOrganization = json['socialOrganization'] != null
        ? SocialOrganization.fromJson(json['socialOrganization'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['beneficiary_id'] = beneficiaryId;
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
    data['derivatives_multiples'] = derivativesMultiples;
    data['productive_activity_multiples'] = productiveActivityMultiples;
    data['product_multiples'] = productMultiples;
    data['government_programs_multiples'] = governmentProgramsMultiples;
    data['target_public_multiples'] = targetPublicMultiples;
    if (physicalPerson != null) {
      data['physical_person'] = physicalPerson!.toJson();
    }
    data['registration_status_id'] = registrationStatusId;
    if (socialOrganization != null) {
      data['socialOrganization'] = socialOrganization!.toJson();
    }
    return data;
  }
}

class SocialOrganization {
  int? beneficiaryId;
  String? initials;
  int? organizationTypeId;
  int? numberOfAffiliated;
  String? responsibleName;
  

  SocialOrganization(
      {this.beneficiaryId,
      this.initials,
      this.organizationTypeId,
      this.numberOfAffiliated,
      this.responsibleName,
      });

  SocialOrganization.fromJson(Map<String, dynamic> json) {
    beneficiaryId = json['beneficiary_id'];
    initials = json['initials'];
    organizationTypeId = json['organization_type_id'];
    numberOfAffiliated = json['number_of_affiliated'];
    responsibleName = json['responsible_name'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['beneficiary_id'] = beneficiaryId;
    data['initials'] = initials;
    data['organization_type_id'] = organizationTypeId;
    data['number_of_affiliated'] = numberOfAffiliated;
    data['responsible_name'] = responsibleName;
    
    return data;
  }
}
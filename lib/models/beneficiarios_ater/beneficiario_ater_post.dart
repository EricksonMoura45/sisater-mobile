// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

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
  int? officeId;
  int? registrationStatusId;
  List<String>? derivativesMultiple;
  List<String>? reasonMultiples;
  List<String>? productiveActivityMultiples;
  List<String>? productMultiples = [];
  List<String>? governmentProgramsMultiples;
  List<String>? targetPublicMultiples;
  PhysicalPerson? physicalPerson;

  BeneficiarioAterPost({
    this.id,
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
    this.officeId,
    this.registrationStatusId,
    this.derivativesMultiple,
    this.reasonMultiples,
    this.productiveActivityMultiples,
    this.productMultiples,
    this.governmentProgramsMultiples,
    this.targetPublicMultiples,
    this.physicalPerson,
  });


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'document': document,
      'name': name,
      'type': type,
      'street': street,
      'number': number,
      'complement': complement,
      'neighborhood': neighborhood,
      'city_code': cityCode,
      'postalCode': postalCode,
      'phone': phone,
      'cellphone': cellphone,
      'email': email,
      'community_id': communityId,
      'target_public_id': targetPublicId,
      'has_dap': hasDap,
      'nis': nis,
      'dapId': dapId,
      'dap_origin_id': dapOriginId,
      'caf': caf,
      'reason_multiples': reasonMultiples,
      'officeId': officeId,
      'registration_status_id': registrationStatusId,
      'derivatives_multiple': derivativesMultiple,
      'productive_activity_multiples': productiveActivityMultiples,
      'product_multiples': productMultiples,
      'government_programs_multiples': governmentProgramsMultiples,
      'target_public_multiple': targetPublicMultiples,
      'physicalPerson': physicalPerson?.toJson(),
    };
  }

  factory BeneficiarioAterPost.fromJson(Map<String, dynamic> map) {
    return BeneficiarioAterPost(
      id: map['id'] != null ? map['id'] as int : null,
      document: map['document'] != null ? map['document'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      type: map['type'] != null ? map['type'] as int : null,
      street: map['street'] != null ? map['street'] as String : null,
      number: map['number'] != null ? map['number'] as String : null,
      complement: map['complement'] != null ? map['complement'] as String : null,
      neighborhood: map['neighborhood'] != null ? map['neighborhood'] as String : null,
      cityCode: map['city_code'] != null ? map['city_code'] as String : null,
      postalCode: map['postal_code'] != null ? map['postal_code'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      cellphone: map['cellphone'] != null ? map['cellphone'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      communityId: map['community_id'] != null ? map['community_id'] as int : null,
      targetPublicId: map['target_public_id'] != null ? map['target_public_id'] as int : null,
      hasDap: map['has_dap'] != null ? map['has_dap'] as bool : null,
      nis: map['nis'] != null ? map['nis'] as String : null,
      dapId: map['dap_id'] != null ? map['dap_id'] as int : null,
      dapOriginId: map['dap_origin_id'] != null ? map['dap_origin_id'] as int : null,
      caf: map['caf'] != null ? map['caf'] as String : null,
      reasonMultiples: map['reason_multiples'] != null ? List<String>.from((map['reason_multiples'] as List<String>)) : null,
      officeId: map['office_id'] != null ? map['office_id'] as int : null,
      registrationStatusId: map['registration_status_id'] != null ? map['registration_status_id'] as int : null,
      derivativesMultiple: map['derivatives_multiple'] != null ? List<String>.from((map['derivatives_multiple'] as List<String>)) : null,
      productiveActivityMultiples: map['productive_activity_multiples'] != null ? List<String>.from((map['productive_activity_multiples'] as List<String>)) : null,
      productMultiples: map['product_multiples'] != null ? List<String>.from((map['product_multiples'] as List<String>)) : null,
      governmentProgramsMultiples: map['government_programs_multiples'] != null ? List<String>.from((map['government_programs_multiples'] as List<String>)) : null,
      targetPublicMultiples: map['target_public_multiples'] != null ? List<String>.from((map['target_public_multiples'] as List<String>)) : null,
      physicalPerson: map['physicalPerson'] != null ? PhysicalPerson.fromJson(map['physicalPerson'] as Map<String,dynamic>) : null,
    );
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
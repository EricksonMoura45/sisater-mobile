class UsuarioDados {
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
  UsuarioDados(
      {this.id,
      this.registry,
      this.name,
      this.email,
      this.phone,
      this.gender,
      this.document,
      this.nationalIdentity,
      this.issuingEntity,
      this.birthDate,
      });

  UsuarioDados.fromJson(Map<String, dynamic> json) {
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
  }

}
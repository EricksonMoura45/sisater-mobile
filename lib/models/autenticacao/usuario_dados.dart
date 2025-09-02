class UsuarioDados {
  int? id;
  String? document;
  int? beneficiaryId;
  int? forcaTrabalhoId;
  int? status;
  int? admin;
  String? name;
  int? createdAt;
  String? officeName;
  bool? primeiroAcesso;
  int? updatedAt;
  String? perfil;
  String? cityCode;
  int? officeId;
  String? foto;

  UsuarioDados(
      {this.id,
      this.document,
      this.beneficiaryId,
      this.forcaTrabalhoId,
      this.status,
      this.admin,
      this.name,
      this.createdAt,
      this.officeName,
      this.primeiroAcesso,
      this.updatedAt,
      this.perfil,
      this.cityCode,
      this.officeId,
      this.foto});

  UsuarioDados.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    document = json['document'];
    beneficiaryId = json['beneficiary_id'];
    forcaTrabalhoId = json['forca_trabalho_id'];
    status = json['status'];
    admin = json['admin'];
    name = json['name'];
    createdAt = json['created_at'];
    officeName = json['office_name'];
    primeiroAcesso = json['primeiro_acesso'];
    updatedAt = json['updated_at'];
    perfil = json['perfil'];
    cityCode = json['city_code'];
    officeId = json['office_id'];
    foto = json['foto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['document'] = document;
    data['beneficiary_id'] = beneficiaryId;
    data['forca_trabalho_id'] = forcaTrabalhoId;
    data['status'] = status;
    data['admin'] = admin;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['office_name'] = officeName;
    data['primeiro_acesso'] = primeiroAcesso;
    data['updated_at'] = updatedAt;
    data['perfil'] = perfil;
    data['city_code'] = cityCode;
    data['office_id'] = officeId;
    data['foto'] = foto;
    return data;
  }
}
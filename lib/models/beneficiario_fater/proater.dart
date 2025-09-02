class Proater {
  int? id;
  int? officeId;
  int? capacityId;
  int? year;
  int? proaterNameId;
  String? subprojectName;
  String? generalObjective;
  String? specificObjective;
  int? createdAt;
  int? updatedAt;
  int? registrationStatusId;
  ProaterName? proaterName;

  Proater(
      {this.id,
      this.officeId,
      this.capacityId,
      this.year,
      this.proaterNameId,
      this.subprojectName,
      this.generalObjective,
      this.specificObjective,
      this.createdAt,
      this.updatedAt,
      this.registrationStatusId,
      this.proaterName});

  Proater.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    officeId = json['office_id'];
    capacityId = json['capacity_id'];
    year = json['year'];
    proaterNameId = json['proater_name_id'];
    subprojectName = json['subproject_name'];
    generalObjective = json['general_objective'];
    specificObjective = json['specific_objective'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    registrationStatusId = json['registration_status_id'];
    proaterName = json['proaterName'] != null
        ? ProaterName.fromJson(json['proaterName'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['office_id'] = officeId;
    data['capacity_id'] = capacityId;
    data['year'] = year;
    data['proater_name_id'] = proaterNameId;
    data['subproject_name'] = subprojectName;
    data['general_objective'] = generalObjective;
    data['specific_objective'] = specificObjective;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['registration_status_id'] = registrationStatusId;
    if (proaterName != null) {
      data['proaterName'] = proaterName!.toJson();
    }
    return data;
  }
}

class ProaterName {
  int? id;
  String? name;

  ProaterName(
      {this.id, this.name, int? code});

  ProaterName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;

    return data;
  }
}
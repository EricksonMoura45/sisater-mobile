import 'dart:ffi';

class ComunidadesList {

  int? id;
  String? name;
  String? description;
  String? cityCode;
  int? createdAt;
  int? updatedAt;
  //double? distance;
  String? unit;
  int? accessType;
  String? accessTypeText;

  ComunidadesList(
      {this.id,
      this.name,
      this.description,
      this.cityCode,
      this.createdAt,
      this.updatedAt,
      //this.distance,
      this.unit,
      this.accessTypeText});

  ComunidadesList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    cityCode = json['city_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    //distance = json['distance'] as double;
    unit = json['unit'];
    accessType = json['accessType'];
    accessTypeText = json['accessTypeText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['city_code'] = cityCode;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    //data['distance'] = distance;
    data['unit'] = unit;
    data['accessType'] = accessType;
    data['accessTypeText'] = accessTypeText;
    return data;
  }
}
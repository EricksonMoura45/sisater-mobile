class ComunidadesPost {
  int? id;
  String? name;
  String? description;
  String? cityCode;
  String? distance;
  String? unit;
  int? accessType;

  ComunidadesPost(
      {this.name,
      this.id,
      this.description,
      this.cityCode,
      this.distance,
      this.unit,
      this.accessType});

  ComunidadesPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    cityCode = json['city_code'];
    distance = json['distance'];
    unit = json['unit'];
    accessType = json['access_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['description'] = description;
    data['city_code'] = cityCode;
    data['distance'] = distance;
    data['unit'] = unit;
    data['access_type'] = accessType;
    return data;
  }
}
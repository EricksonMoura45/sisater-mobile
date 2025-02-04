class Comunidade {
  int? id;
  String? name;
  String? cityCode;

  Comunidade(
      {this.id,
      this.name,
      this.cityCode,
      });

  Comunidade.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    cityCode = json['city_code'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id?? '';
    data['name'] = name?? '';
    data['city_code'] = cityCode?? '';
    return data;
  }
}
class Eslocs {
  int? id;
  int? capacityId;
  String? name;
  String? street;
  String? number;
  String? complement;
  String? neighborhood;
  String? cityCode;
  String? postalCode;

  Eslocs(
      {this.id,
      this.capacityId,
      this.name,
      this.street,
      this.number,
      this.complement,
      this.neighborhood,
      this.cityCode,
      this.postalCode});

  Eslocs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    capacityId = json['capacity_id'];
    name = json['name'];
    street = json['street'];
    number = json['number'];
    complement = json['complement'];
    neighborhood = json['neighborhood'];
    cityCode = json['city_code'];
    postalCode = json['postal_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['capacity_id'] = capacityId;
    data['name'] = name;
    data['street'] = street;
    data['number'] = number;
    data['complement'] = complement;
    data['neighborhood'] = neighborhood;
    data['city_code'] = cityCode;
    data['postal_code'] = postalCode;
    return data;
  }
}
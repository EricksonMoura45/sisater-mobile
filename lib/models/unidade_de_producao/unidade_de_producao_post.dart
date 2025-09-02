class UnidadeDeProducaoPost {
  bool? isFisherman;
  ProductionUnitNormal? productionUnitNormal;

  UnidadeDeProducaoPost({this.isFisherman, this.productionUnitNormal});

  UnidadeDeProducaoPost.fromJson(Map<String, dynamic> json) {
    isFisherman = json['is_fisherman'];
    productionUnitNormal = json['productionUnitNormal'] != null
        ? ProductionUnitNormal.fromJson(json['productionUnitNormal'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_fisherman'] = isFisherman;
    if (productionUnitNormal != null) {
      data['productionUnitNormal'] = productionUnitNormal!.toJson();
    }
    return data;
  }
}

class ProductionUnitNormal {
  String? name;
  String? accessDetails;
  int? communityId;
  int? agroecologicalTransitionId;
  int? domainId;
  dynamic legalArea;
  dynamic realArea;
  int? hasCar;
  int? hasSafe;
  int? electricPowerId;
  int? waterSupplyId;
  dynamic preservationArea;
  dynamic temporaryCultivationArea;
  dynamic permanentCultivationArea;
  dynamic pastureArea;
  dynamic legalReserveArea;
  dynamic otherArea;
  String? street;
  String? number;
  String? complement;
  String? neighborhood;
  String? cityCode;
  String? postalCode;

  ProductionUnitNormal(
      {this.name,
      this.accessDetails,
      this.communityId,
      this.agroecologicalTransitionId,
      this.domainId,
      this.legalArea,
      this.realArea,
      this.hasCar,
      this.hasSafe,
      this.electricPowerId,
      this.waterSupplyId,
      this.preservationArea,
      this.temporaryCultivationArea,
      this.permanentCultivationArea,
      this.pastureArea,
      this.legalReserveArea,
      this.otherArea,
      this.street,
      this.number,
      this.complement,
      this.neighborhood,
      this.cityCode,
      this.postalCode});

  ProductionUnitNormal.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    accessDetails = json['access_details'];
    communityId = json['community_id'];
    agroecologicalTransitionId = json['agroecological_transition_id'];
    domainId = json['domain_id'];
    legalArea = json['legal_area'];
    realArea = json['real_area'];
    hasCar = json['has_car'];
    hasSafe = json['has_safe'];
    electricPowerId = json['electric_power_id'];
    waterSupplyId = json['water_supply_id'];
    preservationArea = json['preservation_area'];
    temporaryCultivationArea = json['temporary_cultivation_area'];
    permanentCultivationArea = json['permanent_cultivation_area'];
    pastureArea = json['pasture_area'];
    legalReserveArea = json['legal_reserve_area'];
    otherArea = json['other_area'];
    street = json['street'];
    number = json['number'];
    complement = json['complement'];
    neighborhood = json['neighborhood'];
    cityCode = json['city_code'];
    postalCode = json['postal_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['access_details'] = accessDetails;
    data['community_id'] = communityId;
    data['agroecological_transition_id'] = agroecologicalTransitionId;
    data['domain_id'] = domainId;
    data['legal_area'] = legalArea;
    data['real_area'] = realArea;
    data['has_car'] = hasCar;
    data['has_safe'] = hasSafe;
    data['electric_power_id'] = electricPowerId;
    data['water_supply_id'] = waterSupplyId;
    data['preservation_area'] = preservationArea;
    data['temporary_cultivation_area'] = temporaryCultivationArea;
    data['permanent_cultivation_area'] = permanentCultivationArea;
    data['pasture_area'] = pastureArea;
    data['legal_reserve_area'] = legalReserveArea;
    data['other_area'] = otherArea;
    data['street'] = street;
    data['number'] = number;
    data['complement'] = complement;
    data['neighborhood'] = neighborhood;
    data['city_code'] = cityCode;
    data['postal_code'] = postalCode;
    return data;
  }
}
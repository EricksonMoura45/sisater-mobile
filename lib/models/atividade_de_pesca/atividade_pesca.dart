
class AtividadePesca {
  int? id;
  bool? isFisherman;
  int? created_at; 
  Fisherman? fisherman;

  AtividadePesca({
    this.id,
    this.isFisherman,
    this.created_at,
    this.fisherman,
  });

  AtividadePesca.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    
    isFisherman = json['is_fisherman'];
    fisherman = json['fisherman'] != null
        ? Fisherman.fromJson(json['fisherman'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = created_at;
    data['is_fisherman'] = isFisherman;
    if (fisherman != null) {
      data['fisherman'] = fisherman!.toJson();
    }
    return data;
  }
}

class Fisherman {
  int? beneficiaryId;
  String? currentVesselName;
  String? previousVesselName;
  int? length;
  String? beam;
  String? depth;
  String? netTon;
  String? grossTon;
  String? hullMaterial;
  int? constructionYear;
  String? currentStatus;
  int? crewNumber;
  String? propulsion;
  String? captaincyRegistration;

  Fisherman(
      {this.beneficiaryId,
      this.currentVesselName,
      this.previousVesselName,
      this.length,
      this.beam,
      this.depth,
      this.netTon,
      this.grossTon,
      this.hullMaterial,
      this.constructionYear,
      this.currentStatus,
      this.crewNumber,
      this.propulsion,
      this.captaincyRegistration});

  Fisherman.fromJson(Map<String, dynamic> json) {
    beneficiaryId = json['beneficiary_id'];
    currentVesselName = json['current_vessel_name'];
    previousVesselName = json['previous_vessel_name'];
    length = json['length'];
    beam = json['beam'];
    depth = json['depth'];
    netTon = json['net_ton'];
    grossTon = json['gross_ton'];
    hullMaterial = json['hull_material'];
    constructionYear = json['construction_year'];
    currentStatus = json['current_status'];
    crewNumber = json['crew_number'];
    propulsion = json['propulsion'];
    captaincyRegistration = json['captaincy_registration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['beneficiary_id'] = beneficiaryId;
    data['current_vessel_name'] = currentVesselName;
    data['previous_vessel_name'] = previousVesselName;
    data['length'] = length.toString();
    data['beam'] = beam;
    data['depth'] = depth;
    data['net_ton'] = netTon;
    data['gross_ton'] = grossTon;
    data['hull_material'] = hullMaterial;
    data['construction_year'] = constructionYear.toString();
    data['current_status'] = currentStatus;
    data['crew_number'] = crewNumber.toString();
    data['propulsion'] = propulsion;
    data['captaincy_registration'] = captaincyRegistration;
    return data;
  }
}
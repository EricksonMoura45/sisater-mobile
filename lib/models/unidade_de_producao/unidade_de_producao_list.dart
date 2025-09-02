import 'package:sisater_mobile/models/unidade_de_producao/unidade_de_producao_post.dart';

class UnidadedeProducaoList {
  int? id;
  bool? isFisherman;
  int? createdAt;
  int? updatedAt;
  int? deletedAt;
  ProductionUnitNormal? productionUnitNormal;

  UnidadedeProducaoList(
      {this.id,
      this.isFisherman,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.productionUnitNormal});

  UnidadedeProducaoList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isFisherman = json['is_fisherman'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    productionUnitNormal = json['productionUnitNormal'] != null
        ? ProductionUnitNormal.fromJson(json['productionUnitNormal'])
        : null;
  }

  Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_fisherman'] = isFisherman;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (productionUnitNormal != null) {
      data['productionUnitNormal'] = productionUnitNormal!.toJson();
    }
    return data;
  }
}

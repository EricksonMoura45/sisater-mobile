class BeneficiarioFaterPost {

  int? year;
  String? actionDate;
  String? cityCode;
  String? communities;
  int? methodId;
  int? proaterId;
  String? description;
  String? partnerships;
  String? participatingTechnicians;
  int? officeId;
  List<String>? beneficiaryMultiples;
  List<String>? productMultiples;
  List<String>? goalMultiples;
  List<String>? actionProductMultiples;
  List<String>? toolMultiples;
  List<String>? techniqueMultiples;
  List<String>? participatingTechniciansMultiples;
  FaterBeneficiary? faterBeneficiary;
  List<Insumo>? insumo;
  List<AtividadeAssuntos>? atividadeAssuntos;
  List<String>? fotos;

  BeneficiarioFaterPost(
      {this.year,
      this.actionDate,
      this.cityCode,
      this.communities,
      this.methodId,
      this.proaterId,
      this.description,
      this.partnerships,
      this.participatingTechnicians,
      this.officeId,
      this.beneficiaryMultiples,
      this.productMultiples,
      this.goalMultiples,
      this.actionProductMultiples,
      this.toolMultiples,
      this.techniqueMultiples,
      this.participatingTechniciansMultiples,
      this.faterBeneficiary,
      this.insumo,
      this.atividadeAssuntos,
      this.fotos});

  BeneficiarioFaterPost.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    actionDate = json['action_date'];
    cityCode = json['city_code'];
    communities = json['communities'];
    methodId = json['method_id'];
    proaterId = json['proater_id'];
    description = json['description'];
    partnerships = json['partnerships'];
    participatingTechnicians = json['participating_technicians'];
    officeId = json['office_id'];
    beneficiaryMultiples = json['beneficiary_multiples'].cast<String>();
    productMultiples = json['product_multiples'].cast<String>();
    goalMultiples = json['goal_multiples'].cast<String>();
    actionProductMultiples = json['action_product_multiples'].cast<String>();
    toolMultiples = json['tool_multiples'].cast<String>();
    techniqueMultiples = json['technique_multiples'].cast<String>();
    participatingTechniciansMultiples =
        json['participating_technicians_multiples'].cast<String>();
    faterBeneficiary = json['faterBeneficiary'] != null
        ? FaterBeneficiary.fromJson(json['faterBeneficiary'])
        : null;
    insumo = json['insumo'].cast<Insumo>();
    atividadeAssuntos = json['atividadeAssuntos'].cast<AtividadeAssuntos>();
    fotos = json['fotos'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['year'] = year;
    data['action_date'] = actionDate;
    data['city_code'] = cityCode;
    data['communities'] = communities;
    data['method_id'] = methodId;
    data['proater_id'] = proaterId;
    data['description'] = description;
    data['partnerships'] = partnerships;
    data['participating_technicians'] = participatingTechnicians;
    data['office_id'] = officeId;
    data['beneficiary_multiples'] = beneficiaryMultiples;
    data['product_multiples'] = productMultiples;
    data['goal_multiples'] = goalMultiples;
    data['action_product_multiples'] = actionProductMultiples;
    data['tool_multiples'] = toolMultiples;
    data['technique_multiples'] = techniqueMultiples;
    data['participating_technicians_multiples'] =
        participatingTechniciansMultiples;
    if (faterBeneficiary != null) {
      data['faterBeneficiary'] = faterBeneficiary!.toJson();
    }
    //TODO
    // if (insumo != null) {
    //   data['insumo'] = insumo!.map((e) => e.toJson()).toList();
    // }
    // if (atividadeAssuntos != null) {
    //   data['atividadeAssuntos'] = atividadeAssuntos!.map((e) => e.toJson()).toList();
    // }
    data['fotos'] = fotos;
            return data;
  }
}

class FaterBeneficiary {
  List<String>? finalityMultiples;

  FaterBeneficiary({this.finalityMultiples});

  FaterBeneficiary.fromJson(Map<String, dynamic> json) {
    finalityMultiples = json['finality_multiples'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['finality_multiples'] = finalityMultiples;
    return data;
  }
}

class Insumo {
  int? id;
  List<InsumoDetalhado>? insumoDetalhado;

  Insumo({this.id, this.insumoDetalhado});

  Insumo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    insumoDetalhado = json['insumoDetalhado'].cast<InsumoDetalhado>();
  }
}

class InsumoDetalhado{
  String? descricao;
  int? amount;
  int? unit_of_measure_id;

  InsumoDetalhado({this.descricao, this.amount, this.unit_of_measure_id});

  InsumoDetalhado.fromJson(Map<String, dynamic> json) {
    descricao = json['descricao'];
    amount = json['amount'];
    unit_of_measure_id = json['unit_of_measure_id'];
  }
}

class AtividadeAssuntos {
  int? id;
  List<AtividadeAssuntoDetalhado>? atividadeAssuntoDetalhado;

  AtividadeAssuntos({this.id, this.atividadeAssuntoDetalhado});

  AtividadeAssuntos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    atividadeAssuntoDetalhado = json['atividadeAssuntoDetalhado'].cast<AtividadeAssuntoDetalhado>();
  }
}

class AtividadeAssuntoDetalhado {
  int? product_id;
  String? situacao;
  String? recomendacoes;
  AtividadeAssuntoDetalhado({this.product_id, this.situacao, this.recomendacoes});

  AtividadeAssuntoDetalhado.fromJson(Map<String, dynamic> json) {
    product_id = json['product_id'];
    situacao = json['situacao'];
    recomendacoes = json['recomendacoes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = product_id;
    data['situacao'] = situacao;
    data['recomendacoes'] = recomendacoes;
    return data;
  }
}


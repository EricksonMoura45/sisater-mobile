class SubProduto {
  int? id;
  String? name;
  int? productId;

  SubProduto({this.id, this.name, this.productId});

  SubProduto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['product_id'] = productId;
    return data;
  }
}
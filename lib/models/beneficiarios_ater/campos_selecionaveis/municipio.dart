class Municipio {
  String? code;
  String? name;
  String? ufCode;

  Municipio({this.code, this.name, this.ufCode});

  Municipio.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? '';
    name = json['name'] ?? '';
    ufCode = json['uf_code'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['uf_code'] = ufCode;
    return data;
  }
}
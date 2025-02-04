class UF {
  String? code;
  String? name;

  UF({this.code, this.name});

  UF.fromJson(Map<String, dynamic> json) {
    code = json['code']?? '';
    name = json['name']?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code ?? '';
    data['name'] = name?? '';
    return data;
  }
}
class ComunidadeSelecionavel {

  String? code;
  String? name;
  String? uf_code;

  ComunidadeSelecionavel({
    this.code,
    this.name,
    this.uf_code,
  });

  ComunidadeSelecionavel.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? '';
    name = json['name'] ?? '';
    uf_code = json['uf_code'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code?? '';
    data['name'] = name?? '';
    data['uf_code'] = uf_code?? '';
    return data;
  }
}
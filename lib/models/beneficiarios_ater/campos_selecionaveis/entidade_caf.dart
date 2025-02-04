class EntidadeCaf {
  int? id;
  String? name;

  EntidadeCaf({this.id, this.name});

  EntidadeCaf.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
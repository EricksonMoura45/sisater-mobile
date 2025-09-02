class OfflineData {
  final List<dynamic> municipios;
  final List<dynamic> eslocs;
  final List<dynamic> produtos;
  final List<dynamic> metodos;
  final List<dynamic> finalidadesAtendimento;
  final List<dynamic> tecnicas;
  final List<dynamic> politicas;
  final List<dynamic> tecnicosEmater;
  final List<dynamic> proater;
  final List<dynamic> unidadesMedida;
  final DateTime lastUpdate;

  OfflineData({
    required this.municipios,
    required this.eslocs,
    required this.produtos,
    required this.metodos,
    required this.finalidadesAtendimento,
    required this.tecnicas,
    required this.politicas,
    required this.tecnicosEmater,
    required this.proater,
    required this.unidadesMedida,
    required this.lastUpdate,
  });

  Map<String, dynamic> toJson() {
    return {
      'municipios': municipios,
      'eslocs': eslocs,
      'produtos': produtos,
      'metodos': metodos,
      'finalidadesAtendimento': finalidadesAtendimento,
      'tecnicas': tecnicas,
      'politicas': politicas,
      'tecnicosEmater': tecnicosEmater,
      'proater': proater,
      'unidadesMedida': unidadesMedida,
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }

  factory OfflineData.fromJson(Map<String, dynamic> json) {
    return OfflineData(
      municipios: json['municipios'] ?? [],
      eslocs: json['eslocs'] ?? [],
      produtos: json['produtos'] ?? [],
      metodos: json['metodos'] ?? [],
      finalidadesAtendimento: json['finalidadesAtendimento'] ?? [],
      tecnicas: json['tecnicas'] ?? [],
      politicas: json['politicas'] ?? [],
      tecnicosEmater: json['tecnicosEmater'] ?? [],
      proater: json['proater'] ?? [],
      unidadesMedida: json['unidadesMedida'] ?? [],
      lastUpdate: DateTime.parse(json['lastUpdate']),
    );
  }
}

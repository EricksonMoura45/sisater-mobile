class OfflineBeneficiarioFater {
  final String id;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final bool isSynced;

  OfflineBeneficiarioFater({
    required this.id,
    required this.data,
    required this.createdAt,
    this.isSynced = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  factory OfflineBeneficiarioFater.fromJson(Map<String, dynamic> json) {
    return OfflineBeneficiarioFater(
      id: json['id'],
      data: json['data'],
      createdAt: DateTime.parse(json['createdAt']),
      isSynced: json['isSynced'] ?? false,
    );
  }
}

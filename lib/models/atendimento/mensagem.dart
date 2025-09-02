class Mensagem {
  
  int? id;
  int? conversationId;
  int? userId;
  String? message;
  String? createdAt;

  Mensagem(
      {this.id,
      this.conversationId,
      this.userId,
      this.message,
      this.createdAt});

  Mensagem.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '');
    conversationId = json['conversation_id'] is int ? json['conversation_id'] : int.tryParse(json['conversation_id']?.toString() ?? '');
    userId = json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? '');
    message = json['message']?.toString();
    createdAt = json['created_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['conversation_id'] = conversationId;
    data['user_id'] = userId;
    data['message'] = message;
    data['created_at'] = createdAt;
    return data;
  }
}
// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatCard {
  int? id;
  int? creatorId;
  String? title;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? beneficiario;
  String? tecnico;
  UltimaMensagem? ultimaMensagem;



  ChatCard(
      {this.id,
      this.creatorId,
      this.title,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.beneficiario,
      this.tecnico,
      this.ultimaMensagem});

  ChatCard.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '');
    creatorId = json['creator_id'] is int ? json['creator_id'] : int.tryParse(json['creator_id']?.toString() ?? '');
    title = json['title']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    beneficiario = json['beneficiario']?.toString();
    tecnico = json['tecnico']?.toString();
    ultimaMensagem = json['ultimaMensagem'] != null 
        ? UltimaMensagem.fromJson(json['ultimaMensagem'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['creator_id'] = creatorId;
    data['title'] = title;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['beneficiario'] = beneficiario;
    data['tecnico'] = tecnico;
    data['ultimaMensagem'] = ultimaMensagem?.toJson();
    return data;
  }

  
}

class UltimaMensagem {

    int? id;
    String? message;

  UltimaMensagem({
    this.id,
    this.message,
  });

  UltimaMensagem.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '');
    message = json['message']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    return data;
  }
    
}

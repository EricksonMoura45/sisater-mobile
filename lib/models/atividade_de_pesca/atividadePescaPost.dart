// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:sisater_mobile/models/atividade_de_pesca/atividade_pesca.dart';

class AtividadePescaPost {
  Fisherman? fisherman;

  AtividadePescaPost({
    this.fisherman,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'fisherman': fisherman?.toJson(),
    };
  }

  factory AtividadePescaPost.fromJson(Map<String, dynamic> map) {
    return AtividadePescaPost(
      fisherman: map['fisherman'] != null ? Fisherman.fromJson(map['fisherman'] as Map<String,dynamic>) : null,
    );
  }

}

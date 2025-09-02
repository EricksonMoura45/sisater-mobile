// ignore_for_file: public_member_api_docs, sort_constructors_first

class Prontuario {
  bool? sucess;
  String? message;
  Data? data;
  
  Prontuario({
    this.sucess,
    this.message,
    this.data,
  });


  factory Prontuario.fromJson(Map<String, dynamic> map) {
    return Prontuario(
      sucess: map['sucess'] as bool?,
      message: map['message'] as String?,
      data: map['data'] != null ? Data.fromJson(map['data'] as Map<String, dynamic>) : null,
    );
  }
}

class Data {

  String? beneficiary_name;
  String? generated_at;
  String? pdf_base64;
  String? filename;

  Data({
    this.beneficiary_name,
    this.generated_at,
    this.pdf_base64,
    this.filename,
  });
  

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'beneficiary_name': beneficiary_name,
      'generated_at': generated_at,
      'pdf_base64': pdf_base64,
      'filename': filename,
    };
  }

  factory Data.fromJson(Map<String, dynamic> map) {
    return Data(
      beneficiary_name: map['beneficiary_name'] != null ? map['beneficiary_name'] as String : null,
      generated_at: map['generated_at'] != null ? map['generated_at'] as String : null,
      pdf_base64: map['pdf_base64'] != null ? map['pdf_base64'] as String : null,
      filename: map['filename'] != null ? map['filename'] as String : null,
    );
  }


}

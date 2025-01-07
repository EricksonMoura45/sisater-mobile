class LoginPost {
  String? grantType;
  String? document;
  String? password;
  String? clientId;
  String? clientSecret;

  LoginPost(
      {this.grantType,
      this.document,
      this.password,
      this.clientId,
      this.clientSecret});

  LoginPost.fromJson(Map<String, dynamic> json) {
    grantType = json['grant_type'];
    document = json['document'];
    password = json['password'];
    clientId = json['client_id'];
    clientSecret = json['client_secret'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['grant_type'] = grantType;
    data['document'] = document;
    data['password'] = password;
    data['client_id'] = clientId;
    data['client_secret'] = clientSecret;
    return data;
  }
}
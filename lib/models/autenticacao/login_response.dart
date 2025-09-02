class LoginResponse {
  String? accessToken;
  int? expiresIn;
  String? tokenType;
  String? scope;
  String? refreshToken;

  LoginResponse(
      {this.accessToken,
      this.expiresIn,
      this.tokenType,
      this.scope,
      this.refreshToken});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    expiresIn = json['expires_in'];
    tokenType = json['token_type'];
    scope = json['scope'];
    refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['expires_in'] = expiresIn;
    data['token_type'] = tokenType;
    data['scope'] = scope;
    data['refresh_token'] = refreshToken;
    return data;
  }
}
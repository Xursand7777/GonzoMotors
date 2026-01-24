class CreateUserModel {
  final String? accessToken;
  final String? refreshToken;
  final DateTime? exp;

  CreateUserModel({
    this.accessToken,
    this.refreshToken,
    this.exp
  });

  factory CreateUserModel.fromJson(Map<String, dynamic> json) {
    return CreateUserModel(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      exp: json['exp'] != null ? DateTime.tryParse(json['exp']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'exp': exp
    };
  }
}

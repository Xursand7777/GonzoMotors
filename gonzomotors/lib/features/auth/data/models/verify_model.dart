class VerifyModel {
  final String? accessToken;
  final String? refreshToken;
  final String? temporaryToken;
  final String? exp;

  VerifyModel({this.accessToken, this.refreshToken, this.temporaryToken, this.exp});

  factory VerifyModel.fromJson(Map<String, dynamic> json) => VerifyModel(
    accessToken: json['accessToken'] as String?,
    refreshToken: json['refreshToken'] as String?,
    temporaryToken: json['temporaryToken'] as String?,
    exp: json['exp'] as String?,
  );
}

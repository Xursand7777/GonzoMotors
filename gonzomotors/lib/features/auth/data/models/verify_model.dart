class VerifyModel {
  String? accessToken;
  String? refreshToken;
  dynamic temporaryToken;

  VerifyModel({this.accessToken, this.temporaryToken, this.refreshToken});
  factory VerifyModel.fromJson(Map<String,dynamic> json)=>VerifyModel(
    accessToken: json['access_token'] as String?,
    refreshToken: json['refresh_token'] as String?,
    temporaryToken: json['temporary_token'] as String?,
  );
}

import '../../../../core/network/base_repository.dart';
import '../../../../core/network/models/api_response.dart';
import '../../../../core/services/firebase_token.service.dart';
import '../../../../core/services/token_service.dart';
import '../models/create_user_model.dart';
import '../models/verify_model.dart';


abstract class AuthRepository extends BaseRepository {
  AuthRepository(super.dio);

  Future<void> sendPhoneVerification({Map<String, dynamic>? query});

  Future<bool> verifyOtpCode({
    Map<String, dynamic>? query,
  });

  Future<ApiResponse<CreateUserModel?>> registerUserProfile({
    Map<String, dynamic>? query,
  });

  Future<ApiResponse<dynamic>> resendOtpCode({
    required String phoneNumber,
  });

}

class AuthRepositoryImpl extends AuthRepository {
  final FirebaseTokenService _fcmService;
  final TokenService _tokenService;

  AuthRepositoryImpl(super.dio, this._fcmService, this._tokenService);

  @override
  Future<ApiResponse<CreateUserModel?>> registerUserProfile({
    Map<String, dynamic>? query,
  }) async {
    // final fcmToken = await FirebaseTokenService.getFCMToken();
    final Map<String, dynamic> header = {};
    // if (fcmToken != null && fcmToken.isNotEmpty) {
    //   header['fcm_token'] = fcmToken;
    // }
    final token = await _tokenService.getToken();

    if (token != null && token.isNotEmpty) {
      header['Authorization'] = 'Bearer $token';
    }
    print('➡️ Headers to send: $header');
    return await post('MobileUser/create',
        fromJson: (json) => CreateUserModel.fromJson(json),
        data: query,
        headers: header);
  }

  @override
  Future<void> sendPhoneVerification({Map<String, dynamic>? query}) async {
    final fcmToken = await FirebaseTokenService.getFCMToken();
    final Map<String, dynamic> header = {};
    // if (fcmToken != null && fcmToken.isNotEmpty) {
    //   header['fcm_token'] = fcmToken;
    // }
    return await postNoContent('MobileUser/send-sms', data: query);
  }

  @override
  Future<bool> verifyOtpCode({Map<String, dynamic>? query}) async {
    return await postRaw<bool>(
      'MobileUser/validate-sms',
      data: query,
    );
  }



  @override
  Future<ApiResponse> resendOtpCode({required String phoneNumber}) {
    return Future<ApiResponse>.delayed(
      const Duration(seconds: 2),
          () => ApiResponse(
        success: true,
        statusCode: 200,
        message: "OTP code resent successfully",
        data: {
          'phoneNumber': phoneNumber,
        },
      ),
    );
  }
}

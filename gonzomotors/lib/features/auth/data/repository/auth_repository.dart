import '../../../../core/network/base_repository.dart';
import '../../../../core/network/models/api_response.dart';
import '../models/create_user_model.dart';



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
  AuthRepositoryImpl(super.dio);

  @override
  Future<ApiResponse<CreateUserModel?>> registerUserProfile({
    Map<String, dynamic>? query,
  }) async {
    final Map<String, dynamic> header = {};
    print('➡️ Headers to send: $header');
    return await post('MobileUser/create',
        fromJson: (json) => CreateUserModel.fromJson(json),
        data: query);
  }

  @override
  Future<void> sendPhoneVerification({Map<String, dynamic>? query}) async {
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

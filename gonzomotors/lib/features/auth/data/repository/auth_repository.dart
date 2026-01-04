import '../../../../core/network/base_repository.dart';
import '../../../../core/network/models/api_response.dart';
import '../../../../core/services/firebase_token.service.dart';
import '../models/verify_model.dart';

abstract class AuthRepository extends BaseRepository {
  AuthRepository(super.dio);

  Future<void> sendPhoneVerification({Map<String, dynamic>? query});

  Future<ApiResponse<VerifyModel?>> verifyOtpCode({
    Map<String, dynamic>? query,
  });

  Future<ApiResponse<VerifyModel?>> registerUserProfile({
    Map<String, dynamic>? query,
  });

  Future<ApiResponse<dynamic>> resendOtpCode({
    required String phoneNumber,
  });

  // Future<ApiResponse<CreateStudentModel?>> createStudent({
  //   Map<String, dynamic>? query,
  // });
  //
  // Future<ApiResponse<CreateStudentModel?>> updateStudent(
  //     {Map<String, dynamic>? query});
}

class AuthRepositoryImpl extends AuthRepository {
  final FirebaseTokenService _fcmService;

  AuthRepositoryImpl(super.dio, this._fcmService);

  @override
  Future<ApiResponse<VerifyModel?>> registerUserProfile({
    Map<String, dynamic>? query,
  }) async {
    final fcmToken = await FirebaseTokenService.getFCMToken();
    final Map<String, dynamic> header = {};
    if (fcmToken != null && fcmToken.isNotEmpty) {
      header['fcm_token'] = fcmToken;
    }

    return await post('auth/register',
        fromJson: (json) => VerifyModel.fromJson(json),
        data: query,
        headers: header);
  }

  @override
  Future<void> sendPhoneVerification({Map<String, dynamic>? query}) async {
    final fcmToken = await FirebaseTokenService.getFCMToken();
    final Map<String, dynamic> header = {};
    if (fcmToken != null && fcmToken.isNotEmpty) {
      header['fcm_token'] = fcmToken;
    }
    return await postNoContent('auth/send-otp', data: query, headers: header);
  }

  @override
  Future<ApiResponse<VerifyModel?>> verifyOtpCode(
      {Map<String, dynamic>? query}) async {
    return await post('auth/otp/login',
        fromJson: (json) => VerifyModel.fromJson(json), data: query);
/*
    return Future<ApiResponse<UserModel?>>.delayed(
      const Duration(seconds: 2),
      () => ApiResponse(
          success: true,
          statusCode: 200,
          message: "OTP code verified successfully",
          data: const UserModel(id: '', name: '', email: '')),
    );*/
    // TODO: implement verifyOtpCode
    throw UnimplementedError();
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

  // @override
  // Future<ApiResponse<CreateStudentModel?>> createStudent(
  //     {Map<String, dynamic>? query}) async {
  //   return await post('user/student',
  //       fromJson: (json) => CreateStudentModel.fromJson(json), data: query);
  // }
  //
  // @override
  // Future<ApiResponse<CreateStudentModel?>> updateStudent({Map<String, dynamic>? query}) {
  //   return put('user/student/update',
  //       fromJson: (json) => CreateStudentModel.fromJson(json), data: query);
  // }
}

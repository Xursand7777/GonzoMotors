
import 'package:dio/dio.dart';
import '../../../../core/log/talker_logger.dart';
import '../../../../core/network/base_repository.dart';

abstract class VerificationRepository extends BaseRepository {
  VerificationRepository(super.dio);

  Future<void> postPhoneNumber(String phoneNumber);


  Future<Response> loginVerification({
    required String phoneNumber,
    required String code,
  });
}

class VerificationRepositoryImpl extends VerificationRepository {
  VerificationRepositoryImpl(super.dio);

  @override
  Future<void> postPhoneNumber(String phoneNumber) async {
    try {
      final response = await dio.post(
        "MobileUser/send-sms",
        data: {
          "phoneNumber": phoneNumber,
        },
      );
      logger.info("send-sms response: ${response.statusCode}");
      return;
    } on DioException catch (ex, st) {
      logger.error("Ошибка при отправке SMS", ex, st);
    }
  }

  @override
  Future<Response> loginVerification({
    required String phoneNumber,
    required String code,
  }) async {
    try {
      final response = await dio.post(
        "MobileUser/login",
        data: {
          "phoneNumber": phoneNumber,
          "code": code,
        },
      );
      logger.info("login response: ${response.statusCode}");
      return response;
    } on DioException catch (ex, st) {
      logger.error("Ошибка при логине (verification)", ex, st);
      rethrow;
    }
  }
}
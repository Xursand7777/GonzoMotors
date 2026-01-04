import '../../../../core/network/base_repository.dart';
import '../../../../core/network/models/api_response.dart';
import '../models/user_model.dart';

abstract class ProfileRepository extends BaseRepository {
  ProfileRepository(super.dio);
  Future<ApiResponse<UserModel?>> getUser();
  Future<ApiResponse> deleteAccount();
  Future<ApiResponse<UserModel>> updateUser(Map<String,dynamic> user);

}


class ProfileRepositoryImpl extends ProfileRepository {
  ProfileRepositoryImpl(super.dio);

  @override
  Future<ApiResponse<UserModel?>> getUser() async {

    return await get(
        'user/me',
        fromJson: (data) => UserModel.fromJson(data)
    );
  }

  @override
  Future<ApiResponse> deleteAccount() {
    return delete(
      'user',
    );
  }


  @override
  Future<ApiResponse<UserModel>> updateUser(Map<String, dynamic> user) async {
    return await put(
      'user/update',
      data:  user,
      fromJson: (data) => UserModel.fromJson(data),
    );
  }



}

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/services/token_service.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfilePageState> {
  final TokenService _tokenService;


  ProfileCubit(this._tokenService) : super(const ProfilePageState(),){
    loadAppVersion();
  }

  Future<void> loadProfile() async {
    final token = await _tokenService.getToken();
    emit(state.copyWith(accessToken: token));
  }

  void navigateTo(ProfileNavigation navigation) {
    emit(state.copyWith(navigation: navigation));
  }

  void loadAppVersion() async {
    final versions = await PackageInfo.fromPlatform();
    log('App Version: ${versions.version}');
    log('App build : ${versions.buildNumber}');


    emit(state.copyWith(appVersion: versions.version));
  }

}
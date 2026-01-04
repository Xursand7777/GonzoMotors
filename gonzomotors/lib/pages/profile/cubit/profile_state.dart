part of 'profile_cubit.dart';

class ProfilePageState {
  final String? accessToken;
  final ProfileNavigation? navigation;
  final String? appVersion;


  const ProfilePageState({this.accessToken, this.navigation, this.appVersion});

  ProfilePageState copyWith({
    String? accessToken,
    ProfileNavigation? navigation,
    String? appVersion,
  }) {
    return ProfilePageState(
      accessToken: accessToken ?? this.accessToken,
      navigation: navigation ,
      appVersion: appVersion ?? this.appVersion,
    );
  }


}

enum ProfileNavigation { register, login, none,promotion }
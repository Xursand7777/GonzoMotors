
part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final UserModel? user;
  final BaseStatus status;
  final PackageInfo? packageInfo;


  final bool isUpdateAvailable;
  final String? editName;
  final String? editSurname;

  const ProfileState({
    this.user,
    this.status = const BaseStatus(type: StatusType.initial),
    this.packageInfo,
    this.isUpdateAvailable = false,
    this.editName,
    this.editSurname,
  });

  ProfileState copyWith({
    UserModel? user,
    BaseStatus? status,
    PackageInfo? packageInfo,
    bool? isUpdateAvailable,
    String? editName,
    String? editSurname,
    bool clearEdit = false,
  }) {
    return ProfileState(
      user: user ?? this.user,
      status: status ?? this.status,
      packageInfo: packageInfo ?? this.packageInfo,
      isUpdateAvailable: isUpdateAvailable ?? this.isUpdateAvailable,
      editName: clearEdit ? null : (editName ?? this.editName),
      editSurname: clearEdit ? null : (editSurname ?? this.editSurname),
    );
  }

  ProfileState clearUser() {
    return ProfileState(
      user: null,
      status: status,
      packageInfo: packageInfo,
      isUpdateAvailable: isUpdateAvailable,
    );
  }

  @override
  List<Object?> get props => [
    user,
    status,
    packageInfo,
    isUpdateAvailable,
    editName,
    editSurname,
  ];
}

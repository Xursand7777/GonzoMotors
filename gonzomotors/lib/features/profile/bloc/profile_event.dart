
part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

// ==================== USER PROFILE EVENTS ====================

/// Foydalanuvchi profilini olish
class GetProfileEvent extends ProfileEvent {
  const GetProfileEvent();
}

/// Foydalanuvchi chiqib ketganida
class UserLoggedOutEvent extends ProfileEvent {
  const UserLoggedOutEvent();
}

/// Foydalanuvchi hisobini o'chirish
class DeleteAccountEvent extends ProfileEvent {
  const DeleteAccountEvent();
}




// ==================== APP VERSION EVENTS ====================

/// Yangi yangilanishlarni tekshirish
class CheckNewUpdatesEvent extends ProfileEvent {
  final String? buildNumber;

  const CheckNewUpdatesEvent(this.buildNumber);

  @override
  List<Object?> get props => [buildNumber];
}

/// Package info'ni yuklash
class LoadPackageInfoEvent extends ProfileEvent {
  const LoadPackageInfoEvent();
}

// ==================== ANALYTICS EVENTS ====================

/// Foydalanuvchi analytics'ni yangilash
class UpdateUserAnalyticsEvent extends ProfileEvent {
  final UserModel user;

  const UpdateUserAnalyticsEvent(this.user);

  @override
  List<Object?> get props => [user];
}

/// User ID ni analytics'ga o'rnatish
class SetAnalyticsUserIdEvent extends ProfileEvent {
  final String userId;

  const SetAnalyticsUserIdEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// User yosh'ni analytics'ga o'rnatish
class SetAnalyticsUserAgeEvent extends ProfileEvent {
  final String? birthDate;

  const SetAnalyticsUserAgeEvent(this.birthDate);

  @override
  List<Object?> get props => [birthDate];
}

/// Analytics'ni tozalash
class ClearAnalyticsEvent extends ProfileEvent {
  const ClearAnalyticsEvent();
}

// ==================== CACHE EVENTS ====================

/// Local user ma'lumotini olish
class GetCachedUserEvent extends ProfileEvent {
  const GetCachedUserEvent();
}

/// User ma'lumotini saqlash
class SaveUserToCacheEvent extends ProfileEvent {
  final UserModel user;

  const SaveUserToCacheEvent(this.user);

  @override
  List<Object?> get props => [user];
}

/// Cache'ni tozalash
class ClearCacheEvent extends ProfileEvent {
  const ClearCacheEvent();
}

class EditNameEvent extends ProfileEvent {
  final String name;
  const EditNameEvent(this.name);
  @override
  List<Object?> get props => [name];
}

class EditSurnameEvent extends ProfileEvent {
  final String surname;
  const EditSurnameEvent(this.surname);
  @override
  List<Object?> get props => [surname];
}

class EditSaveOrCancelEvent extends ProfileEvent {
  final bool isEdit;
  const EditSaveOrCancelEvent({this.isEdit = true});
  @override
  List<Object?> get props => [];
}

class GetPopUpEvent extends ProfileEvent {
  const GetPopUpEvent();
}
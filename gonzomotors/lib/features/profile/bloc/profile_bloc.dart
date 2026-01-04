import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/bloc/base_status.dart';
import '../../../core/di/app_injection.dart';
import '../../../core/services/device_info_service.dart';
import '../../../core/services/remote_service.dart';
import '../../../core/services/token_service.dart';
import '../../../core/services/user_service.dart';
import '../data/models/user_model.dart';
import '../data/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

   final ProfileRepository repo;
   final UserService _userService;
   final TokenService _tokenService;
   final DeviceInfoService _deviceInfoService;

  ProfileBloc(this.repo, this._userService, this._tokenService, this._deviceInfoService)
      : super(const ProfileState()) {
    // ==================== USER PROFILE HANDLERS ====================
    on<GetProfileEvent>(_onGetProfile);
    on<UserLoggedOutEvent>(_onUserLoggedOut);
    on<DeleteAccountEvent>(_onDeleteAccount);


    // ==================== APP VERSION HANDLERS ====================
    on<LoadPackageInfoEvent>(_onLoadPackageInfo);
    on<CheckNewUpdatesEvent>(_onCheckNewUpdates);



    // ==================== CACHE HANDLERS ====================
    on<GetCachedUserEvent>(_onGetCachedUser);
    on<SaveUserToCacheEvent>(_onSaveUserToCache);
    on<ClearCacheEvent>(_onClearCache);

    // ==================== EDIT USER PROFILE EVENTS ====================
    on<EditNameEvent>(_onEditName);
    on<EditSurnameEvent>(_onEditSurname);
    on<EditSaveOrCancelEvent>(_onEditSaveOrCancel);

    // Initial events
    add(const GetPopUpEvent());
    add(const LoadPackageInfoEvent());
    add(const GetProfileEvent());
  }

   // ==================== USER PROFILE METHODS ====================

   /// Foydalanuvchi profilini olish (API dan)
   Future<void> _onGetProfile(
       GetProfileEvent event,
       Emitter<ProfileState> emit,
       ) async {
     _log('🟢 GetProfile: Started');

     emit(state.copyWith(status: BaseStatus.loading()));

     try {
       // 1. Cache'dan olish
       add(const GetCachedUserEvent());

       // 2. API dan olish
       _log('🟢 GetProfile: Fetching from API...');
       final response = await repo.getUser();

       if (response.data == null) {
         throw Exception('User data is null');
       }

       final user = response.data!;
       _log('🟢 GetProfile: API response received - User ID: ${user.id}');

       // 3. Cache'ga saqlash
       add(SaveUserToCacheEvent(user));

       // 4. State'ni yangilash
       emit(state.copyWith(
         user: user,
         status: BaseStatus.success(),
       ));

       // 5. Analytics'ni yangilash
       add(UpdateUserAnalyticsEvent(user));

       // 6. Yangilanishni tekshirish
       final remoteBuildNumber = sl<RemoteService>().appBuildNumber;
       add(CheckNewUpdatesEvent(remoteBuildNumber));

       _log('🟢 GetProfile: Completed successfully');
     } catch (e, stackTrace) {
       _log('🔴 GetProfile Error: $e');
       _log('🔴 GetProfile StackTrace: $stackTrace');

       emit(state.copyWith(
         status: BaseStatus.errorWithMessage(message: e.toString()),
       ));
     } finally {
       emit(state.copyWith(status: BaseStatus.initial()));
     }
   }

   /// Foydalanuvchi chiqib ketishi
   Future<void> _onUserLoggedOut(
       UserLoggedOutEvent event,
       Emitter<ProfileState> emit,
       ) async {
     _log('🟠 UserLoggedOut: Started');

     try {
       // 1. Cache'ni tozalash
       add(const ClearCacheEvent());

       // 2. Analytics'ni tozalash
       add(const ClearAnalyticsEvent());

       // 3. State'ni tozalash
       emit(state.clearUser());

       _log('🟠 UserLoggedOut: Completed');
     } catch (e) {
       _log('🔴 UserLoggedOut Error: $e');
     }
   }

   /// Hisobni o'chirish
   Future<void> _onDeleteAccount(
       DeleteAccountEvent event,
       Emitter<ProfileState> emit,
       ) async {
     _log('🔴 DeleteAccount: Started');

     emit(state.copyWith(status: BaseStatus.loading()));

     try {
       // 1. API orqali o'chirish
       await repo.deleteAccount();
       _log('🔴 DeleteAccount: Account deleted from server');

       // 2. Cache'ni tozalash
       add(const ClearCacheEvent());

       // 3. Analytics'ni tozalash
       add(const ClearAnalyticsEvent());

       // 4. State'ni tozalash
       emit(state.clearUser());
       emit(state.copyWith(status: BaseStatus.success()));

       _log('🔴 DeleteAccount: Completed');
     } catch (e) {
       _log('🔴 DeleteAccount Error: $e');
       emit(state.copyWith(
         status: BaseStatus.errorWithMessage(
           message:
           'Hisobni o\'chirishda xatolik yuz berdi. Iltimos, qayta urinib ko\'ring.',
         ),
       ));
     }
   }

   // ==================== APP VERSION METHODS ====================

   /// Package info'ni yuklash
   Future<void> _onLoadPackageInfo(
       LoadPackageInfoEvent event,
       Emitter<ProfileState> emit,
       ) async {
     _log('📦 LoadPackageInfo: Started');

     try {
       final packageInfo = await PackageInfo.fromPlatform();
       final deviceInfoPlugin = DeviceInfoPlugin();
       final deviceInfo = await deviceInfoPlugin.deviceInfo;
       final uniqueDeviceId = await getUniqueDeviceId(deviceInfoPlugin);
       if (Platform.isAndroid) {
         final androidInfo = await deviceInfoPlugin.androidInfo;
         _log('Device ID: ${androidInfo.id}');
         _log('Manufacturer: ${androidInfo.manufacturer}');
         _log('Model: ${androidInfo.model}');
         _log('Android Version: ${androidInfo.version.release}');

         _deviceInfoService.saveDeviceInfo(
             deviceId: uniqueDeviceId,
             model: androidInfo.model,
             name: androidInfo.name);
       } else if (Platform.isIOS) {
         final iosInfo = await deviceInfoPlugin.iosInfo;

         _deviceInfoService.saveDeviceInfo(
             deviceId: uniqueDeviceId, model: iosInfo.model, name: iosInfo.name);

         _log('Device ID: ${iosInfo.identifierForVendor}');
         _log('Name: ${iosInfo.name}');
         _log('Model: ${iosInfo.model}');
         _log('iOS Version: ${iosInfo.systemVersion}');
       }
       _log('📦 LoadPackageInfo: Device Info fetched');

       emit(state.copyWith(packageInfo: packageInfo));

       _log(
           '📦 LoadPackageInfo: Version ${packageInfo.version}, Build ${packageInfo.buildNumber}');
     } catch (e) {
       _log('🔴 LoadPackageInfo Error: $e');
     }
   }

   /// Yangi yangilanishlarni tekshirish
   Future<void> _onCheckNewUpdates(
       CheckNewUpdatesEvent event,
       Emitter<ProfileState> emit,
       ) async {
     _log('🔄 CheckNewUpdates: Started');

     try {
       final currentBuildNumber =
           int.tryParse(state.packageInfo?.buildNumber ?? '0') ?? 0;
       final remoteBuildNumber = int.tryParse(event.buildNumber ?? '0') ?? 0;

       final isUpdateAvailable = remoteBuildNumber > currentBuildNumber;

       emit(state.copyWith(isUpdateAvailable: isUpdateAvailable));

       _log(
           '🔄 CheckNewUpdates: Current=$currentBuildNumber, Remote=$remoteBuildNumber');
       _log('🔄 CheckNewUpdates: Update available=$isUpdateAvailable');
     } catch (e) {
       _log('🔴 CheckNewUpdates Error: $e');
     }
   }

   // ==================== CACHE METHODS ====================

   /// Local user ma'lumotini olish
   Future<void> _onGetCachedUser(
       GetCachedUserEvent event,
       Emitter<ProfileState> emit,
       ) async {
     _log('💾 GetCachedUser: Started');

     try {
       final cachedUser = await _userService.getUser();

       if (cachedUser != null) {
         emit(state.copyWith(user: cachedUser));
         _log('💾 GetCachedUser: User found - ID: ${cachedUser.id}');
       } else {
         _log('💾 GetCachedUser: No cached user');
       }
     } catch (e) {
       _log('🔴 GetCachedUser Error: $e');
     }
   }

   /// User ma'lumotini saqlash
   Future<void> _onSaveUserToCache(
       SaveUserToCacheEvent event,
       Emitter<ProfileState> emit,
       ) async {
     _log('💾 SaveUserToCache: Started for user ${event.user.id}');

     try {
       await _userService.saveUser(event.user);
       _log('💾 SaveUserToCache: User saved successfully');
     } catch (e) {
       _log('🔴 SaveUserToCache Error: $e');
     }
   }

   /// Cache'ni tozalash
   Future<void> _onClearCache(
       ClearCacheEvent event,
       Emitter<ProfileState> emit,
       ) async {
     _log('💾 ClearCache: Started');

     try {
       await _tokenService.clearTokens();
       await _userService.clearUser();
       _log('💾 ClearCache: Completed');
     } catch (e) {
       _log('🔴 ClearCache Error: $e');
     }
   }

   // ==================== HELPER METHODS ====================

   void _log(String message) {
     //log(message);
   }

   void _onEditName(EditNameEvent event, Emitter<ProfileState> emit) async {
     emit(state.copyWith(
       editName: event.name,
     ));
   }

   void _onEditSurname(
       EditSurnameEvent event, Emitter<ProfileState> emit) async {
     emit(state.copyWith(
       editSurname: event.surname,
     ));
   }

   void _onEditSaveOrCancel(
       EditSaveOrCancelEvent event, Emitter<ProfileState> emit) async {
     if (event.isEdit) {
       final user = state.user;
       final Map<String, dynamic> userUpdated = {};
       if (state.editName != null) {
         userUpdated['first_name'] = state.editName!;
       }
       if (state.editSurname != null) {
         userUpdated['last_name'] = state.editSurname!;
       }

       try {
         emit(state.copyWith(
           status: BaseStatus.loading(),
           user: state.user?.copyWith(
               firstName: state.editName ?? state.user!.firstName,
               lastName: state.editSurname ?? state.user!.lastName),
         ));
         final response = await repo.updateUser(userUpdated);
         if (response.data != null) {
           emit(state.copyWith(
               user: response.data!,
               status: BaseStatus.success(),
               clearEdit: true));
         } else {
           emit(state.copyWith(
             user: user,
             status: BaseStatus.errorWithMessage(
                 message:
                 'Foydalanuvchi ma\'lumotlarini yangilashda xatolik yuz berdi.'),
           ));
         }
       } catch (e) {
         emit(state.copyWith(
           user: user,
           status: BaseStatus.errorWithMessage(
               message:
               'Foydalanuvchi ma\'lumotlarini yangilashda xatolik yuz berdi.'),
         ));
       } finally {
         emit(state.copyWith(status: BaseStatus.initial()));
       }
     }
   }

   Future<String> getUniqueDeviceId(DeviceInfoPlugin deviceInfo) async {
     String uniqueDeviceId = '';

     if (Platform.isIOS) {
       var iosDeviceInfo = await deviceInfo.iosInfo;
       uniqueDeviceId =
       '${iosDeviceInfo.name}:${iosDeviceInfo.identifierForVendor}'; //
       //unique ID on iOS
     } else if (Platform.isAndroid) {
       var androidDeviceInfo = await deviceInfo.androidInfo;
       uniqueDeviceId =
       '${androidDeviceInfo.name}:${androidDeviceInfo.id}'; // unique ID
       // on Android
     }
     return uniqueDeviceId;
   }
}
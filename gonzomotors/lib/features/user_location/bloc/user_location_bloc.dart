
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/bloc/base_status.dart';
import '../../../core/log/talker_logger.dart';
import '../data/repository/user_location_repository.dart';
part 'user_location_event.dart';
part 'user_location_state.dart';


class UserLocationBloc extends Bloc<UserLocationEvent, UserLocationState> {
  final UserLocationRepository repository;
  UserLocationBloc(this.repository) : super(const UserLocationState()) {
    on<UserLocationLoadEvent>(_loadUserLocation);
    on<UserLocationSecondEvent>(_userLocationSecond);
    on<UserLocationCancelEvent>(_cancelUserLocation);
  }
  bool isLocation = false;

  void _loadUserLocation(
      UserLocationLoadEvent event, Emitter<UserLocationState> emit) async {
    emit(state.copyWith(
      status: const BaseStatus(type: StatusType.loading),
    ));
    isLocation = true;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(state.copyWith(
        status: const BaseStatus(
          type: StatusType.error,
          message: 'Location service is disabled',
        ),
      ));
      return;
    }

    final permissionStatus = await Geolocator.checkPermission();

    logger.debug("location permission status => $permissionStatus");

    switch (permissionStatus) {
      case LocationPermission.whileInUse:
        await _getCurrentLocation(emit);
        break;

      case LocationPermission.denied:
        final savedDate = await repository.getUserPermissionDate();
        if (savedDate != null) {
          final daysPassed = DateTime.now().difference(savedDate).inDays;
          if (daysPassed < 7) {
            emit(state.copyWith(
              status: BaseStatus(
                type: StatusType.error,
                message:
                'Location permission was cancelled. Will ask again after ${7 - daysPassed} days.',
              ),
            ));
            return;
          }
        }
        emit(state.copyWith(
          showDialog: true,
          status: const BaseStatus(type: StatusType.initial),
        ));
        break;

      case LocationPermission.deniedForever:
        emit(state.copyWith(
          status: const BaseStatus(
            type: StatusType.error,
            message:
            'Location permission permanently denied. Please enable it in app settings.',
          ),
        ));
        break;

      case LocationPermission.unableToDetermine:
        emit(state.copyWith(
          status: const BaseStatus(
            type: StatusType.error,
            message: 'Location access is restricted by system.',
          ),
        ));
        break;

      default:
        emit(state.copyWith(
          showDialog: true,
          status: const BaseStatus(type: StatusType.initial),
        ));
    }
  }

  void _userLocationSecond(
      UserLocationSecondEvent event, Emitter<UserLocationState> emit) async {
    emit(state.copyWith(
      status: const BaseStatus(type: StatusType.loading),
      showDialog: false,
    ));

    final request = await Geolocator.requestPermission();

    logger.debug("location permission request => $request");

    switch (request) {
      case LocationPermission.whileInUse:
        await _getCurrentLocation(emit);
        break;

      case LocationPermission.denied:
        emit(state.copyWith(
          status: const BaseStatus(
            type: StatusType.error,
            message: 'Location permission denied',
          ),
        ));
        break;

      case LocationPermission.deniedForever:
        emit(state.copyWith(
          status: const BaseStatus(
            type: StatusType.error,
            message:
            'Location permission permanently denied. Please enable it in app settings.',
          ),
        ));
        break;

      default:
        emit(state.copyWith(
          status: const BaseStatus(
            type: StatusType.error,
            message: 'Location permission denied',
          ),
        ));
    }
  }

  void _cancelUserLocation(
      UserLocationCancelEvent event, Emitter<UserLocationState> emit) async {
    await repository.saveUserPermissionDate(DateTime.now());

    emit(state.copyWith(
      status: const BaseStatus(type: StatusType.initial),
      showDialog: false,
    ));
  }

  Future<void> _getCurrentLocation(Emitter<UserLocationState> emit) async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      emit(state.copyWith(
        userPosition: position,
        status: const BaseStatus(type: StatusType.success),
        showDialog: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BaseStatus(
          type: StatusType.error,
          message: 'Failed to get location: ${e.toString()}',
        ),
      ));
    }
  }
}

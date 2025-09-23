import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class SplashState extends Equatable {

  @override
  List<Object?> get props => [];

}

class SplashInitialState extends SplashState {
}

class SplashFinishedState extends SplashState {

  @override
  List<Object?> get props => [UniqueKey()];

}

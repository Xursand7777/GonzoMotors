import 'package:flutter_bloc/flutter_bloc.dart';


class MultiBlocObserver extends BlocObserver {
  MultiBlocObserver(this._observers);

  final List<BlocObserver> _observers;

  @override
  void onCreate(BlocBase bloc) {
    for (final o in _observers) {
      try {
        o.onCreate(bloc);
      } catch (_) {}
    }
    super.onCreate(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    for (final o in _observers) {
      try {
        o.onEvent(bloc, event);
      } catch (_) {}
    }
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    for (final o in _observers) {
      try {
        o.onChange(bloc, change);
      } catch (_) {}
    }
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    for (final o in _observers) {
      try {
        o.onTransition(bloc, transition);
      } catch (_) {}
    }
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    for (final o in _observers) {
      try {
        o.onError(bloc, error, stackTrace);
      } catch (_) {}
    }
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    for (final o in _observers) {
      try {
        o.onClose(bloc);
      } catch (_) {}
    }
    super.onClose(bloc);
  }
}
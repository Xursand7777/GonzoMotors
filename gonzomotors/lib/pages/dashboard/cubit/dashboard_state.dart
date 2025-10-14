part of 'dashboard_cubit.dart';

class DashboardState extends Equatable {
  final int currentIndex;

  const DashboardState({
    required this.currentIndex,
  });

  const DashboardState.initial() : currentIndex = 0;

  copyWith({
    int? currentIndex,
  }) {
    return DashboardState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object> get props => [ currentIndex];
}
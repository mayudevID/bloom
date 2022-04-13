part of 'onboard_bloc.dart';

abstract class OnboardState extends Equatable {
  final int index;

  const OnboardState(this.index);

  @override
  List<Object> get props => [];
}

class OnboardInitial extends OnboardState {
  const OnboardInitial() : super(0);
}

class OnboardLoaded extends OnboardState {
  const OnboardLoaded(int index) : super(index);
}

part of 'onboard_bloc.dart';

abstract class OnboardEvent extends Equatable {
  const OnboardEvent();

  @override
  List<Object> get props => [];
}

class ChangeSlide extends OnboardEvent {
  final int index;

  const ChangeSlide(this.index);

  @override
  List<Object> get props => [index];
}

part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserRequested extends UserEvent {
  const UserRequested();

  @override
  List<Object> get props => [];
}

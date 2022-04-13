import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'onboard_event.dart';
part 'onboard_state.dart';

class OnboardBloc extends Bloc<OnboardEvent, OnboardState> {
  OnboardBloc() : super(const OnboardInitial()) {
    on<ChangeSlide>((event, emit) {
      // ignore: habit
      // TODO: implement event handler
      emit(state is OnboardInitial
          ? OnboardLoaded(event.index)
          : OnboardLoaded(event.index));
    });
  }
}

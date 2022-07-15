import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardCubit extends Cubit<int> {
  OnboardCubit() : super(0);

  void setOnboard(event) => emit(event);
}

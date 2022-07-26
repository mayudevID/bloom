import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void setTab(HomeTab tab) {
    emit(HomeState(tab: tab, status: LoadStatus.done));
  }

  Future<void> getDataBackup(bool isGetData) async {
    if (isGetData == false) {
      emit(const HomeState(status: LoadStatus.finish));
      return;
    }
    emit(const HomeState(status: LoadStatus.load));
    await Future.delayed(const Duration(seconds: 3));
    emit(const HomeState(status: LoadStatus.finish));
  }

  void finishToDone() {
    emit(const HomeState(status: LoadStatus.done));
  }
}

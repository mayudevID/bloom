import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void setTab(HomeTab tab) => emit(HomeState(tab: tab));

  Future<void> getDataBackup(bool isGetData) async {
    if (isGetData == false) {
      return;
    }
    emit(const HomeState(status: LoadStatus.open));
    await Future.delayed(Duration(seconds: 3));
    emit(const HomeState(status: LoadStatus.close));
  }
}

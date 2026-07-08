import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_layout_state.dart';

class MainLayoutCubit extends Cubit<MainLayoutState> {
  MainLayoutCubit() : super(const MainLayoutState());

  void changeIndex(int index) {
    // إذا كانت القائمة الدائرية مفتوحة، نغلقها عند التنقل
    emit(state.copyWith(currentIndex: index, isMenuOpen: false));
  }

  void toggleMenu() {
    emit(state.copyWith(isMenuOpen: !state.isMenuOpen));
  }

  void closeMenu() {
    if (state.isMenuOpen) {
      emit(state.copyWith(isMenuOpen: false));
    }
  }
}

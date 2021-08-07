import 'package:bloc/bloc.dart';

part 'click_state.dart';

class ClickCubit extends Cubit<ClickAction> {
  ClickCubit() : super(ClickAction(categoryNameSelected: 'T-Shirts'));

  void categoryClickColor(String value){
  emit(ClickAction(categoryNameSelected: value));
  }

}

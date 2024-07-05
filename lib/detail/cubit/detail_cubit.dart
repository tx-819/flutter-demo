import 'package:bloc/bloc.dart';

class DetailCubit extends Cubit<int> {
  DetailCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

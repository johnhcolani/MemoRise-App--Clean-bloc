import 'package:bloc/bloc.dart';


part 'splash_event.dart';
part 'splash_state.dart';
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashCompleteEvent>((event, emit) {
      emit(SplashComplete());
    });
  }

  Future<void> startSplashAnimation() async {
    // Simulate some delay for animation
    await Future.delayed(const Duration(seconds: 3));
    add(SplashCompleteEvent());
  }
}
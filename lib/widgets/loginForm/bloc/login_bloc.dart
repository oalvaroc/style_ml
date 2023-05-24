import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:style_ml/models/user.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginInitial()) {
    on<LoginSubmitted>((event, emit) {
      emit(
        LoginSuccess(
          user: User(
            email: event.email,
            password: event.password,
          ),
        ),
      );
    });
    on<LoginRestored>((event, emit) {
      // same as above for now
      emit(
        LoginSuccess(
          user: User(
            email: event.email,
            password: event.password,
          ),
        ),
      );
    });
  }
}

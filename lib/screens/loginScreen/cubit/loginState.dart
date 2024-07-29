abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginProgressState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginExceptionState extends LoginState {
  final String errorMessage;

  LoginExceptionState({required this.errorMessage});
}

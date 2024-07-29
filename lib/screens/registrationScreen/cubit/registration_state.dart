abstract class RegistrationState {}

class RegistrationInitialState extends RegistrationState {}

class RegistrationProgressState extends RegistrationState {}

class RegistrationSuccessState extends RegistrationState {
  final String? emailMessage;
  RegistrationSuccessState({this.emailMessage});
}

class RegistrationExceptionState extends RegistrationState {
  final String errorMessage;
  RegistrationExceptionState({required this.errorMessage});
}

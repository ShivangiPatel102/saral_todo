import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:todo/screens/registrationScreen/cubit/registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(RegistrationInitialState());

  final String _strapiBaseUrl = 'http://192.168.1.4:1337';

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      emit(RegistrationProgressState());

      final response = await http.post(
        Uri.parse('$_strapiBaseUrl/api/auth/local/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': email,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        emit(RegistrationSuccessState(
          emailMessage: 'Registration successful!',
        ));
      } else {
        final responseBody = response.body;
        emit(RegistrationExceptionState(
          errorMessage: 'Registration failed: $responseBody',
        ));
      }
    } catch (e) {
      emit(RegistrationExceptionState(
        errorMessage: 'Registration failed. Please try again.',
      ));
    }
  }
}

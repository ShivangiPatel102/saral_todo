import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/screens/loginScreen/cubit/loginState.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  Future<void> login(String email, String password) async {
    emit(LoginProgressState());

    // Validate email and password
    if (email.trim().isEmpty) {
      emit(LoginExceptionState(errorMessage: 'Please enter your email!'));
      return;
    } else if (!isValidEmail(email.trim())) {
      emit(LoginExceptionState(errorMessage: 'Invalid Email Address!'));
      return;
    } else if (password.isEmpty) {
      emit(LoginExceptionState(errorMessage: 'Please enter your password!'));
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.4:1337/api/auth/local'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': email.trim(),
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        emit(LoginSuccessState());
      } else {
        final errorResponse = jsonDecode(response.body);
        final errorMessage = errorResponse['message'] ?? 'Login failed';
        emit(LoginExceptionState(errorMessage: errorMessage));
      }
    } catch (e) {
      emit(LoginExceptionState(errorMessage: 'An error occurred: $e'));
    }
  }

  // Email validation method
  bool isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[^@]+@[^@]+\.[^@]+$',
      caseSensitive: false,
      multiLine: false,
    );
    return emailRegExp.hasMatch(email);
  }
}

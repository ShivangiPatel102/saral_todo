import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/constants.dart';
import 'package:todo/screens/homeScreen.dart';
import 'package:todo/screens/loginScreen/cubit/loginCubit.dart';
import 'package:todo/screens/loginScreen/cubit/loginState.dart';
import 'package:todo/screens/registrationScreen/registrationScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static Widget create() {
    return BlocProvider<LoginCubit>(
      create: (_) => LoginCubit(),
      child: const LoginScreen(),
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginCubit>().login(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginProgressState) {
            showDialog(
              context: context,
              builder: (_) {
                return const Dialog(
                  shape: CircleBorder(),
                  backgroundColor: Colors.white,
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryAppColor,
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is LoginSuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          } else if (state is LoginExceptionState) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: kPrimaryAppColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                height: MediaQuery.of(context).size.height / 2,
                width: double.infinity,
                child: const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: kWhite,
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          cursorColor: kPrimaryAppColor,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: kPrimaryAppColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: kPrimaryAppColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: kPrimaryAppColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            if (val?.isEmpty ?? false) {
                              return 'Please enter an email address';
                            } else if (!RegExp(r'\S+@\S+\.\S+')
                                .hasMatch(val!)) {
                              return 'Invalid email address!';
                            }
                            return null;
                          },
                          onEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                        ),
                        const SizedBox(height: 15.0),

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          cursorColor: kPrimaryAppColor,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: kPrimaryAppColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: kPrimaryAppColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: kPrimaryAppColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          validator: (val) {
                            if (val?.isEmpty ?? false) {
                              return 'Please enter your password';
                            } else if (val!.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          onEditingComplete: () {
                            _submitForm(context);
                          },
                        ),
                        const SizedBox(height: 15.0),

                        ElevatedButton(
                          onPressed: () {
                            _submitForm(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: kPrimaryAppColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                          ),
                          child: state is LoginProgressState
                              ? const CircularProgressIndicator(
                                  color: kPrimaryAppColor,
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                        ),
                        const SizedBox(height: 20.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RegistrationScreen.create(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: kPrimaryAppColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

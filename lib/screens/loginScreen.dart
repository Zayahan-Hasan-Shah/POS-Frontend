import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_frontend/blocs/loginBloc/login_bloc.dart';
import 'package:pos_frontend/models/loginModel/loginEntity.dart';
import 'package:pos_frontend/screens/homeScreen.dart';
import 'package:pos_frontend/screens/signupScreen.dart';
import 'package:pos_frontend/widgets/customTextField.dart';

class LoginScreen extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (_) => LoginScreen());

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginLoading) {
              // Show loading indicator
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logging in...')),
              );
            } else if (state is LoginSuccess) {
              final apiService = context.read<LoginBloc>().apiService;

              // Clear any existing snackbars
              ScaffoldMessenger.of(context).clearSnackBars();
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Login successful!')),
              );

              // Remove the delay and navigate immediately
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => HomeScreen(
                    apiService: apiService,
                  ),
                ),
                (route) => false,
              );
            } else if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final loginData = LoginEntity(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                  context.read<LoginBloc>().add(LoginSubmitted(loginData));
                },
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, SignupScreen.route());
                },
                child: Text('Don\'t have an account? Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

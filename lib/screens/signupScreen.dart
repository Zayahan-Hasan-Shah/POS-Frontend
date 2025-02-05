import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_frontend/blocs/signupBloc/signup_bloc.dart';
import 'package:pos_frontend/models/signupModel/signupEntity.dart';
import 'package:pos_frontend/widgets/customTextField.dart';

class SignupScreen extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (_) => SignupScreen());

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state is SignupLoading) {
              // Show loading indicator
            } else if (state is SignupSuccess) {
              // Handle success (Navigate or show success message)
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup successful!')));
            } else if (state is SignupError) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          child: Column(
            children: [
              CustomTextField(controller: _nameController, label: 'Name'),
              CustomTextField(controller: _userNameController, label: 'Username'),
              CustomTextField(controller: _emailController, label: 'Email', keyboardType: TextInputType.emailAddress),
              CustomTextField(controller: _phoneNumberController, label: 'Phone Number'),
              CustomTextField(controller: _passwordController, label: 'Password', obscureText: true),
              CustomTextField(controller: _shopNameController, label: 'Shop Name'),
              CustomTextField(controller: _shopAddressController, label: 'Shop Address'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final signupData = SignupEntity(
                    name: _nameController.text,
                    userName: _userNameController.text,
                    email: _emailController.text,
                    phoneNumber: _phoneNumberController.text,
                    password: _passwordController.text,
                    shopName: _shopNameController.text,
                    shopAddress: _shopAddressController.text,
                  );
                  BlocProvider.of<SignupBloc>(context).add(SignupSubmitted(signupData));
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

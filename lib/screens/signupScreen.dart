// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pos_frontend/blocs/signupBloc/signup_bloc.dart';
// import 'package:pos_frontend/models/signupModel/signupEntity.dart';
// import 'package:pos_frontend/screens/loginScreen.dart';
// import 'package:pos_frontend/widgets/customTextField.dart';

// class SignupScreen extends StatelessWidget {
//   static Route route() => MaterialPageRoute(builder: (_) => SignupScreen());

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _userNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneNumberController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   // final TextEditingController _confirmPasswordController = TextEditingController();
//   final TextEditingController _shopNameController = TextEditingController();
//   final TextEditingController _shopAddressController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Sign Up')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: BlocListener<SignupBloc, SignupState>(
//           listener: (context, state) {
//             if (state is SignupLoading) {
//               // Show loading indicator
//             } else if (state is SignupSuccess) {
//               // Handle success (Navigate or show success message)
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup successful!')));
//             } else if (state is SignupError) {
//               // Show error message
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
//             }
//           },
//           child: Column(
//             children: [
//               CustomTextField(controller: _nameController, label: 'Name'),
//               CustomTextField(controller: _userNameController, label: 'Username'),
//               CustomTextField(controller: _emailController, label: 'Email', keyboardType: TextInputType.emailAddress),
//               CustomTextField(controller: _phoneNumberController, label: 'Phone Number'),
//               CustomTextField(controller: _passwordController, label: 'Password', obscureText: true),
//               CustomTextField(controller: _shopNameController, label: 'Shop Name'),
//               CustomTextField(controller: _shopAddressController, label: 'Shop Address'),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   final signupData = SignupEntity(
//                     name: _nameController.text,
//                     userName: _userNameController.text,
//                     email: _emailController.text,
//                     phoneNumber: _phoneNumberController.text,
//                     password: _passwordController.text,
//                     shopName: _shopNameController.text,
//                     shopAddress: _shopAddressController.text,
//                   );
//                   BlocProvider.of<SignupBloc>(context).add(SignupSubmitted(signupData));
//                 },
//                 child: Text('Sign Up'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(context, LoginScreen.route());
//                 },
//                 child: Text('Already have an account? Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_frontend/blocs/signupBloc/signup_bloc.dart';
import 'package:pos_frontend/models/signupModel/signupEntity.dart';
import 'package:pos_frontend/screens/loginScreen.dart';
import 'package:pos_frontend/widgets/customTextField.dart';

class SignupScreen extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (_) => SignupScreen());

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage(
                //       'assets/background.jpg'), // Add your background image here
                //   fit: BoxFit.cover,
                // ),
                ),
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.white.withOpacity(0.5),
          ),
          // Signup form
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: BlocListener<SignupBloc, SignupState>(
                listener: (context, state) {
                  if (state is SignupLoading) {
                    // Show loading indicator
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Signing up...')),
                    );
                  } else if (state is SignupSuccess) {
                    // Handle success (Navigate or show success message)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Signup successful!')),
                    );
                    Navigator.pushReplacement(context, LoginScreen.route());
                  } else if (state is SignupError) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 32),
                    CustomTextField(
                      controller: _nameController,
                      label: 'Name',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                      borderColor: Theme.of(context).primaryColor,
                      focusedBorderColor:
                          Theme.of(context).primaryColor.withOpacity(0.4),
                      errorBorderColor: Colors.redAccent,
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: _userNameController,
                      label: 'Username',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                      borderColor: Theme.of(context).primaryColor,
                      focusedBorderColor:
                          Theme.of(context).primaryColor.withOpacity(0.4),
                      errorBorderColor: Colors.redAccent,
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                      borderColor: Theme.of(context).primaryColor,
                      focusedBorderColor:
                          Theme.of(context).primaryColor.withOpacity(0.4),
                      errorBorderColor: Colors.redAccent,
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: _phoneNumberController,
                      label: 'Phone Number',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                      borderColor: Theme.of(context).primaryColor,
                      focusedBorderColor:
                          Theme.of(context).primaryColor.withOpacity(0.4),
                      errorBorderColor: Colors.redAccent,
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: true,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                      borderColor: Theme.of(context).primaryColor,
                      focusedBorderColor:
                          Theme.of(context).primaryColor.withOpacity(0.4),
                      errorBorderColor: Colors.redAccent,
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: _shopNameController,
                      label: 'Shop Name',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                      borderColor: Theme.of(context).primaryColor,
                      focusedBorderColor:
                          Theme.of(context).primaryColor.withOpacity(0.4),
                      errorBorderColor: Colors.redAccent,
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: _shopAddressController,
                      label: 'Shop Address',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      labelStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                      borderColor: Theme.of(context).primaryColor,
                      focusedBorderColor:
                          Theme.of(context).primaryColor.withOpacity(0.4),
                      errorBorderColor: Colors.redAccent,
                    ),
                    SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
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
                          BlocProvider.of<SignupBloc>(context)
                              .add(SignupSubmitted(signupData));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                        child: Text('Sign Up'),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, LoginScreen.route());
                      },
                      child: Text(
                        'Already have an account? Login',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

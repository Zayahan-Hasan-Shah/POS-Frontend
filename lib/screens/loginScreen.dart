// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pos_frontend/blocs/loginBloc/login_bloc.dart';
// import 'package:pos_frontend/models/loginModel/loginEntity.dart';
// import 'package:pos_frontend/screens/homeScreen.dart';
// import 'package:pos_frontend/screens/signupScreen.dart';
// import 'package:pos_frontend/widgets/customTextField.dart';

// class LoginScreen extends StatelessWidget {
//   static Route route() => MaterialPageRoute(builder: (_) => LoginScreen());

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: BlocListener<LoginBloc, LoginState>(
//           listener: (context, state) {
//             if (state is LoginLoading) {
//               // Show loading indicator
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Logging in...')),
//               );
//             } else if (state is LoginSuccess) {
//               final apiService = context.read<LoginBloc>().apiService;

//               // Clear any existing snackbars
//               ScaffoldMessenger.of(context).clearSnackBars();
//               // Show success message
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Login successful!')),
//               );

//               // Remove the delay and navigate immediately
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(
//                   builder: (_) => HomeScreen(
//                     apiService: apiService,
//                   ),
//                 ),
//                 (route) => false,
//               );
//             } else if (state is LoginError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.errorMessage),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CustomTextField(
//                 controller: _emailController,
//                 label: 'Email',
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               SizedBox(height: 16),
//               CustomTextField(
//                 controller: _passwordController,
//                 label: 'Password',
//                 obscureText: true,
//               ),
//               SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () {
//                   final loginData = LoginEntity(
//                     email: _emailController.text,
//                     password: _passwordController.text,
//                   );
//                   context.read<LoginBloc>().add(LoginSubmitted(loginData));
//                 },
//                 child: Text('Login'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(context, SignupScreen.route());
//                 },
//                 child: Text('Don\'t have an account? Sign Up'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pos_frontend/blocs/loginBloc/login_bloc.dart';
// import 'package:pos_frontend/models/loginModel/loginEntity.dart';
// import 'package:pos_frontend/screens/homeScreen.dart';
// import 'package:pos_frontend/screens/signupScreen.dart';
// import 'package:pos_frontend/screens/welcomeScreen.dart';
// import 'package:pos_frontend/widgets/customTextField.dart';

// class LoginScreen extends StatelessWidget {
//   static Route route() => MaterialPageRoute(builder: (_) => LoginScreen());

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: BlocListener<LoginBloc, LoginState>(
//           listener: (context, state) {
//             if (state is LoginLoading) {
//               // Show loading indicator
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Logging in...')),
//               );
//             } else if (state is LoginSuccess) {
//               final apiService = context.read<LoginBloc>().apiService;

//               // Clear any existing snackbars
//               ScaffoldMessenger.of(context).clearSnackBars();
//               // Show success message
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Login successful!')),
//               );

//               // Navigate to WelcomeScreen
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(
//                   builder: (_) => WelcomeScreen(apiService: apiService),
//                 ),
//               );
//             } else if (state is LoginError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.errorMessage),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CustomTextField(
//                 controller: _emailController,
//                 label: 'Email',
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               SizedBox(height: 16),
//               CustomTextField(
//                 controller: _passwordController,
//                 label: 'Password',
//                 obscureText: true,
//               ),
//               SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () {
//                   final loginData = LoginEntity(
//                     email: _emailController.text,
//                     password: _passwordController.text,
//                   );
//                   context.read<LoginBloc>().add(LoginSubmitted(loginData));
//                 },
//                 child: Text('Login'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(context, SignupScreen.route());
//                 },
//                 child: Text('Don\'t have an account? Sign Up'),
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
import 'package:pos_frontend/blocs/loginBloc/login_bloc.dart';
import 'package:pos_frontend/models/loginModel/loginEntity.dart';
import 'package:pos_frontend/screens/signupScreen.dart';
import 'package:pos_frontend/screens/welcomeScreen.dart';
import 'package:pos_frontend/widgets/customTextField.dart';

class LoginScreen extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (_) => LoginScreen());

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
          // Login form
          Center(
            child: Padding(
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

                    // Navigate to WelcomeScreen
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => WelcomeScreen(apiService: apiService),
                      ),
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
                    Text(
                      'Login',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 32),
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
                    SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final loginData = LoginEntity(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          context
                              .read<LoginBloc>()
                              .add(LoginSubmitted(loginData));
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                        child: Text('Login'),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, SignupScreen.route());
                      },
                      child: Text(
                        'Don\'t have an account? Sign Up',
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




// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pos_frontend/blocs/loginBloc/login_bloc.dart';
// import 'package:pos_frontend/models/loginModel/loginEntity.dart';
// import 'package:pos_frontend/screens/homeScreen.dart';
// import 'package:pos_frontend/screens/signupScreen.dart';
// import 'package:pos_frontend/screens/welcomeScreen.dart'; // Import WelcomeScreen
// import 'package:pos_frontend/widgets/customTextField.dart';

// class LoginScreen extends StatelessWidget {
//   static Route route() => MaterialPageRoute(builder: (_) => LoginScreen());

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: BlocListener<LoginBloc, LoginState>(
//           listener: (context, state) {
//             if (state is LoginLoading) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Logging in...')),
//               );
//             } else if (state is LoginSuccess) {
//               final apiService = context.read<LoginBloc>().apiService;

//               // Show Welcome Screen for 2 seconds, then navigate to HomeScreen
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => WelcomeScreen()),
//               );

//               Future.delayed(const Duration(seconds: 2), () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => HomeScreen(apiService: apiService),
//                   ),
//                 );
//               });
//             } else if (state is LoginError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.errorMessage),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CustomTextField(
//                 controller: _emailController,
//                 label: 'Email',
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               SizedBox(height: 16),
//               CustomTextField(
//                 controller: _passwordController,
//                 label: 'Password',
//                 obscureText: true,
//               ),
//               SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () {
//                   final loginData = LoginEntity(
//                     email: _emailController.text,
//                     password: _passwordController.text,
//                   );
//                   context.read<LoginBloc>().add(LoginSubmitted(loginData));
//                 },
//                 child: Text('Login'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(context, SignupScreen.route());
//                 },
//                 child: Text('Don\'t have an account? Sign Up'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pos_frontend/blocs/loginBloc/login_bloc.dart';
// import 'package:pos_frontend/models/loginModel/loginEntity.dart';
// import 'package:pos_frontend/screens/homeScreen.dart';
// import 'package:pos_frontend/screens/signupScreen.dart';
// import 'package:pos_frontend/screens/welcomeScreen.dart';
// import 'package:pos_frontend/widgets/customTextField.dart';

// class LoginScreen extends StatelessWidget {
//   static Route route() => MaterialPageRoute(builder: (_) => LoginScreen());

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: BlocListener<LoginBloc, LoginState>(
//           listener: (context, state) {
//             // if (state is LoginLoading) {
//             //   ScaffoldMessenger.of(context).showSnackBar(
//             //     SnackBar(content: Text('Logging in...')),
//             //   );
//             // } else if (state is LoginSuccess) {
//             //   final apiService = context.read<LoginBloc>().apiService;

//             //   // Navigate to Welcome Screen first
//             //   Navigator.pushReplacement(
//             //     context,
//             //     MaterialPageRoute(builder: (_) => WelcomeScreen()),
//             //   );

//             //   // Ensure navigation happens after the frame is built
//             //   WidgetsBinding.instance.addPostFrameCallback((_) {
//             //     Future.delayed(const Duration(seconds: 2), () {
//             //       Navigator.pushReplacement(
//             //         context,
//             //         MaterialPageRoute(
//             //           builder: (_) => HomeScreen(apiService: apiService),
//             //         ),
//             //       );
//             //     });
//             //   });
//             // } else if (state is LoginError) {
//             //   ScaffoldMessenger.of(context).showSnackBar(
//             //     SnackBar(
//             //       content: Text(state.errorMessage),
//             //       backgroundColor: Colors.red,
//             //     ),
//             //   );
//             // }

//             // if (state is LoginLoading) {
//             //   // Show loading indicator
//             //   ScaffoldMessenger.of(context).showSnackBar(
//             //     SnackBar(content: Text('Logging in...')),
//             //   );
//             // } else if (state is LoginSuccess) {
//             //   final apiService = context.read<LoginBloc>().apiService;

//             //   // Clear any existing snackbars
//             //   ScaffoldMessenger.of(context).clearSnackBars();
//             //   // Show success message
//             //   ScaffoldMessenger.of(context).showSnackBar(
//             //     SnackBar(content: Text('Login successful!')),
//             //   );

//             //   // Show the Welcome Screen for 2-3 seconds before moving to HomeScreen
//             //   Navigator.pushReplacement(
//             //     context,
//             //     MaterialPageRoute(builder: (context) => const WelcomeScreen()),
//             //   );

//             //   Future.delayed(const Duration(seconds: 2), () {
//             //     Navigator.pushReplacement(
//             //       context,
//             //       MaterialPageRoute(
//             //           builder: (_) => HomeScreen(apiService: apiService)),
//             //     );
//             //   });
//             // } else if (state is LoginError) {
//             //   ScaffoldMessenger.of(context).showSnackBar(
//             //     SnackBar(
//             //       content: Text(state.errorMessage),
//             //       backgroundColor: Colors.red,
//             //     ),
//             //   );
//             // }

//             if (state is LoginLoading) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Logging in...')),
//               );
//             } else if (state is LoginSuccess) {
//               final apiService = context.read<LoginBloc>().apiService;

//               // Clear existing snackbars
//               ScaffoldMessenger.of(context).clearSnackBars();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Login successful!')),
//               );

//               // Show Welcome Screen and then navigate to HomeScreen
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => WelcomeScreen()),
//               );

//               Future.delayed(const Duration(seconds: 2), () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                       builder: (_) => HomeScreen(apiService: apiService)),
//                 );
//               });
//             } else if (state is LoginError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.errorMessage),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CustomTextField(
//                 controller: _emailController,
//                 label: 'Email',
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               SizedBox(height: 16),
//               CustomTextField(
//                 controller: _passwordController,
//                 label: 'Password',
//                 obscureText: true,
//               ),
//               SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () {
//                   final loginData = LoginEntity(
//                     email: _emailController.text,
//                     password: _passwordController.text,
//                   );
//                   context.read<LoginBloc>().add(LoginSubmitted(loginData));
//                 },
//                 child: Text('Login'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(context, SignupScreen.route());
//                 },
//                 child: Text('Don\'t have an account? Sign Up'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class LoginScreen extends StatefulWidget {
//   static Route route() => MaterialPageRoute(builder: (_) => LoginScreen());

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: BlocListener<LoginBloc, LoginState>(
//           listener: (context, state) {
//             if (state is LoginLoading) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Logging in...')),
//               );
//             } else if (state is LoginSuccess) {
//               final apiService = context.read<LoginBloc>().apiService;

//               // Show Welcome Screen and then navigate to HomeScreen
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => WelcomeScreen()),
//               );

//               Future.delayed(const Duration(seconds: 2), () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => HomeScreen(apiService: apiService),
//                   ),
//                 );
//               });
//             } else if (state is LoginError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.errorMessage),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CustomTextField(
//                 controller: _emailController,
//                 label: 'Email',
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               SizedBox(height: 16),
//               CustomTextField(
//                 controller: _passwordController,
//                 label: 'Password',
//                 obscureText: true,
//               ),
//               SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () {
//                   final loginData = LoginEntity(
//                     email: _emailController.text,
//                     password: _passwordController.text,
//                   );
//                   context.read<LoginBloc>().add(LoginSubmitted(loginData));
//                 },
//                 child: Text('Login'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(context, SignupScreen.route());
//                 },
//                 child: Text('Don\'t have an account? Sign Up'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',

//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_frontend/blocs/customerBloc/customer_bloc.dart';
import 'package:pos_frontend/blocs/signupBloc/signup_bloc.dart';
import 'package:pos_frontend/blocs/supplierBloc/supplier_bloc.dart';
import 'package:pos_frontend/screens/alertScreen.dart';
import 'package:pos_frontend/screens/cartScreen.dart';
import 'package:pos_frontend/screens/customerScreen.dart';
import 'package:pos_frontend/screens/homeScreen.dart';
import 'package:pos_frontend/screens/inventoryScreen.dart';
import 'package:pos_frontend/screens/loginScreen.dart';
import 'package:pos_frontend/screens/signupScreen.dart';
import 'package:pos_frontend/screens/splashScreen.dart';
import 'package:pos_frontend/screens/supplierScreen.dart';
import 'package:pos_frontend/screens/trackSales.dart';
import 'package:pos_frontend/services/apiService.dart';
import 'package:pos_frontend/blocs/loginBloc/login_bloc.dart';
import 'package:pos_frontend/screens/categoryScreen.dart';

void main() {
  final apiService = ApiService(); // Create single instance
  runApp(MyApp(apiService: apiService));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;

  const MyApp({required this.apiService});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignupBloc>(
          create: (context) => SignupBloc(apiService: apiService),
        ),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(apiService: apiService),
        ),
        BlocProvider<CustomerBloc>(
          create: (context) => CustomerBloc(
            apiService: apiService,
          ),
        ),
        BlocProvider(
          create: (context) => SupplierBloc(
            apiService: ApiService(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/dashboard': (context) => HomeScreen(apiService: apiService),
          '/categories': (context) => CategoryScreen(apiService: apiService),
          '/inventory': (context) => InventoryScreen(apiService: apiService),
          '/tracksales' : (context) => TrackSalesScreen(apiService: apiService,),
          '/addproductstocart': (context) => CartScreen(apiService: apiService),
          '/customers': (context) => CustomerScreen(apiService: apiService),
          '/suppliers': (context) => SupplierScreen(apiService: apiService),
          '/settings': (context) => HomeScreen(apiService: apiService),
        },
      ),
    );
  }
}


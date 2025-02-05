part of 'signup_bloc.dart';

abstract class SignupEvent {}

class SignupSubmitted extends SignupEvent {
  final SignupEntity signupData;

  SignupSubmitted(this.signupData);
}

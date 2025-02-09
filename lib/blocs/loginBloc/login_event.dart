
part of 'login_bloc.dart';



abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final LoginEntity loginData;

  LoginSubmitted(this.loginData);
}

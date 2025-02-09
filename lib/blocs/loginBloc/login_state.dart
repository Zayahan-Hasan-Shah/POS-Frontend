part of 'login_bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}


class LoginSuccess extends LoginState {
  final String token; // Assuming your API returns a token
  LoginSuccess(this.token);
}

class LoginError extends LoginState {
  final String errorMessage;
  LoginError(this.errorMessage);
}

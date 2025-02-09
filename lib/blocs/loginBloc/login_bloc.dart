import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_frontend/models/loginModel/loginEntity.dart';
import 'package:pos_frontend/services/apiService.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiService apiService;

  LoginBloc({required this.apiService}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final response = await apiService.login(event.loginData);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['access_token'];
        await Future.delayed(Duration(milliseconds: 50));
        emit(LoginSuccess(token));
      } else {
        final error = json.decode(response.body);
        emit(LoginError(error['detail'] ?? 'Login failed'));
      }
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}

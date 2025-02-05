import 'package:bloc/bloc.dart';
import 'package:pos_frontend/models/signupModel/signupEntity.dart';
import 'package:pos_frontend/services/apiService.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final ApiService apiService;

  SignupBloc({required this.apiService}) : super(SignupInitial()) {
    on<SignupSubmitted>((event, emit) async {
      print("SignupSubmitted event triggered"); // Debugging print statement
      emit(SignupLoading());

      try {
        final response = await apiService.signup(event.signupData);
        print("Response: ${response.body}"); // Debugging print statement

        if (response.statusCode == 200) {
          emit(SignupSuccess());
        } else {
          emit(SignupError('Signup failed: ${response.body}'));
        }
      } catch (e) {
        print("Error: $e"); // Debugging print statement
        emit(SignupError('An error occurred: $e'));
      }
    });
  }
}

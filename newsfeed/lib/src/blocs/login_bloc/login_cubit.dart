import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:news/src/models/forms/email.dart';
import 'package:news/src/models/forms/password.dart';
import 'package:news/src/resources/user_repository.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    ));
  }

  Future<void> logInWithCredentials() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      bool isVerified = await _authenticationRepository.isEmailVerified();
      emit(state.copyWith(
          status: FormzStatus.submissionSuccess, emailVerified: isVerified));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      await _authenticationRepository.logInWithGoogle();
      emit(state.copyWith(
          status: FormzStatus.submissionSuccess, emailVerified: true));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.pure));
    }
  }
}

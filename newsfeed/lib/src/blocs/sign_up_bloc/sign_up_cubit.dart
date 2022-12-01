import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:news/src/models/forms/date_of_birth.dart';
import 'package:news/src/models/forms/email.dart';
import 'package:news/src/models/forms/first_name.dart';
import 'package:news/src/models/forms/last_name.dart';
import 'package:news/src/models/forms/password.dart';
import 'package:news/src/resources/user_repository.dart';
part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticationRepository) : super(const SignUpState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([
        email,
        state.password,
        state.firstName,
        state.lastName,
        state.dateOfBirth,
      ]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([
        state.email,
        password,
        state.firstName,
        state.lastName,
        state.dateOfBirth,
      ]),
    ));
  }

  void firstNameChanged(String value) {
    final firstName = FirstName.dirty(value);
    emit(state.copyWith(
      firstName: firstName,
      status: Formz.validate([
        state.email,
        state.password,
        firstName,
        state.lastName,
        state.dateOfBirth,
      ]),
    ));
  }

  void lastNameChanged(String value) {
    final lastName = LastName.dirty(value);
    emit(state.copyWith(
      lastName: lastName,
      status: Formz.validate([
        state.email,
        state.password,
        state.firstName,
        lastName,
        state.dateOfBirth,
      ]),
    ));
  }

  void dateOfBirthChanged(String value) {
    final dateOfBirth = DateOfBirth.dirty(value);
    emit(state.copyWith(
      dateOfBirth: dateOfBirth,
      status: Formz.validate([
        state.email,
        state.password,
        state.firstName,
        state.lastName,
        dateOfBirth,
      ]),
    ));
  }

  Future<void> signUpFormSubmitted(String gender) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.signUp(
        email: state.email.value,
        password: state.password.value,
        firstName: state.firstName.value,
        lastName: state.lastName.value,
        dateOfBirth: state.dateOfBirth.value,
        gender: gender,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> sendVerificationEmail() async {
    _authenticationRepository.sendVerificationEmail();
  }
}

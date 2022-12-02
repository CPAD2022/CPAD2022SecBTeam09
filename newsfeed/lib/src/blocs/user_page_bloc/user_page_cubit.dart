import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:news/src/models/forms/date_of_birth.dart';
import 'package:news/src/models/forms/first_name.dart';
import 'package:news/src/models/forms/last_name.dart';
import 'package:news/src/models/user/user.dart';
import 'package:news/src/resources/user_repository.dart';
part 'user_page_state.dart';

class UserPageCubit extends Cubit<UserPageState> {
  UserPageCubit(this._authenticationRepository) : super(const UserPageState());

  final AuthenticationRepository _authenticationRepository;

  void firstNameChanged(String value) {
    final firstName = FirstName.dirty(value);
    emit(state.copyWith(
      firstName: firstName,
      status: Formz.validate([
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
        state.firstName,
        state.lastName,
        dateOfBirth,
      ]),
    ));
  }

  Future<void> updateUser(String email, String gender, String imagePath) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      _authenticationRepository.updateUser(
        firstName: state.firstName.value,
        lastName: state.lastName.value,
        dateOfBirth: state.dateOfBirth.value,
        email: email,
        gender: gender,
        imagePath: imagePath,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void setInitialValues(AppUser user) {
    final firstName = FirstName.dirty(user.firstName);
    final lastName = LastName.dirty(user.lastName);
    final dateOfBirth = DateOfBirth.dirty(user.dateOfBirth);

    emit(state.copyWith(
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      status: Formz.validate([
        firstName,
        lastName,
        dateOfBirth,
      ]),
    ));
  }
}

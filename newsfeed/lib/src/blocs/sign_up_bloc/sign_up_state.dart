part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.firstName = const FirstName.pure(),
    this.lastName = const LastName.pure(),
    this.dateOfBirth = const DateOfBirth.pure(),
    this.status = FormzStatus.pure,
  });

  final Email email;
  final Password password;
  final FirstName firstName;
  final LastName lastName;
  final DateOfBirth dateOfBirth;
  final FormzStatus status;

  @override
  List<Object> get props =>
      [email, password, firstName, lastName, dateOfBirth, status];

  SignUpState copyWith({
    Email email,
    Password password,
    FirstName firstName,
    LastName lastName,
    DateOfBirth dateOfBirth,
    FormzStatus status,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      status: status ?? this.status,
    );
  }
}

part of 'user_page_cubit.dart';

class UserPageState extends Equatable {
  const UserPageState({
    this.firstName = const FirstName.pure(),
    this.lastName = const LastName.pure(),
    this.dateOfBirth = const DateOfBirth.pure(),
    this.status = FormzStatus.pure,
  });

  final FirstName firstName;
  final LastName lastName;
  final DateOfBirth dateOfBirth;
  final FormzStatus status;

  @override
  List<Object> get props => [firstName, lastName, dateOfBirth, status];

  UserPageState copyWith({
    FirstName firstName,
    LastName lastName,
    DateOfBirth dateOfBirth,
    FormzStatus status,
  }) {
    return UserPageState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      status: status ?? this.status,
    );
  }
}

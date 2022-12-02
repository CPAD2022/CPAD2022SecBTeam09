part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.emailVerified = false,
  });

  final Email email;
  final Password password;
  final FormzStatus status;
  final bool emailVerified;

  @override
  List<Object> get props => [email, password, status, emailVerified];

  LoginState copyWith({
    Email email,
    Password password,
    FormzStatus status,
    bool emailVerified,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }
}

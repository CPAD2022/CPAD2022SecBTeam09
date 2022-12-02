import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/src/blocs/reset_password_bloc/reset_password_cubit.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/extensions/Color.dart';
import 'package:news/src/resources/user_repository.dart';
import 'package:news/src/ui/reset-password/reset_password_form.dart';

class ResetPasswordPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ResetPasswordPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) =>
              ResetPasswordCubit(context.read<AuthenticationRepository>()),
          child: ResetPasswordForm(),
        ),
      ),
    );
  }
}

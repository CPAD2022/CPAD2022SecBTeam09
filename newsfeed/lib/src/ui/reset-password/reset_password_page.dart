import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsfeed/src/blocs/reset_password_bloc/reset_password_cubit.dart';
import 'package:newsfeed/src/constants/ColorConstants.dart';
import 'package:newsfeed/src/extensions/Color.dart';
import 'package:newsfeed/src/resources/user_repository.dart';
import 'package:newsfeed/src/ui/reset-password/reset_password_form.dart';

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

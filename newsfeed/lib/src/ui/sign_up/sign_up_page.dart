import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsfeed/src/blocs/sign_up_bloc/sign_up_cubit.dart';
import 'package:newsfeed/src/constants/ColorConstants.dart';
import 'package:newsfeed/src/extensions/Color.dart';
import 'package:newsfeed/src/resources/user_repository.dart';
import 'package:newsfeed/src/ui/sign_up/sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider<SignUpCubit>(
          create: (_) => SignUpCubit(context.read<AuthenticationRepository>()),
          child: SignUpForm(),
        ),
      ),
    );
  }
}

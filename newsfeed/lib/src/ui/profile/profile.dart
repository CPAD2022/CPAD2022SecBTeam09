import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsfeed/src/blocs/user_page_bloc/user_page_cubit.dart';
import 'package:newsfeed/src/resources/user_repository.dart';
import 'package:newsfeed/src/ui/profile/user_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserPageCubit>(
      create: (_) => UserPageCubit(context.read<AuthenticationRepository>()),
      child: UserPage(),
    );
  }
}

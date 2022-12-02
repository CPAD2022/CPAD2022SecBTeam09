import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:news/src/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:news/src/blocs/reset_password_bloc/reset_password_cubit.dart';
import 'package:news/src/blocs/reset_password_bloc/reset_password_state.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/extensions/Color.dart';
import 'package:news/src/ui/login/login_page.dart';
import 'package:news/src/utils/app_localizations.dart';
import 'package:provider/provider.dart';
import '../dialogs/message_dialog.dart';

class ResetPasswordForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure &&
            Provider.of<ConnectivityStatus>(context, listen: false) ==
                ConnectivityStatus.Offline) {
          MessageDialog.showMessageDialog(
            context: context,
            title: AppLocalizations.of(context).translate('no_connection'),
            body: AppLocalizations.of(context).translate('no_internet'),
          );
        } else if (state.status.isSubmissionFailure) {
          MessageDialog.showMessageDialog(
            context: context,
            title: AppLocalizations.of(context).translate('invalid_email'),
            body: AppLocalizations.of(context).translate('invalid_email_body'),
          );
        } else if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pushReplacement(LoginPage.route());
          MessageDialog.showMessageDialog(
            context: context,
            title:
                AppLocalizations.of(context).translate('reset_password_title'),
            body: AppLocalizations.of(context).translate('reset_password_body'),
          );
        }
      },
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context).translate('reset_password'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                _EmailInput(),
                SizedBox(height: 8.0),
                _ResetPasswordButton(),
                SizedBox(height: 8.0),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacement(LoginPage.route()),
                  child: Text(
                    AppLocalizations.of(context).translate('sign_in'),
                    style: TextStyle(
                        color: HexColor.fromHex(ColorConstants.callToAction)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: TextField(
              key: const Key('resetPasswordForm_emailInput_textField'),
              onChanged: (email) =>
                  context.read<ResetPasswordCubit>().emailChanged(email),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: AppLocalizations.of(context).translate('email'),
                helperText: '',
                errorText: state.email.invalid
                    ? AppLocalizations.of(context).translate('invalid_email')
                    : null,
              ),
              onSubmitted: (value) async {
                if (state.status.isValidated)
                  await context.read<ResetPasswordCubit>().resetPassword();
              }),
        );
      },
    );
  }
}

class _ResetPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('resetPasswordForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  primary: HexColor.fromHex(ColorConstants.primaryColor),
                ),
                child: Text(
                  AppLocalizations.of(context).translate('reset_password'),
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: state.status.isValidated
                    ? () async {
                        await context
                            .read<ResetPasswordCubit>()
                            .resetPassword();
                      }
                    : null,
              );
      },
    );
  }
}

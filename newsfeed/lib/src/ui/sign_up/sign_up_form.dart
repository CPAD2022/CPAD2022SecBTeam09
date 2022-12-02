import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:news/src/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:news/src/blocs/sign_up_bloc/sign_up_cubit.dart';
import 'package:news/src/constants/ColorConstants.dart';
import 'package:news/src/constants/enums.dart';
import 'package:news/src/extensions/Color.dart';
import 'package:news/src/ui/login/login_page.dart';
import 'package:news/src/utils/app_localizations.dart';
import 'package:provider/provider.dart';
import '../dialogs/message_dialog.dart';

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
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
            title:
                AppLocalizations.of(context).translate('invalid_sign_up_title'),
            body:
                AppLocalizations.of(context).translate('invalid_sign_up_body'),
          );
        } else if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pushReplacement(LoginPage.route());
          MessageDialog.showMessageDialog(
            context: context,
            title: AppLocalizations.of(context)
                .translate('verification_email_title'),
            body: AppLocalizations.of(context)
                .translate('verification_email_body'),
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
                    AppLocalizations.of(context).translate('sign_up'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                _FirstNameInput(),
                SizedBox(height: 8.0),
                _LastNameInput(),
                SizedBox(height: 8.0),
                _DateOfBirthInput(),
                SizedBox(height: 8.0),
                _EmailInput(),
                SizedBox(height: 8.0),
                _PasswordInput(),
                SizedBox(height: 8.0),
                _GenderInput(),
                SizedBox(height: 8.0),
                _SignUpButton(),
                SizedBox(height: 8.0),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacement(LoginPage.route()),
                  child: Text(
                    AppLocalizations.of(context).translate('log_in'),
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

class _FirstNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.firstName != current.firstName,
      builder: (context, state) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: TextField(
            key: const Key('signUpForm_firstNameInput_textField'),
            onChanged: (firstName) =>
                context.read<SignUpCubit>().firstNameChanged(firstName),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person),
              labelText: AppLocalizations.of(context).translate('first_name'),
              errorText: state.firstName.invalid
                  ? AppLocalizations.of(context).translate('first_name_error')
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class _LastNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.lastName != current.lastName,
      builder: (context, state) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: TextField(
            key: const Key('signUpForm_lastNameInput_textField'),
            onChanged: (lastName) =>
                context.read<SignUpCubit>().lastNameChanged(lastName),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person),
              labelText: AppLocalizations.of(context).translate('last_name'),
              errorText: state.lastName.invalid
                  ? AppLocalizations.of(context).translate('last_name_error')
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class _DateOfBirthInput extends StatefulWidget {
  @override
  __DateOfBirthInputState createState() => __DateOfBirthInputState();
}

class __DateOfBirthInputState extends State<_DateOfBirthInput> {
  DateTime selectedDate = DateTime.now();
  String labelText;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        labelText = "${selectedDate.toLocal()}".split(' ')[0];
        context.read<SignUpCubit>().dateOfBirthChanged(labelText);
      });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.dateOfBirth != current.dateOfBirth,
      builder: (context, state) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: TextField(
            key: const Key('signUpForm_dateOfBirthInput_textField'),
            onTap: () => _selectDate(context),
            readOnly: true,
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person),
              labelText: labelText ??
                  AppLocalizations.of(context).translate('date_of_birth'),
              errorText: state.dateOfBirth.invalid
                  ? AppLocalizations.of(context)
                      .translate('date_of_birth_error')
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: TextField(
            key: const Key('signUpForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<SignUpCubit>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              labelText: AppLocalizations.of(context).translate('email'),
              errorText: state.email.invalid
                  ? AppLocalizations.of(context).translate('invalid_email')
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: TextField(
              key: const Key('signUpForm_passwordInput_textField'),
              onChanged: (password) =>
                  context.read<SignUpCubit>().passwordChanged(password),
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                hintMaxLines: 2,
                labelText: AppLocalizations.of(context).translate('password'),
                helperText:
                    AppLocalizations.of(context).translate('password_hint'),
                errorText: state.password.invalid
                    ? AppLocalizations.of(context).translate('invalid_password')
                    : null,
              ),
              onSubmitted: (value) {
                if (state.status.isValidated) _submitForm(context);
              }),
        );
      },
    );
  }
}

Gender _gender = Gender.male;

class _GenderInput extends StatefulWidget {
  @override
  __GenderInputState createState() => __GenderInputState();
}

class __GenderInputState extends State<_GenderInput> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400),
      child: Row(
        children: [
          Flexible(child: Icon(Icons.person)),
          SizedBox(width: 8.0),
          Flexible(
              child: Text(AppLocalizations.of(context).translate('gender'))),
          Expanded(
            flex: 3,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(AppLocalizations.of(context).translate('male')),
                  leading: Radio<Gender>(
                    value: Gender.male,
                    groupValue: _gender,
                    onChanged: (Gender value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context).translate('female')),
                  leading: Radio<Gender>(
                    value: Gender.female,
                    groupValue: _gender,
                    onChanged: (Gender value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('signUpForm_continue_raisedButton'),
                child: Text(
                  AppLocalizations.of(context).translate('create_account'),
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  primary: HexColor.fromHex(ColorConstants.callToAction),
                ),
                onPressed: state.status.isValidated
                    ? () => _submitForm(context)
                    : null,
              );
      },
    );
  }
}

void _submitForm(BuildContext context) async {
  String gender = _gender == Gender.male ? 'Male' : 'Female';
  await context.read<SignUpCubit>().signUpFormSubmitted(gender);
  context.read<SignUpCubit>().sendVerificationEmail();
}

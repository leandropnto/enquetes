import 'package:enquetes/ui/helpers/errors/ui_error.dart';
import 'package:enquetes/ui/helpers/helpers.dart';
import 'package:enquetes/ui/pages/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordConfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<SignUpPresenter>();
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 32),
      child: StreamBuilder<UIError>(
        stream: presenter.passwordConfirmationErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: R.strings.confirmPassword,
              icon: Icon(
                Icons.lock,
                color: Theme.of(context).primaryColorLight,
              ),
              errorText: snapshot.hasData ? snapshot.data.description : null,
            ),
            obscureText: true,
            onChanged: presenter.validatePasswordConfirmation,
          );
        },
      ),
    );
  }
}

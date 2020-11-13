import 'package:enquetes/ui/helpers/errors/ui_error.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login_presenter.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<LoginPresenter>();
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 32),
      child: StreamBuilder<UIError>(
        stream: presenter.passwordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: 'Senha',
              icon: Icon(
                Icons.lock,
                color: Theme.of(context).primaryColorLight,
              ),
              errorText: snapshot.hasData ? snapshot.data.description : null,
            ),
            obscureText: true,
            onChanged: presenter.validatePassword,
          );
        },
      ),
    );
  }
}

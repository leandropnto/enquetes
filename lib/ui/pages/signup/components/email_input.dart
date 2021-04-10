import 'package:enquetes/ui/helpers/errors/ui_error.dart';
import 'package:enquetes/ui/helpers/helpers.dart';
import 'package:enquetes/ui/pages/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<SignUpPresenter>();
    return StreamBuilder<UIError?>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          autocorrect: false,
          decoration: InputDecoration(
            labelText: R.strings.email,
            icon: Icon(
              Icons.email,
              color: Theme.of(context).primaryColorLight,
            ),
            errorText: snapshot.hasData ? snapshot.data?.description : null,
          ),
          onChanged: presenter.validateEmail,
          keyboardType: TextInputType.emailAddress,
        );
      },
    );
  }
}

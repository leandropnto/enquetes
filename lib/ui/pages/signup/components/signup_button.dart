import 'package:enquetes/ui/helpers/helpers.dart';
import 'package:enquetes/ui/pages/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<SignUpPresenter>();
    return StreamBuilder<bool>(
      stream: presenter.isFormValidStream,
      builder: (context, snapshot) {
        return RaisedButton(
          onPressed: snapshot.data == true ? presenter.auth : null,
          child: Text(R.strings.addAccount.toUpperCase()),
        );
      },
    );
  }
}

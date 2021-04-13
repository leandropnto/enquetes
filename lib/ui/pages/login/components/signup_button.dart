import 'package:enquetes/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login_presenter.dart';

class SignupButton extends StatelessWidget {
  final LoginPresenter loginPresenter;

  const SignupButton({Key? key, required this.loginPresenter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<LoginPresenter>();
    return FlatButton.icon(
      onPressed: loginPresenter.goToSignUp,
      icon: Icon(Icons.person),
      label: Text(R.strings.addAccount),
    );
  }
}

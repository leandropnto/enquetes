import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login_presenter.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<LoginPresenter>();
    return StreamBuilder<bool?>(
      stream: presenter.isFormValidStream,
      builder: (context, snapshot) {
        return ElevatedButton(
          onPressed: snapshot.data == true ? presenter.auth : null,
          child: Text('ENTRAR'),
        );
      },
    );
  }
}

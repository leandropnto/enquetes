import 'package:enquetes/ui/helpers/errors/ui_error.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login_presenter.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<LoginPresenter>();
    return StreamBuilder<UIError?>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          autocorrect: false,
          decoration: InputDecoration(
            labelText: 'Email',
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

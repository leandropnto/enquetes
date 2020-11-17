import 'package:enquetes/ui/helpers/errors/ui_error.dart';
import 'package:enquetes/ui/helpers/helpers.dart';
import 'package:enquetes/ui/pages/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<SignUpPresenter>();
    return StreamBuilder<UIError>(
      stream: presenter.nameErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: R.strings.name,
            icon: Icon(
              Icons.person,
              color: Theme.of(context).primaryColorLight,
            ),
            errorText: snapshot.hasData ? snapshot.data.description : null,
          ),
          onChanged: presenter.validateName,
          keyboardType: TextInputType.name,
        );
      },
    );
  }
}

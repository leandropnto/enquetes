import 'dart:async';

import 'package:enquetes/ui/helpers/errors/ui_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;

  final _emailError = Rx<UIError>();

  final _isFormValid = false.obs;

  Stream<UIError> get emailErrorStream => _emailError.stream;

  Stream<bool> get isFormValidStream => _isFormValid.stream;

  GetxSignUpPresenter({
    @required this.validation,
  });

  void _validateForm() {
    _isFormValid.value = false;
  }

  UIError _validateField({String field, String value}) {
    final error = validation.validate(field: field, value: value);
    return error.fold(ifNone: () {
      return null;
    }, ifSome: (err) {
      switch (err) {
        case ValidationError.requiredField:
          return UIError.requiredField;
        case ValidationError.invalidField:
          return UIError.invalidField;

        default:
          return null;
      }
    });
  }

  void validateEmail(String email) {
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void dispose() {
    debugPrint("disponse GetxSignUpPresenter");
  }
}
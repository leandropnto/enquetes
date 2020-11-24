import 'dart:async';

import 'package:enquetes/domain/usecases/usecases.dart';
import 'package:enquetes/ui/helpers/errors/ui_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;
  final AddAccount addAccount;

  final _emailError = Rx<UIError>();
  final _nameError = Rx<UIError>();
  final _passwordError = Rx<UIError>();
  final _passwordConfirmationError = Rx<UIError>();

  final _isFormValid = false.obs;

  String _name, _email, _password, _passwordConfirmation;

  Stream<UIError> get emailErrorStream => _emailError.stream;

  Stream<UIError> get nameErrorStream => _nameError.stream;

  Stream<UIError> get passwordErrorStream => _passwordError.stream;

  Stream<UIError> get passwordConfirmationErrorStream => _passwordConfirmationError.stream;

  Stream<bool> get isFormValidStream => _isFormValid.stream;

  GetxSignUpPresenter({
    @required this.validation,
    @required this.addAccount,
  });

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _nameError.value == null &&
        _passwordError.value == null &&
        _passwordConfirmationError.value == null &&
        _name != null &&
        _email != null &&
        _password != null &&
        _passwordConfirmation != null;
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
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField(field: 'name', value: name);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField(field: 'passwordConfirmation', value: passwordConfirmation);
    _validateForm();
  }

  void dispose() {
    debugPrint("dispose GetxSignUpPresenter");
  }

  Future<void> signUp() async {
    await addAccount.add(AddAccountParams(
      name: _name,
      email: _email,
      password: _password,
      passwordConfirmation: _passwordConfirmation,
    ));
  }
}

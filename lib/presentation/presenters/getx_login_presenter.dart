import 'dart:async';

import 'package:enquetes/domain/helpers/domain_error.dart';
import 'package:enquetes/domain/usecases/usecases.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController {
  final Validation validation;
  final Authentication authentication;

  final _emailError = RxString();
  final _passwordError = RxString();
  final _mainError = RxString();
  final _isFormValid = false.obs;
  final _isLoading = false.obs;

  String _email;
  String _password;

  Stream<String> get emailErrorStream => _emailError.stream;

  Stream<String> get passwordErrorStream => _passwordError.stream;

  Stream<String> get mainErrorStream => _mainError.stream;

  Stream<bool> get isFormValidStream => _isFormValid.stream;

  Stream<bool> get isLoadingStream => _isLoading.stream;

  GetxLoginPresenter({
    @required this.validation,
    @required this.authentication,
  });

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value =
        validation.validate(field: 'password', value: password);
    _validateForm();
  }

  Future<void> auth() async {
    _isLoading.value = true;
    try {
      await authentication
          .auth(AuthenticationParams(email: _email, secret: _password));
    } on DomainError catch (e) {
      _mainError.value = e.description;
    }

    _isLoading.value = false;
  }

  void dispose() {
    debugPrint("disponse GetxLoginPresenter");
  }
}

import 'dart:async';

import 'package:enquetes/domain/helpers/helpers.dart';
import 'package:enquetes/domain/usecases/usecases.dart';
import 'package:enquetes/ui/helpers/errors/ui_error.dart';
import 'package:enquetes/ui/pages/signup/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController implements SignUpPresenter {
  final Validation validation;
  final AddAccountUseCase addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  final _emailError = Rx<UIError?>(null);
  final _nameError = Rx<UIError?>(null);
  final _mainError = Rx<UIError?>(null);
  final _passwordError = Rx<UIError?>(null);
  final _passwordConfirmationError = Rx<UIError?>(null);

  final Rx<bool?> _isFormValid = false.obs;
  final Rx<bool?> _isLoading = false.obs;

  final Rx<String?> _navigateTo = Rx<String?>(null);

  String? _name, _email, _password, _passwordConfirmation;

  Stream<UIError?> get emailErrorStream => _emailError.stream;

  Stream<UIError?> get nameErrorStream => _nameError.stream;

  Stream<UIError?> get mainErrorStream => _mainError.stream;

  Stream<UIError?> get passwordErrorStream => _passwordError.stream;

  Stream<UIError?> get passwordConfirmationErrorStream =>
      _passwordConfirmationError.stream;

  Stream<bool?> get isFormValidStream => _isFormValid.stream;

  Stream<bool?> get isLoadingStream => _isLoading.stream;
  Stream<String?> get navigateStream => _navigateTo.stream;

  GetxSignUpPresenter({
    required this.validation,
    required this.addAccount,
    required this.saveCurrentAccount,
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

  UIError? _validateField({required String field, required String value}) {
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
    _passwordConfirmationError.value = _validateField(
        field: 'passwordConfirmation', value: passwordConfirmation);
    _validateForm();
  }

  void dispose() {
    debugPrint("dispose GetxSignUpPresenter");
  }

  Future<void> signUp() async {
    _isLoading.value = true;
    try {
      final account = await addAccount.add(AddAccountParams(
        name: _name ?? "",
        email: _email ?? "",
        password: _password ?? "",
        passwordConfirmation: _passwordConfirmation ?? "",
      ));
      account.fold(
        (l) => l.when(
          (inUse) => _mainError.value = UIError.emailInUse,
          (invalid) => _mainError.value = UIError.invalidCredentials,
          (unexpected) => _mainError.value = UIError.unexpected,
          () => _mainError.value = UIError.unexpected,
        ),
        (r) async => (await saveCurrentAccount.save(r)).fold(
          (l) => _mainError.value = UIError.unexpected,
          (r) => {_navigateTo.value = '/surveys'},
        ),
      );
    } on DomainError {
      _mainError.value = UIError.unexpected;
    } catch (e) {
      _mainError.value = UIError.unexpected;
    }
    _isLoading.value = false;
  }

  void goToLogin() {
    _navigateTo.value = "/login";
  }
}

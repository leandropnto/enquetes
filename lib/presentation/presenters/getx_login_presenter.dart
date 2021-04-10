import 'dart:async';

import 'package:enquetes/ui/helpers/errors/ui_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';
import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  final _emailError = Rx<UIError?>(null);
  final _passwordError = Rx<UIError?>(null);
  final _mainError = Rx<UIError?>(null);
  final _isFormValid = false.obs;
  final _isLoading = false.obs;
  final _navigateTo = RxString("");

  String? _email;
  String? _password;

  Stream<UIError?> get emailErrorStream => _emailError.stream;

  Stream<UIError?> get passwordErrorStream => _passwordError.stream;

  Stream<UIError?> get mainErrorStream => _mainError.stream;

  Stream<bool?> get isFormValidStream => _isFormValid.stream;

  Stream<bool?> get isLoadingStream => _isLoading.stream;

  Stream<String?> get navigateStream => _navigateTo.stream;

  set navigate(String value) => _navigateTo.value = value;

  GetxLoginPresenter({
    required this.authentication,
    required this.validation,
    required this.saveCurrentAccount,
  });

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
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

  void validateEmail(String? email) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email ?? "");
    _validateForm();
  }

  void validatePassword(String? password) {
    _password = password;
    _passwordError.value =
        _validateField(field: 'password', value: password ?? "");
    _validateForm();
  }

  Future<void> auth() async {
    _isLoading.value = true;
    try {
      final account = await authentication.auth(
          AuthenticationParams(email: _email ?? "", secret: _password ?? ""));
      account.fold((l) {
        l.when(
          (invalid) => _mainError.value = UIError.invalidCredentials,
          (error) => _mainError.value = UIError.unexpected,
          () => _mainError.value = UIError.unexpected,
        );
      }, (r) {
        saveCurrentAccount.save(account.value);
        navigate = "/surveys";
      });
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.unexpected:
          _mainError.value = UIError.unexpected;
          break;
        case DomainError.invalidCredentials:
          _mainError.value = UIError.invalidCredentials;
          break;
        case DomainError.emailInUse:
          _mainError.value = UIError.invalidCredentials;
          break;
      }
    } on Exception {
      _mainError.value = UIError.unexpected;
    } catch (e) {
      _mainError.value = UIError.unexpected;
    }

    _isLoading.value = false;
  }

  void dispose() {
    debugPrint("dispose GetxLoginPresenter");
  }

  @override
  void goToSignUp() {
    _navigateTo.value = "/signup";
  }
}

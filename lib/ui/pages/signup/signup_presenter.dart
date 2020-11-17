import 'package:enquetes/ui/helpers/errors/ui_error.dart';

abstract class SignUpPresenter {
  Stream<UIError> get nameErrorStream;

  Stream<UIError> get emailErrorStream;

  Stream<UIError> get passwordErrorStream;

  Stream<UIError> get passwordConfirmationErrorStream;

  Stream<UIError> get mainErrorStream;

  Stream<bool> get isFormValidStream;

  Stream<bool> get isLoadingStream;

  Stream<String> get navigateStream;

  void validateEmail(String email);

  void validatePassword(String password);

  void validatePasswordConfirmation(String password);

  void validateName(String name);

  Future<void> auth();

  void dispose();
}

import 'package:enquetes/ui/helpers/errors/ui_error.dart';

abstract class LoginPresenter {
  Stream<UIError> get emailErrorStream;

  Stream<UIError> get passwordErrorStream;

  Stream<UIError> get mainErrorStream;

  Stream<bool> get isFormValidStream;

  Stream<bool> get isLoadingStream;

  Stream<String> get navigateStream;

  void validateEmail(String email);

  void validatePassword(String password);

  Future<void> auth();

  void dispose();

  void goToSignUp();
}

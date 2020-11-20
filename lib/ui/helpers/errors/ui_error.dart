import 'package:enquetes/ui/helpers/helpers.dart';

enum UIError {
  unexpected,
  invalidCredentials,
  requiredField,
  invalidField,
  emailInUse
}

extension UIErrorExt on UIError {
  String get description {
    switch (this) {
      case UIError.invalidCredentials:
        return R.strings.msgInvalidCredentials;
      case UIError.requiredField:
        return R.strings.msgRequiredField;
      case UIError.invalidField:
        return R.strings.msgInvalidField;
      case UIError.emailInUse:
        return R.strings.msgEmailInUse;
      default:
        return R.strings.msgUnexpectedError;
    }
  }
}

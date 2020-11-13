import 'package:enquetes/ui/helpers/helpers.dart';

enum UIError {
  unexpected,
  invalidCredentials,
  requiredField,
  invalidField,
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
      default:
        return R.strings.msgUnexpectedError;
    }
  }
}

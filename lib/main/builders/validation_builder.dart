import '../../validation/protocols/protocols.dart';
import '../../validation/validators/validators.dart';

class ValidationBuilder {
  static ValidationBuilder? _instance;
  String? fieldName;
  List<FieldValidation> _validations = [];

  ValidationBuilder._();

  static ValidationBuilder field(String fieldName) {
    _instance = ValidationBuilder._();
    _instance?.fieldName = fieldName;
    return _instance!;
  }

  ValidationBuilder required() {
    _validations.add(RequiredFieldValidation(fieldName));
    return this;
  }

  ValidationBuilder email() {
    _validations.add(EmailValidation(fieldName));
    return this;
  }

  List<FieldValidation> build() {
    return _validations;
  }
}

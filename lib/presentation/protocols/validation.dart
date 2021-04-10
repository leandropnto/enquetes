import 'package:enquetes/domain/core/option.dart';

abstract class Validation {
  Option<ValidationError> validate(
      {required String field, required String value});
}

enum ValidationError { requiredField, invalidField }

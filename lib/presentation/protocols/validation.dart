import 'package:enquetes/domain/core/option.dart';
import 'package:meta/meta.dart';

abstract class Validation {
  Option<ValidationError> validate(
      {@required String field, @required String value});
}

enum ValidationError { requiredField, invalidField }

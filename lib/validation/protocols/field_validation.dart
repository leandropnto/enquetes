import 'package:enquetes/domain/core/option.dart';
import 'package:enquetes/presentation/protocols/protocols.dart';

abstract class FieldValidation {
  String? get field;

  Option<ValidationError> validate(String? value);
}

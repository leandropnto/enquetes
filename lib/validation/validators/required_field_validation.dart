import 'package:enquetes/domain/core/option.dart';
import 'package:enquetes/presentation/protocols/protocols.dart';
import 'package:equatable/equatable.dart';

import '../protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  @override
  Option<ValidationError> validate(String value) {
    return value?.isNotEmpty == true
        ? None()
        : Some(ValidationError.requiredField);
  }

  @override
  List<Object> get props => [field];
}

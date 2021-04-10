import 'package:enquetes/domain/core/option.dart';
import 'package:enquetes/presentation/protocols/protocols.dart';
import 'package:equatable/equatable.dart';

import '../protocols/protocols.dart';

class EmailValidation extends Equatable implements FieldValidation {
  final String? field;

  static final regexp = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");

  EmailValidation(this.field);

  @override
  Option<ValidationError> validate(String? value) {
    return value?.isNotEmpty != true || regexp.hasMatch(value!!)
        ? None()
        : Some(ValidationError.invalidField);
  }

  @override
  List<Object?> get props => [field];
}

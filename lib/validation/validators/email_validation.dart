import 'package:equatable/equatable.dart';

import '../protocols/protocols.dart';

class EmailValidation extends Equatable implements FieldValidation {
  final String field;

  static final regexp = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");

  EmailValidation(this.field);

  @override
  String validate(String value) {
    return value?.isNotEmpty != true || regexp.hasMatch(value)
        ? null
        : "E-mail inválido";
  }

  @override
  List<Object> get props => [field];
}

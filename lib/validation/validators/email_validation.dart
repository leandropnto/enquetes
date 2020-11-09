import 'package:enquetes/validation/protocols/protocols.dart';

class EmailValidation implements FieldValidation {
  final String field;

  static final regexp = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");

  EmailValidation(this.field);

  @override
  String validate(String value) {
    return value?.isNotEmpty != true || regexp.hasMatch(value)
        ? null
        : "E-mail inválido";
  }
}

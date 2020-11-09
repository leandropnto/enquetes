import 'package:enquetes/validation/protocols/protocols.dart';
import 'package:test/test.dart';

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

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });
  test('Should return null if email is empty', () {
    expect(sut.validate(''), null);
  });

  test('Should return null if email is null', () {
    expect(sut.validate(null), null);
  });

  test('Should return null if is valid', () {
    expect(sut.validate("leandro.pnto@gmail.com"), null);
  });

  test('Should return error if is valid', () {
    expect(sut.validate("leandro.pnto"), 'E-mail inválido');
  });
}

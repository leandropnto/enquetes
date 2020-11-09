import 'package:enquetes/validation/validators/validators.dart';
import 'package:test/test.dart';

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

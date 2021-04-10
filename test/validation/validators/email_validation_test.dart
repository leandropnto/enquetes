import 'package:enquetes/domain/core/option.dart';
import 'package:enquetes/presentation/protocols/protocols.dart';
import 'package:enquetes/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  EmailValidation sut = EmailValidation('any_field');

  setUp(() {
    sut = EmailValidation('any_field');
  });
  test('Should return null if email is empty', () {
    expect(sut.validate(''), None<ValidationError>());
  });

  test('Should return null if email is null', () {
    expect(sut.validate(null), None<ValidationError>());
  });

  test('Should return null if is valid', () {
    expect(sut.validate("leandro.pnto@gmail.com"), None<ValidationError>());
  });

  test('Should return error if is invalid', () {
    expect(sut.validate("leandro.pnto"), Some(ValidationError.invalidField));
  });
}

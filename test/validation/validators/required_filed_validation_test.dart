import 'package:enquetes/domain/core/option.dart';
import 'package:enquetes/presentation/protocols/protocols.dart';
import 'package:enquetes/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  RequiredFieldValidation sut;
  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });
  test('Should return None if value is not empty', () {
    expect(sut.validate('any_value'), None<ValidationError>());
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(''), Some(ValidationError.requiredField));
  });

  test('Should return error if value is null', () {
    expect(sut.validate(null), Some(ValidationError.requiredField));
  });
}

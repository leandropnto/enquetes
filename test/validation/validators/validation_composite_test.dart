import 'package:enquetes/domain/core/option.dart';
import 'package:enquetes/presentation/protocols/protocols.dart';
import 'package:enquetes/validation/protocols/protocols.dart';
import 'package:enquetes/validation/validators/validators.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  FieldValidationSpy validation1 = FieldValidationSpy();
  FieldValidationSpy validation2 = FieldValidationSpy();
  FieldValidationSpy validation3 = FieldValidationSpy();
  ValidationComposite sut =
      ValidationComposite([validation1, validation2, validation3]);

  void mockValidation1(Option<ValidationError> error) {
    when(validation1.validate(any)).thenReturn(error);
  }

  void mockValidation2(Option<ValidationError> error) {
    when(validation2.validate(any)).thenReturn(error);
  }

  void mockValidation3(Option<ValidationError> error) {
    when(validation3.validate(any)).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    when(validation1.field).thenReturn('other_field');
    mockValidation1(None<ValidationError>());
    validation2 = FieldValidationSpy();
    when(validation2.field).thenReturn('any_field');
    mockValidation2(None<ValidationError>());
    validation3 = FieldValidationSpy();
    when(validation3.field).thenReturn('other_field');
    mockValidation3(None<ValidationError>());
    sut = ValidationComposite([validation1, validation2, validation3]);
  });
  test('Should return None if all validations returns null or empty', () {
    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, isA<None<ValidationError>>());
  });

  test('Should return the first error', () {
    mockValidation1(Some(ValidationError.requiredField));
    mockValidation2(Some(ValidationError.requiredField));
    mockValidation3(Some(ValidationError.invalidField));

    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error.value, ValidationError.requiredField);
  });
}

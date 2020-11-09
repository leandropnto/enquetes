import 'package:enquetes/presentation/protocols/protocols.dart';
import 'package:enquetes/validation/protocols/protocols.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String validate({String field, String value}) {
    return null;
  }
}

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  FieldValidationSpy validation1;
  FieldValidationSpy validation2;

  setUp(() {
    validation1 = FieldValidationSpy();
    when(validation1.field).thenReturn('any_field');
    when(validation1.validate(any)).thenReturn(null);
    validation2 = FieldValidationSpy();
    when(validation2.field).thenReturn('any_field');
    when(validation2.validate(any)).thenReturn('');
  });
  test('Should return null if all validations returns null or empty', () {
    final sut = ValidationComposite([validation1, validation2]);
    final error = sut.validate(field: 'any_field', value: 'any_value');

    expect(error, null);
  });
}

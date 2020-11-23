import 'package:enquetes/domain/core/option.dart';
import 'package:enquetes/presentation/presenters/presenters.dart';
import 'package:enquetes/presentation/protocols/protocols.dart';
import 'package:enquetes/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  Validation validation;
  GetxSignUpPresenter sut;
  String email;
  String name;
  String password;

  PostExpectation mockValidationCall(String field) =>
      when(validation.validate(field: field == null ? anyNamed('field') : field, value: anyNamed('value')));

  void mockValidation({String field, Option<ValidationError> value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();

    sut = GetxSignUpPresenter(
      validation: validation,
    );
    email = faker.internet.email();
    name = faker.person.name();
    password = faker.internet.password();
    mockValidation(value: None<ValidationError>());
  });

  group('Email', () {
    test('Should call Validation with correct email', () {
      sut.validateEmail(email);

      verify(validation.validate(field: 'email', value: email)).called(1);
    });

    test('Should emit email error if validation fails', () {
      mockValidation(value: Some(ValidationError.invalidField));

      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));

      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateEmail(email);
      sut.validateEmail(email);
    });

    test('Should emit email null if validation succeeds', () {
      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));

      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateEmail(email);
      sut.validateEmail(email);
    });
  });

  group('Name', () {
    test('Should call Validation with correct name', () {
      sut.validateName(name);

      verify(validation.validate(field: 'name', value: name)).called(1);
    });

    test('Should emit name error if validation fails', () {
      mockValidation(value: Some(ValidationError.invalidField));

      sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));

      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateName(name);
      sut.validateName(name);
    });

    test('Should emit name null if validation succeeds', () {
      sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));

      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateName(name);
      sut.validateName(name);
    });
  });

  group('Password', () {
    test('Should call Validation with correct password', () {
      sut.validatePassword(password);

      verify(validation.validate(field: 'password', value: password)).called(1);
    });

    test('Should emit password error if validation fails', () {
      mockValidation(value: Some(ValidationError.invalidField));

      sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));

      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('Should emit password null if validation succeeds', () {
      sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));

      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePassword(password);
      sut.validatePassword(password);
    });
  });
}

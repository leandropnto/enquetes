import 'package:enquetes/presentation/presenters/presenters.dart';
import 'package:enquetes/presentation/protocols/protocols.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  Validation validation;
  StreamLoginPresenter sut;
  String email;
  String password;

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      value: anyNamed('value')));

  void mockValidation({String field, String value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
  });

  group('Email', () {
    test('Should call validation with correct email', () {
      sut.validateEmail(email);
      verify(validation.validate(field: 'email', value: email)).called(1);
    });

    test('Should emit email error if validation fails', () {
      mockValidation(value: "error");

      sut.emailErrorStream
          .listen(expectAsync1((error) => expect(error, 'error')));

      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateEmail(email);
      sut.validateEmail(email);
    });

    test('Should emit email null if validation succeeds', () {
      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));

      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateEmail(email);
      sut.validateEmail(email);
    });
  });

  group('Password', () {
    test('Should call validation with correct password', () {
      sut.validatePassword(password);
      verify(validation.validate(field: 'password', value: password)).called(1);
    });

    test('Should emit password error if validation fails', () {
      mockValidation(value: "error");

      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, 'error')));

      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('Should emit password null  if password is valid', () {
      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, null)));

      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePassword(password);
      sut.validatePassword(password);
    });
  });

  group('Email & Password', () {
    test('Should emit email error and password null  if email is invalid', () {
      mockValidation(field: 'email', value: 'error');

      sut.emailErrorStream
          .listen(expectAsync1((error) => expect(error, 'error')));

      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, null)));

      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateEmail(email);
      sut.validatePassword(password);
    });

    test('Should emit password error and email null  if password is invalid',
        () {
      mockValidation(field: 'password', value: 'error');

      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));

      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, 'error')));

      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateEmail(email);
      sut.validatePassword(password);
    });

    test('Should emit password and email null  if both of them are valid',
        () async {
      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, null)));

      expectLater(sut.isFormValidStream, emitsInOrder([false, true]));
      sut.validateEmail(email);
      await Future.delayed(Duration.zero);
      sut.validatePassword(password);
    });
  });
}

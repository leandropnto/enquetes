import 'package:enquetes/domain/core/option.dart';
import 'package:enquetes/domain/entities/entities.dart';
import 'package:enquetes/domain/usecases/usecases.dart';
import 'package:enquetes/presentation/presenters/presenters.dart';
import 'package:enquetes/presentation/protocols/protocols.dart';
import 'package:enquetes/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ValidationSpy extends Mock implements Validation {}

class AddAccountSpy extends Mock implements AddAccount {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  Validation validation;
  AddAccount addAccount;
  SaveCurrentAccountSpy saveCurrentAccount;
  GetxSignUpPresenter sut;
  String email;
  String name;
  String password;
  String passwordConfirmation;
  String token = faker.guid.guid();

  PostExpectation mockValidationCall(String field) =>
      when(validation.validate(field: field == null ? anyNamed('field') : field, value: anyNamed('value')));

  void mockValidation({String field, Option<ValidationError> value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAddAccountCall() => when(addAccount.add(any));
  void mockAddAccount() {
    mockAddAccountCall().thenAnswer((_) async {
      return AccountEntity(token);
    });
  }

  setUp(() {
    validation = ValidationSpy();
    addAccount = AddAccountSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();

    sut = GetxSignUpPresenter(
      validation: validation,
      addAccount: addAccount,
      saveCurrentAccount: saveCurrentAccount,
    );
    email = faker.internet.email();
    name = faker.person.name();
    password = faker.internet.password();
    passwordConfirmation = password;
    mockValidation(value: None<ValidationError>());
    mockAddAccount();
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

  group('Password Confirmation', () {
    test('Should call Validation with correct passwordConfirmation', () {
      sut.validatePasswordConfirmation(passwordConfirmation);

      verify(validation.validate(field: 'passwordConfirmation', value: passwordConfirmation)).called(1);
    });

    test('Should emit passwordConfirmation error if validation fails', () {
      mockValidation(value: Some(ValidationError.invalidField));

      sut.passwordConfirmationErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));

      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePasswordConfirmation(passwordConfirmation);
      sut.validatePasswordConfirmation(passwordConfirmation);
    });

    test('Should emit passwordConfirmation null if validation succeeds', () {
      sut.passwordConfirmationErrorStream.listen(expectAsync1((error) => expect(error, null)));

      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePasswordConfirmation(passwordConfirmation);
      sut.validatePasswordConfirmation(passwordConfirmation);
    });
  });

  group('Form', () {
    test('Should enable form button if all fields are valid', () async {
      expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

      sut.validateName(name);
      await Future.delayed(Duration.zero);
      sut.validateEmail(email);
      await Future.delayed(Duration.zero);
      sut.validatePassword(password);
      await Future.delayed(Duration.zero);
      sut.validatePasswordConfirmation(passwordConfirmation);
      await Future.delayed(Duration.zero);
    });
  });

  group('Account', () {
    test('Should call AddAccount with correct values', () async {
      sut.validateName(name);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validatePasswordConfirmation(passwordConfirmation);

      await sut.signUp();

      verify(addAccount.add(
        AddAccountParams(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
        ),
      )).called(1);
    });

    test('Should call SaveCurrentAccount with correct value', () async {
      sut.validateName(name);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validatePasswordConfirmation(passwordConfirmation);

      await sut.signUp();

      verify(saveCurrentAccount.save(AccountEntity(token))).called(1);
    });
  });
}

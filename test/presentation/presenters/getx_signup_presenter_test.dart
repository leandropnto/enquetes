import 'package:enquetes/domain/core/core.dart';
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

class AddAccountSpy extends Mock implements AddAccountUseCase {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  Validation validation = ValidationSpy();
  AddAccountUseCase addAccount = AddAccountSpy();
  SaveCurrentAccountSpy saveCurrentAccount = SaveCurrentAccountSpy();
  GetxSignUpPresenter sut = GetxSignUpPresenter(
    validation: validation,
    addAccount: addAccount,
    saveCurrentAccount: saveCurrentAccount,
  );

  String email = faker.internet.email();
  String name = faker.person.name();
  String password = faker.internet.password();
  String passwordConfirmation = password;
  String token = faker.guid.guid();

  PostExpectation mockValidationCall(String field) =>
      when(validation.validate(field: field, value: anyNamed('value') ?? ""));

  PostExpectation saveCurrentAccountCall() =>
      when(saveCurrentAccount.save(AccountEntity(Token.of(""))));

  void mockValidation(
      {required String field, required Option<ValidationError> value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAddAccountCall() => when(addAccount.add(AddAccountParams(
        name: "",
        email: "",
        password: "",
        passwordConfirmation: "",
      )));
  void mockAddAccount() {
    mockAddAccountCall().thenAnswer((_) async {
      return AccountEntity(Token.of(token))
          .right<AddAccountFailures, AccountEntity>();
    });
  }

  void mockSaveCurrentAccountError() {
    saveCurrentAccountCall().thenAnswer((_) async =>
        ValueFailure.unexpectedError(Exception()).left<ValueFailure, Unit>());
  }

  void mockSaveCurrentAccount() {
    saveCurrentAccountCall()
        .thenAnswer((_) async => unit.right<ValueFailure, Unit>());
  }

  void mockAddAccountError(AddAccountFailures accountFailures) {
    mockAddAccountCall().thenAnswer(
        (_) async => accountFailures.left<AddAccountFailures, AccountEntity>());
  }

  setUp(() {
    mockValidation(field: "", value: None<ValidationError>());
    mockAddAccount();
    mockSaveCurrentAccount();
  });

  group('Email', () {
    test('Should call Validation with correct email', () {
      sut.validateEmail(email);

      verify(validation.validate(field: 'email', value: email)).called(1);
    });

    test('Should emit email error if validation fails', () {
      mockValidation(field: "", value: Some(ValidationError.invalidField));

      sut.emailErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.invalidField)));

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

  group('Name', () {
    test('Should call Validation with correct name', () {
      sut.validateName(name);

      verify(validation.validate(field: 'name', value: name)).called(1);
    });

    test('Should emit name error if validation fails', () {
      mockValidation(field: "", value: Some(ValidationError.invalidField));

      sut.nameErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.invalidField)));

      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateName(name);
      sut.validateName(name);
    });

    test('Should emit name null if validation succeeds', () {
      sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));

      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

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
      mockValidation(field: "", value: Some(ValidationError.invalidField));

      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.invalidField)));

      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('Should emit password null if validation succeeds', () {
      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, null)));

      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePassword(password);
      sut.validatePassword(password);
    });
  });

  group('Password Confirmation', () {
    test('Should call Validation with correct passwordConfirmation', () {
      sut.validatePasswordConfirmation(passwordConfirmation);

      verify(validation.validate(
              field: 'passwordConfirmation', value: passwordConfirmation))
          .called(1);
    });

    test('Should emit passwordConfirmation error if validation fails', () {
      mockValidation(field: "", value: Some(ValidationError.invalidField));

      sut.passwordConfirmationErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.invalidField)));

      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePasswordConfirmation(passwordConfirmation);
      sut.validatePasswordConfirmation(passwordConfirmation);
    });

    test('Should emit passwordConfirmation null if validation succeeds', () {
      sut.passwordConfirmationErrorStream
          .listen(expectAsync1((error) => expect(error, null)));

      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

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

      verify(saveCurrentAccount.save(AccountEntity(Token.of(token)))).called(1);
    });

    test('Should emit UnexpectedError if SaveCurrentAccount fails', () async {
      mockSaveCurrentAccountError();
      sut.validateName(name);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validatePasswordConfirmation(passwordConfirmation);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.mainErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.unexpected)));

      await sut.signUp();
    });

    test('Should emit correct events  if AddAccount success', () async {
      sut.validateName(name);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validatePasswordConfirmation(passwordConfirmation);

      expectLater(sut.isLoadingStream, emits(true));

      await sut.signUp();
    });

    test('Should emit correct events on EmailInUseError', () async {
      mockAddAccountError(AddAccountFailures.emailInUse(email));

      sut.validateName(name);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validatePasswordConfirmation(passwordConfirmation);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.mainErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.emailInUse)));

      await sut.signUp();
    });

    test('Should emit correct events on UnexpectedError', () async {
      mockAddAccountError(AddAccountFailures.unexpectedError("any_value"));

      sut.validateName(name);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validatePasswordConfirmation(passwordConfirmation);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.mainErrorStream
          .listen(expectAsync1((error) => expect(error, UIError.unexpected)));

      await sut.signUp();
    });

    test('Should change page on success', () async {
      sut.validateName(name);
      sut.validateEmail(email);
      sut.validatePassword(password);
      sut.validatePasswordConfirmation(passwordConfirmation);

      sut.navigateStream
          .listen(expectAsync1((page) => expect(page, '/surveys')));

      await sut.signUp();
    });

    test('Should got to LoginPage on link click', () async {
      sut.navigateStream.listen(
        expectAsync1(
          (page) => expect(page, "/login"),
        ),
      );

      sut.goToLogin();
    });
  });
}

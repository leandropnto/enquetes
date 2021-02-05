import 'package:enquetes/domain/core/core.dart';
import 'package:enquetes/domain/core/option.dart';
import 'package:enquetes/domain/entities/account/account_entity.dart';
import 'package:enquetes/domain/entities/entities.dart';
import 'package:enquetes/domain/helpers/domain_error.dart';
import 'package:enquetes/domain/usecases/usecases.dart';
import 'package:enquetes/presentation/presenters/presenters.dart';
import 'package:enquetes/presentation/protocols/protocols.dart';
import 'package:enquetes/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  Validation validation;
  GetxLoginPresenter sut;
  String email;
  String password;
  AuthenticationSpy authentication;
  SaveCurrentAccount saveCurrentAccount;

  PostExpectation mockValidationCall(String field) =>
      when(validation.validate(field: field == null ? anyNamed('field') : field, value: anyNamed('value')));

  void mockValidation({String field, Option<ValidationError> value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAuthenticationCall() => when(authentication.auth(any));

  void mockAuthentication() {
    mockAuthenticationCall().thenAnswer(
        (_) async => Either<AuthenticationFailures, AccountEntity>.right(AccountEntity(Token.of(faker.guid.guid()))));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxLoginPresenter(
      validation: validation,
      authentication: authentication,
      saveCurrentAccount: saveCurrentAccount,
    );
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation(value: None<ValidationError>());
    mockAuthentication();
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

  group('Password', () {
    test('Should call validation with correct password', () {
      sut.validatePassword(password);
      verify(validation.validate(field: 'password', value: password)).called(1);
    });

    test('Should emit password error if validation fails', () {
      mockValidation(value: Some(ValidationError.requiredField));

      sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));

      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('Should emit password null  if password is valid', () {
      sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));

      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePassword(password);
      sut.validatePassword(password);
    });
  });

  group('Email & Password', () {
    test('Should emit email error and password null  if email is invalid', () {
      mockValidation(field: 'email', value: Some(ValidationError.invalidField));

      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));

      sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));

      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateEmail(email);
      sut.validatePassword(password);
    });

    test('Should emit password error and email null  if password is invalid', () {
      mockValidation(field: 'password', value: Some(ValidationError.requiredField));

      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));

      sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));

      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validateEmail(email);
      sut.validatePassword(password);
    });

    test('Should emit password and email null  if both of them are valid', () async {
      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
      sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));

      expectLater(sut.isFormValidStream, emitsInOrder([false, true]));
      sut.validateEmail(email);
      await Future.delayed(Duration.zero);
      sut.validatePassword(password);
    });

    test('Should call authentication with correct values', () async {
      sut.validateEmail(email);
      sut.validatePassword(password);

      await sut.auth();

      verify(authentication.auth(AuthenticationParams(email: email, secret: password)));
    });

    test('Should emit correct events on Authentication Success', () async {
      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.auth();
    });

    test('Should emit correct events on InvalidCredentialsError', () async {
      mockAuthenticationError(DomainError.invalidCredentials);

      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.mainErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidCredentials)));

      await sut.auth();
    });

    test('Should emit correct events on UnexpectedError', () async {
      mockAuthenticationError(DomainError.unexpected);

      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.mainErrorStream.listen(expectAsync1((error) => expect(error, UIError.unexpected)));

      await sut.auth();
    });

    // test('Should not emit after dispose', () async {
    //   expectLater(sut.emailErrorStream, neverEmits(null));
    //   sut.dispose();
    //   sut.validateEmail(email);
    // });
  });
}

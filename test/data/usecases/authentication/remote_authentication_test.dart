import 'package:enquetes/data/http/http.dart';
import 'package:enquetes/data/usecases/usecases.dart';
import 'package:enquetes/domain/core/core.dart';
import 'package:enquetes/domain/entities/entities.dart';
import 'package:enquetes/domain/usecases/authentication.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  HttpClientSpy httpClient = HttpClientSpy();
  String url = faker.internet.httpsUrl();
  Authentication sut = RemoteAuthentication(httpClient: httpClient, url: url);
  AuthenticationParams params = AuthenticationParams(
      email: faker.internet.email(), secret: faker.internet.password());

  PostExpectation mockRequest() => when(
        httpClient.request(
            url: anyNamed('url') ?? "",
            method: anyNamed('method') ?? "",
            body: anyNamed('body') ?? {}),
      );

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  Map mockValidData() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  setUp(() {
    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.auth(params);

    verify(httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.secret}));
  });

  test('Should left UnexpectedError if HttpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final result = await sut.auth(params);

    expect(result, isA<Either<AuthenticationFailures, AccountEntity>>());
  });

  test('Should left UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final result = await sut.auth(params);

    expect(result, isA<Either<AuthenticationFailures, AccountEntity>>());
  });

  test('Should left UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final result = await sut.auth(params);

    expect(result, isA<Either<AuthenticationFailures, AccountEntity>>());
  });

  test('Should left InvalidCredentialsError  if HttpClient returns 401',
      () async {
    mockHttpError(HttpError.unauthorized);

    final result = await sut.auth(params);

    expect(result, isA<Either<AuthenticationFailures, AccountEntity>>());
  });

  test('Should return an Account if HttpClient return 200', () async {
    final validaData = mockValidData();
    mockHttpData(validaData);

    final account = await sut.auth(params);

    account.fold((l) => {throw Exception("Should not handle this")},
        (r) => expect(r.token.getOrCrash(), validaData['accessToken']));
  });

  test(
      'Should throw UnexpectedError if HttpClient return 200 with invalid data',
      () async {
    mockHttpData({'invalid_key': 'invalid value'});

    final result = await sut.auth(params);

    expect(result, isA<Either<AuthenticationFailures, AccountEntity>>());
  });
}

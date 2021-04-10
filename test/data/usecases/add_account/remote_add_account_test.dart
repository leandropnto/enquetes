import 'package:enquetes/data/http/http.dart';
import 'package:enquetes/data/usecases/add_account/remote_add_account_params.dart';
import 'package:enquetes/data/usecases/usecases.dart';
import 'package:enquetes/domain/core/core.dart';
import 'package:enquetes/domain/entities/entities.dart';
import 'package:enquetes/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  String password = faker.internet.password();
  HttpClientSpy httpClient = HttpClientSpy();
  String url = faker.internet.httpsUrl();
  RemoteAddAccount sut = RemoteAddAccount(httpClient: httpClient, url: url);
  AddAccountParams params = AddAccountParams(
      name: faker.person.name(),
      email: faker.internet.email(),
      password: password,
      passwordConfirmation: password);

  PostExpectation mockRequest() => when(
        httpClient.request(
          url: anyNamed('url') ?? "",
          method: anyNamed('method') ?? "",
          body: anyNamed('body') ?? {},
        ),
      );

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  Map mockValidData() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  Map httpResponse = mockValidData();

  setUp(() {
    mockHttpData(httpResponse);
  });

  test('Should call HttpClient with correct values', () async {
    await sut.add(params);

    verify(
      httpClient.request(
        url: url,
        method: 'post',
        body: RemoteAddAccountParams.fromDomain(params).toJson(),
      ),
    ).called(1);
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = await sut.add(params);

    expect(future, isA<Either<AddAccountFailures, AccountEntity>>());
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = await sut.add(params);

    expect(future, isA<Either<AddAccountFailures, AccountEntity>>());
  });

  test('Should throw InvalidCredentials if HttpClient returns 403', () async {
    mockHttpError(HttpError.forbidden);

    final future = await sut.add(params);

    expect(future, isA<Either<AddAccountFailures, AccountEntity>>());
  });

  test('Should return an Account if HttpClient returns 200 ', () async {
    final account = await sut.add(params);

    account.fold((l) => throw Exception("Error get token"),
        (r) => expect(r.token.getOrCrash(), httpResponse['accessToken']));
  });

  test('Should throw unexpectedError if HttpClient return 200 if invalid data ',
      () async {
    mockHttpData({'invalid_key': 'invalid_value'});
    final future = await sut.add(params);

    expect(future, isA<Either<AddAccountFailures, AccountEntity>>());
  });
}

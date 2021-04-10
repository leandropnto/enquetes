import 'package:enquetes/data/models/models.dart';
import 'package:enquetes/domain/core/core.dart';
import 'package:enquetes/domain/entities/account/account_entity.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import 'remote_authentication_params.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({@required this.httpClient, @required this.url});

  Future<Either<AuthenticationFailures, AccountEntity>> auth(
      AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    try {
      final httpResponse =
          await httpClient.request(url: url, method: 'post', body: body);
      return RemoteAccountModel.fromJson(httpResponse).toEntity().right();
    } on HttpError catch (error) {
      return error == HttpError.unauthorized
          ? AuthenticationFailures.invalidCredentials(params)
              .left() //DomainError.invalidCredentials
          : AuthenticationFailures.unexpectedError(Exception("$error"))
              .left(); //DomainError.unexpected;
    }
  }
}

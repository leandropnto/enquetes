import 'package:enquetes/domain/helpers/domain_error.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteAddAccount {
  final HttpClient httpClient;
  final String url;

  RemoteAddAccount({@required this.httpClient, @required this.url});

  Future<void> add(AddAccountParams params) async {
    try {
      final body = RemoteAddAccountParams.fromDomain(params).toJson();
      await httpClient.request(url: url, method: 'post', body: body);
    } on HttpError catch (error) {
      if (error == HttpError.forbidden) {
        throw DomainError.emailInUse;
      }

      throw DomainError.unexpected;
    }
  }
}

class RemoteAddAccountParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  RemoteAddAccountParams({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.passwordConfirmation,
  });

  factory RemoteAddAccountParams.fromDomain(AddAccountParams entity) =>
      RemoteAddAccountParams(
        name: entity.name,
        email: entity.email,
        password: entity.password,
        passwordConfirmation: entity.passwordConfirmation,
      );

  Map toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'passwordConfirmation': passwordConfirmation
      };
}

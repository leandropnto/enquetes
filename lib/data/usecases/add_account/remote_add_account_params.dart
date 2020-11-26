import 'package:enquetes/domain/usecases/usecases.dart';
import 'package:meta/meta.dart';

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

  factory RemoteAddAccountParams.fromDomain(AddAccountParams entity) => RemoteAddAccountParams(
        name: entity.name,
        email: entity.email,
        password: entity.password,
        passwordConfirmation: entity.passwordConfirmation,
      );

  Map toJson() => {'name': name, 'email': email, 'password': password, 'passwordConfirmation': passwordConfirmation};
}

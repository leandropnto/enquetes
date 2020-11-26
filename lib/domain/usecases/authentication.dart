import 'package:enquetes/domain/core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../entities/entities.dart';

abstract class Authentication {
  Future<Either<AuthenticationFailures, AccountEntity>> auth(AuthenticationParams params);
}

class AuthenticationParams extends Equatable {
  final String email;
  final String secret;

  AuthenticationParams({@required this.email, @required this.secret});

  @override
  List<Object> get props => [email, secret];
}

class AuthenticationFailures {
  AuthenticationFailures._();

  factory AuthenticationFailures.invalidCredentials(AuthenticationParams params) = InvalidCredentials;

  factory AuthenticationFailures.unexpectedError(Exception exception) = AuthenticationUnexpectedError;

  R when<R>(
    R Function(AuthenticationFailures) invalidCredentials,
    R Function(AuthenticationUnexpectedError) unexpectedError,
    R Function() orElse,
  ) {
    if (this is InvalidCredentials) {
      return invalidCredentials(this);
    } else if (this is AuthenticationUnexpectedError) {
      return unexpectedError(this);
    } else {
      return orElse();
    }
  }
}

class InvalidCredentials extends AuthenticationFailures {
  final AuthenticationParams params;

  InvalidCredentials(this.params) : super._();
}

class AuthenticationUnexpectedError extends AuthenticationFailures {
  final Exception exception;

  AuthenticationUnexpectedError(this.exception) : super._();
}

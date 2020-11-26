import 'package:enquetes/domain/core/either.dart';
import 'package:enquetes/domain/core/value_failure.dart';
import 'package:enquetes/domain/core/value_objects.dart';
import 'package:enquetes/domain/core/value_validators.dart';

class Token extends ValueObject<String> {
  const Token._(this.value);

  factory Token.of(String token) => Token._(validateNonNull(token));

  @override
  final Either<ValueFailure, String> value;
}

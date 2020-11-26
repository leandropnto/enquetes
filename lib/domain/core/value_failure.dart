abstract class ValueFailure {
  ValueFailure._();

  factory ValueFailure.fieldShouldNotNull(String value) = FieldShouldNotNull;

  factory ValueFailure.unexpectedError(Exception value) = UnexpectedError;
}

class FieldShouldNotNull extends ValueFailure {
  final String value;
  FieldShouldNotNull(this.value) : super._();
}

class UnexpectedError extends ValueFailure {
  final Exception value;
  UnexpectedError(this.value) : super._();
}

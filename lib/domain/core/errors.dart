import 'value_failure.dart';

class UnexpectedValueError extends Error {
  UnexpectedValueError(this.valueFailure);

  final ValueFailure valueFailure;

  @override
  String toString() {
    const explanation =
        "Encountered a ValueFailure at a unrecoverable point. Terminating.";
    return Error.safeToString("$explanation Failure was $valueFailure");
  }
}

class NotAuthenticatedError extends Error {}

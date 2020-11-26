import 'either.dart';
import 'value_failure.dart';

Either<ValueFailure, String> validateNonNull(String input) {
  return input != null
      ? input.right()
      : ValueFailure.fieldShouldNotNull(input).left();
}

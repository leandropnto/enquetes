import 'package:uuid/uuid.dart';

import 'either.dart';
import 'errors.dart';
import 'unit.dart';
import 'value_failure.dart';

abstract class ValueObject<T> {
  const ValueObject();
  bool isValid() => value.isRight();
  bool isNotValid() => value.isLeft();

  Either<ValueFailure, T> get value;

  Either<ValueFailure, Unit> get failureOrUnit =>
      value.fold((f) => f.left(), (r) => unit.right());

  T getOrCrash() {
    return value.fold((l) => throw UnexpectedValueError(l), (r) => r);
  }

  String? mapToErrorMessage(String errorText) =>
      value.isLeft() ? errorText : null;

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ValueObject<T> && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Value($value)';
}

class UniqueId extends ValueObject<String> {
  factory UniqueId() {
    return UniqueId._(Uuid().v1().right());
  }

  factory UniqueId.fromUniqueString(String uniqueId) {
    assert(uniqueId != null);
    return UniqueId._(uniqueId.right());
  }

  const UniqueId._(this.value);

  @override
  final Either<ValueFailure, String> value;
}

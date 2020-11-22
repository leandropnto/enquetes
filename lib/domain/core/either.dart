abstract class Either<L, R> {
  const Either._();

  const factory Either.left(L value) = _Left<L, R>._;

  const factory Either.right(R value) = _Right<L, R>._;

  bool isLeft() => this is _Left;

  bool isRight() => this is _Right;

  R get value;

  T fold<T>(T Function(L) onLeft, T Function(R) onRight);

  Either<L, T> map<T>(T Function(R) f);

  Either<L, T> flatMap<T>(Either<L, T> Function(R) f);

  Either<L1, R> mapLeft<L1>(L1 Function(L) f) => fold(
        (l) => Either.left(f(l)),
        (r) => Either.right(r),
      );

  Either<L, R> operator |(Function(R val) block) => this is _Left<L, R> ? this : flatMap((r) => block(value));
}

class _Left<L, R> extends Either<L, R> {
  const _Left._(this._value) : super._();

  final L _value;

  @override
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) => onLeft(_value);

  @override
  Either<L, T> map<T>(T Function(R) f) => _Left._(_value);

  @override
  Either<L, T> flatMap<T>(Either<L, T> Function(R) f) => _Left._(_value);

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(other) => other is _Left<L, R> && other._value == _value;

  @override
  String toString() => 'Left($_value)';

  @override
  R get value => throw StateError('left called on right value');
}

class _Right<L, R> extends Either<L, R> {
  const _Right._(this._value) : super._();

  final R _value;

  @override
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) => onRight(_value);

  @override
  Either<L, T> map<T>(T Function(R) f) => _Right._(f(_value));

  @override
  Either<L, T> flatMap<T>(Either<L, T> Function(R) f) => f(_value);

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(other) => other is _Right<L, R> && other._value == _value;

  @override
  String toString() => 'Right($_value)';

  @override
  R get value => _value;
}

extension EitherExt<T> on T {
  Either<L, R> left<L, R>() {
    return Either<L, R>.left(this as L);
  }

  Either<L, R> right<L, R>() {
    return Either<L, R>.right(this as R);
  }
}

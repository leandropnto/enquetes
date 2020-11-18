abstract class Either<L, R> {
  const Either._();
  dynamic get value;

  B fold<B>(B ifLeft(L l), B ifRight(R r));

  Either<L2, R> mapLeft<L2>(L2 f(L l)) => fold((L l) => left(f(l)), right);
  Either<L, R2> mapRight<R2>(R2 f(R r)) => fold(left, (R r) => right(f(r)));
  bool isLeft() => this is Left;
  bool isRight() => this is Right;
}

class Left<L, R> extends Either<L, R> {
  final L _value;

  Left._(this._value) : super._();

  L get value => _value;

  @override
  B fold<B>(B Function(L l) ifLeft, B Function(R r) ifRight) => ifLeft(_value);
}

class Right<L, R> extends Either<L, R> {
  final R _value;

  const Right._(this._value) : super._();

  R get value => _value;

  @override
  B fold<B>(B Function(L l) ifLeft, B Function(R r) ifRight) => ifRight(_value);
}

Either<L, R> left<L, R>(L l) => Left._(l);
Either<L, R> right<L, R>(R r) => Right._(r);

import 'package:equatable/equatable.dart';

abstract class Option<T> extends Equatable {
  const Option._();

  Option none() => None();

  bool isSome();

  bool isNone();

  R fold<R>({R ifNone(), R ifSome(T a)});

  Option<R> map<R>(Function(T value) block, {R Function() orElse}) {
    return isSome()
        ? optionOf(block(value))
        : orElse != null
            ? some(orElse())
            : none();
  }

  Option<T> operator |(Function(T value) block);

  T get value;

  @override
  List<Object> get props => [value];
}

class Some<A> extends Option<A> {
  final A _value;

  const Some(this._value) : super._();

  A get value => _value != null ? _value : throw Exception("Empty Option exception");

  @override
  R fold<R>({R Function() ifNone, R Function(A a) ifSome}) => ifSome(_value);

  @override
  Option<A> operator |(Function(A value) block) => optionOf(block(_value));

  @override
  bool isNone() => false;

  @override
  bool isSome() => true;
}

class None<T> extends Option<T> {
  const None._() : super._();

  factory None() => const None._();

  @override
  R fold<R>({R Function() ifNone, R Function(T a) ifSome}) => ifNone();

  @override
  Option<T> operator |(Function(T value) block) => None();

  @override
  T get value => throw Exception("None instance!");

  @override
  bool isSome() => false;

  @override
  bool isNone() => true;
}

Option<A> none<A>() => new None();

Option<A> some<A>(A a) => new Some(a);

Option<A> optionOf<A>(A value) => value != null ? some(value) : none();

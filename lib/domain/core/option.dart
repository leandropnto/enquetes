abstract class Option<T> {
  T _value;

  R fold<R>({R Function() ifNone, R Function(T value) ifSome}) {
    return _value != null ? ifSome(_value) : ifNone();
  }

  R map<R>(Function(T value) block, {R Function() orElse}) {
    return _value != null
        ? block(_value)
        : orElse != null
            ? orElse()
            : null;
  }

  Option<R> andThen<R>(R Function(T value) block) {
    return _value != null ? Some(block(_value)) : None<R>();
  }

  Option<T> operator |(Function(T value) block) {
    return Some(block(_value));
  }

  T get value;

  Option._(this._value);

  Option<T> some<T>(T value) => Some(value);

  Option none() => None();
}

class Some<T> extends Option<T> {
  T _value;

  Some(this._value) : super._(_value);

  @override
  T get value =>
      _value != null ? _value : throw Exception("Empty Option exception");
}

class None<T> extends Option<T> {
  None() : super._(null);

  @override
  T get value => throw Exception("Empty Option exception");
}

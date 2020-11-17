import 'package:enquetes/domain/core/either.dart';
import 'package:test/test.dart';

void main() {
  //Variables

  //Mocks

  //helpers

  setUp(() {});

  test('Should return a Right Either', () {
    final sut = right("any_value");
    expect(sut, isA<Right>());
  });

  test('Should return Left Either', () {
    final sut = left("any_value");
    expect(sut, isA<Left>());
  });

  test('Should map a Left value', () {
    final value = "any_value";
    final sut = left(value).mapLeft((l) => l.toUpperCase());
    expect(sut.value, value.toUpperCase());
  });

  test('Should map a Right value', () {
    final value = "any_value";
    final sut = right(value).mapRight((l) => l.toUpperCase());
    expect(sut.value, value.toUpperCase());
  });

  test('Should not map a Left value if is a Right instance', () {
    final value = "any_value";
    final sut = right(value).mapLeft((l) => l.toUpperCase());
    expect(sut.value, value);
  });

  test('Should not map a right value if is a left instance', () {
    final value = "any_value";
    final sut = left(value).mapRight((r) => r.toUpperCase());
    expect(sut.value, value);
  });

  test('Should fold a right value', () {
    final value = "any_value";
    final sut = right(value).fold((l) => "Deu erro", (r) => r.toUpperCase());
    expect(sut, value.toUpperCase());
  });

  test('Should fold a left value', () {
    final value = "any_value";
    final sut = left(value).fold((l) => l.toUpperCase(), (r) => r);
    expect(sut, value.toUpperCase());
  });
}

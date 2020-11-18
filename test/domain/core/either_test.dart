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

  test('Should validate left Instance', () {
    final value = "any_value";
    final sut = left(value);
    expect(sut.isLeft(), isTrue);
  });

  test('Should validate right Instance', () {
    final value = "any_value";
    final sut = right(value);
    expect(sut.isRight(), isTrue);
  });

  test('Should map value', () {
    final value = " any_value ";
    final sut = right(value).map((r) => r.toUpperCase()).map((r) => r.trim());
    expect(sut.value, value.toUpperCase().trim());
  });

  test('Should map value with pipe operator', () {
    final value = " any_value ";
    final sut = right(value) |
        (value) => right(value.toUpperCase()) | (value) => right(value.trim());
    expect(sut.value, value.toUpperCase().trim());
  });

  test('Should return left instance when map value returns left', () {
    final value = " any_value ";
    final sut = right<String, String>(value) |
        (value) =>
            right(value.toUpperCase()) |
            (value) => left<String, String>("Some Error");
    expect(sut.isLeft(), isTrue);
    expect(sut.value, "Some Error");
  });
}

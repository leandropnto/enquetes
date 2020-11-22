import 'package:enquetes/domain/core/either.dart';
import 'package:test/test.dart';

void main() {
  //Variables

  //Mocks

  //helpers

  setUp(() {});

  test('Should return a Right Either', () {
    final sut = Either.right("any_value");
    expect(sut.isRight(), isTrue);
  });

  test('Should return Left Either', () {
    final sut = Either.left("any_value");
    expect(sut.isLeft(), isTrue);
  });

  test('Should map a Left value', () {
    final value = "any_value";
    final sut = Either.left(value).mapLeft((l) => l.toUpperCase());
    expect(sut.fold((l) => l, (r) => ""), value.toUpperCase());
  });

  test('Should map a Right value', () {
    final value = "any_value";
    final sut = Either.right(value).map((l) => l.toUpperCase());
    expect(sut.fold((l) => "ERROR", (r) => r), value.toUpperCase());
  });

  test('Should not map a Left value if is a Right instance', () {
    final value = "any_value";
    final sut = Either.right(value).mapLeft((l) => l.toUpperCase());
    expect(sut.fold((l) => l, (r) => r), value);
  });

  test('Should not map a right value if is a left instance', () {
    final value = "any_value";
    final sut = Either.left(value).map((r) => r.toUpperCase());
    expect(sut.fold((l) => l, (r) => r), value);
  });

  test('Should fold a right value', () {
    final value = "any_value";
    final sut =
        Either.right(value).fold((l) => "Deu erro", (r) => r.toUpperCase());
    expect(sut, value.toUpperCase());
  });

  test('Should fold a left value', () {
    final value = "any_value";
    final sut = Either.left(value).fold((l) => l.toUpperCase(), (r) => r);
    expect(sut, value.toUpperCase());
  });

  test('Should validate left Instance', () {
    final value = "any_value";
    final sut = Either.left(value);
    expect(sut.isLeft(), isTrue);
  });

  test('Should validate right Instance', () {
    final value = "any_value";
    final sut = Either.right(value);
    expect(sut.isRight(), isTrue);
  });

  test('Should map value', () {
    final value = " any_value ";
    final sut =
        Either.right(value).map((r) => r.toUpperCase()).map((r) => r.trim());
    expect(sut.fold((l) => l, (r) => r), value.toUpperCase().trim());
  });

  test('Should map value with pipe operator', () {
    final value = " any_value ";
    final sut = Either.right(value) |
        (value) =>
            Either.right(value.toUpperCase()) |
            (value) => Either.right(value.trim());
    expect(sut.fold((l) => l, (r) => r), value.toUpperCase().trim());
  });

  test('Should return left instance when map value returns left', () {
    final value = " any_value ";
    final sut = Either<String, String>.right(value) |
        (value) =>
            Either<String, String>.right(value.toUpperCase()) |
            (value) => Either<String, String>.left("Some Error");
    expect(sut.isLeft(), isTrue);
    expect(sut.fold((l) => l, (r) => r), "Some Error");
  });

  test('Should instance a Right Either using extension method', () {
    final sut = "any_value".right<String, String>();
    expect(sut.isRight(), isTrue);
    expect(sut.fold((l) => l, (r) => r), "any_value");
  });
}

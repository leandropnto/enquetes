import 'package:enquetes/domain/core/option.dart';
import 'package:test/test.dart';

void main() {
  //Variables

  //Mocks

  //helpers

  setUp(() {});

  test('Should wrap a Some Instance', () {
    Option<String> text = Some("Teste");
    expect(text, isA<Some>());
  });

  test('Should wrap a None Instance', () {
    Option<String> text = None();
    expect(text, isA<None>());
  });

  test('Should have a String value', () {
    final text = 'leandro';
    Option<String> option = Some(text);
    expect(text, option.value);
  });

  test('Should throws if Option is empty', () {
    Option<String?> option = Some(null);
    expect(() => option.value, throwsA(TypeMatcher<Exception>()));
  });

  test('Should throws if get value from a None Instance', () {
    Option<String> option = None();
    expect(() => option.value, throwsA(TypeMatcher<Exception>()));
  });

  test('Should map value', () {
    final text = "any_string";
    final option = Some<String>(text);
    final mappedString = option.map<String>((value) => value.toUpperCase());
    expect(mappedString.value, text.toUpperCase());
  });

  test('Should produce OrElse value if None', () {
    final text = "any_string";
    Option<String> option = None<String>();
    final mappedString = option.map((value) => value.toUpperCase());
    expect(mappedString.value, text);
  });

  test('Should cascade flatMap', () {
    final text = " any_string ";
    Option<String> option = Some(text);

    final mappedString =
        option.map((value) => value.trim()).map((value) => value.toUpperCase());

    expect(mappedString.value, text.trim().toUpperCase());
  });

  test('Should only execute trim and return', () {
    var text = " any_string ";
    var originalText = text;
    Option<String> option = Some(text);

    final mappedString = option
        .map((value) => value.trim())
        .map<String>((value) => null)
        .map((value) {
      originalText = text.toUpperCase();
    });

    expect(mappedString, isA<None<Null>>());
    expect(text, originalText);
  });

  test('Should trim and upercase using & operator', () {
    var text = " any_string ";
    final option = Some<String>(text);
    final toUpper = (String upper) => upper.toUpperCase();
    final trimmed = (String value) => value.trim();

    final result = option | toUpper | trimmed;
    expect(result.value, text.toUpperCase().trim());
  });

  test(
      'Should create a none Instance if constructor Some is called '
      'if a null value', () {
    final opt = optionOf(null);
    expect(opt, isA<None>());
  });
}

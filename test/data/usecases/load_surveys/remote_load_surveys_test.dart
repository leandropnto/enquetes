import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../lib/data/http/http.dart';

class RemoteLoadSurveys {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveys({required this.url, required this.httpClient});

  Future<void> load() async {}
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  //Variables

  //Mocks

  //helpers

  setUp(() {});

  test('Should call HttpClient with correct values', () async {
    final url = faker.internet.httpsUrl();
    final httpClient = HttpClientSpy();
    final sut = RemoteLoadSurveys(url: url, httpClient: httpClient);

    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });
}

import 'dart:convert';

import 'package:enquetes/data/http/http.dart';
import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ClientSpy extends Mock implements Client {}

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response = await client.post(
      url,
      headers: headers,
      body: jsonBody,
    );

    return jsonDecode(response.body);
  }
}

void main() {
  Client client;
  HttpAdapter sut;
  String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('post', () {
    test('Should call post with correct values', () async {
      final body = jsonEncode({"any_key": "any_value"});
      when(
        client.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed("body"),
        ),
      ).thenAnswer((_) async => Response(body, 200));
      await sut.request(url: url, method: 'post', body: jsonDecode(body));

      verify(
        client.post(
          url,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: body,
        ),
      );
    });

    test('Should call post without body', () async {
      final body = jsonEncode({"any_key": "any_value"});
      when(client.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(body, 200));

      await sut.request(url: url, method: 'post');

      verify(
        client.post(
          any,
          headers: anyNamed('headers'),
        ),
      );
    });

    test('Should return data if post returns 200', () async {
      final body = jsonEncode({"any_key": "any_value"});
      when(client.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(body, 200));
      final response = await sut.request(url: url, method: 'post');

      expect(response, jsonDecode(body));
    });
  });
}

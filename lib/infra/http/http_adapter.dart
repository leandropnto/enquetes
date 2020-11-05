import 'dart:convert';

import 'package:enquetes/data/http/http.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

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

    return _handleResponse(response);
  }

  _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 204:
        return response.statusCode == 200 && response.body.isNotEmpty
            ? jsonDecode(response.body)
            : null;
      case 400:
        throw HttpError.badRequest;
      default:
        throw HttpError.serverError;
    }
  }
}

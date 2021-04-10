import 'dart:convert';

import 'package:enquetes/data/http/http.dart';
import 'package:http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response = await _createResponse(method, url, headers, jsonBody);

    return _handleResponse(response);
  }

  Future<Response> _createResponse(String method, String url,
      Map<String, String>? headers, String? jsonBody) async {
    try {
      switch (method) {
        case 'post':
          return await client.post(
            Uri.parse(url),
            headers: headers,
            body: jsonBody,
          );
        default:
          return Response('', 500);
      }
    } catch (e) {
      throw HttpError.serverError;
    }
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
      case 401:
        throw HttpError.unauthorized;
      case 403:
        throw HttpError.forbidden;
      case 404:
        throw HttpError.notFound;
      default:
        throw HttpError.serverError;
    }
  }
}

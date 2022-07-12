import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  Client client;

  HttpAdapter(this.client);

  Future<Map> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final uri = Uri.parse(url);
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;

    final response = await client.post(uri, headers: headers, body: jsonBody);

    if (response.statusCode == 204) {
      return null;
    }

    final jsonResponse =
        response.body.isEmpty ? null : jsonDecode(response.body);

    return jsonResponse;
  }
}
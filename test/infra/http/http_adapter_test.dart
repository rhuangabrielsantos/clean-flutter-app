import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class HttpAdapter {
  ClientSpy client;

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
    final jsonBody = body != null ? json.encode(body) : null;

    final response = await client.post(uri, headers: headers, body: jsonBody);

    if (response.statusCode == 204) {
      return null;
    }

    final jsonResponse =
        response.body.isEmpty ? null : json.decode(response.body);

    return jsonResponse;
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  HttpAdapter sut;
  ClientSpy client;
  String url;
  Uri uri;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
    uri = Uri.parse(url);
  });

  group('POST', () {
    PostExpectation mockRequest() => when(client.post(
          any,
          body: anyNamed('body'),
          headers: anyNamed('headers'),
        ));

    void mockResponse(int statusCode,
        {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call post with correct values', () async {
      await sut.request(
        url: url,
        method: 'POST',
        body: {'any_key': 'any_value'},
      );

      verify(client.post(
        uri,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        body: '{"any_key":"any_value"}',
      ));
    });

    test('Should call post without body', () async {
      await sut.request(url: url, method: 'POST');

      verify(client.post(any, headers: anyNamed('headers')));
    });

    test('Should return data if post returns 200', () async {
      final response = await sut.request(url: url, method: 'POST');

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return null if post returns 200 with no data', () async {
      mockResponse(200, body: '');

      final response = await sut.request(url: url, method: 'POST');

      expect(response, null);
    });

    test('Should return null if post returns 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(url: url, method: 'POST');

      expect(response, null);
    });

    test('Should return null if post returns 204 with data', () async {
      mockResponse(204);

      final response = await sut.request(url: url, method: 'POST');

      expect(response, null);
    });
  });
}

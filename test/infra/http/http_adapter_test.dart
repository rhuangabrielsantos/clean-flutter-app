import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class HttpAdapter {
  ClientSpy client;

  HttpAdapter(this.client);

  Future<void> request({@required String url, @required String method}) async {
    final uri = Uri.parse(url);
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    await client.post(uri, headers: headers);
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
    test('Should call post with correct values', () async {
      await sut.request(url: url, method: 'POST');

      verify(client.post(uri, headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      }));
    });
  });
}

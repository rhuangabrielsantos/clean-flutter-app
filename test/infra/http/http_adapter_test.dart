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
    await client.post(uri);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  group('POST', () {
    test('Should call post with correct values', () async {
      final client = ClientSpy();
      final sut = HttpAdapter(client);
      final url = faker.internet.httpUrl();
      final uri = Uri.parse(url);

      await sut.request(url: url, method: 'POST');

      verify(client.post(uri));
    });
  });
}

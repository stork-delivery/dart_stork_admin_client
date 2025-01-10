// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:dart_stork_admin_client/dart_stork_admin_client.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockHttpClient extends Mock implements http.Client {}

void main() {
  group('DartStorkAdminClient', () {
    late http.Client httpClient;
    late DartStorkAdminClient client;
    const apiKey = 'test-api-key';
    const baseUrl = 'https://stork.erickzanardoo.workers.dev';

    setUpAll(() {
      registerFallbackValue(
        Uri.parse(baseUrl),
      );
    });

    setUp(() {
      httpClient = _MockHttpClient();
      client = DartStorkAdminClient(
        client: httpClient,
        apiKey: apiKey,
      );
    });

    test('can be instantiated', () {
      expect(DartStorkAdminClient(apiKey: apiKey), isNotNull);
    });

    group('getApp', () {
      test('makes correct http request', () async {
        when(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps/1'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response(
            json.encode({
              'id': 1,
              'name': 'Test App',
              'publicMetadata': true,
            }),
            200,
          ),
        );

        await client.getApp(1);

        verify(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps/1'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).called(1);
      });

      test('throws exception on non-200 response', () async {
        when(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps/1'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(
          () => client.getApp(1),
          throwsA(isA<Exception>()),
        );
      });

      test('uses custom base url when provided', () async {
        final customClient = DartStorkAdminClient(
          baseUrl: 'https://custom.url',
          client: httpClient,
          apiKey: apiKey,
        );

        when(
          () => httpClient.get(
            Uri.parse('https://custom.url/v1/admin/apps/1'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response(
            json.encode({
              'id': 1,
              'name': 'Test App',
              'publicMetadata': true,
            }),
            200,
          ),
        );

        await customClient.getApp(1);

        verify(
          () => httpClient.get(
            Uri.parse('https://custom.url/v1/admin/apps/1'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).called(1);
      });
    });

    group('listApps', () {
      test('makes correct http request', () async {
        when(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response('[]', 200),
        );

        await client.listApps();

        verify(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).called(1);
      });

      test('returns list of apps on success', () async {
        when(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response(
            json.encode([
              {
                'id': 1,
                'name': 'Test App 1',
                'publicMetadata': true,
              },
              {
                'id': 2,
                'name': 'Test App 2',
                'publicMetadata': false,
              },
            ]),
            200,
          ),
        );

        final apps = await client.listApps();

        expect(apps.length, equals(2));
        expect(apps[0].id, equals(1));
        expect(apps[0].name, equals('Test App 1'));
        expect(apps[1].id, equals(2));
        expect(apps[1].name, equals('Test App 2'));
      });

      test('throws exception on error response', () async {
        when(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response('Not Found', 404),
        );

        expect(
          () => client.listApps(),
          throwsA(isA<Exception>()),
        );
      });

      test('uses custom base url when provided', () async {
        final customClient = DartStorkAdminClient(
          baseUrl: 'https://custom.url',
          client: httpClient,
          apiKey: apiKey,
        );

        when(
          () => httpClient.get(
            Uri.parse('https://custom.url/v1/admin/apps'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response('[]', 200),
        );

        await customClient.listApps();

        verify(
          () => httpClient.get(
            Uri.parse('https://custom.url/v1/admin/apps'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).called(1);
      });
    });

    group('createApp', () {
      test('creates an app successfully', () async {
        when(
          () => httpClient.post(
            Uri.parse('$baseUrl/v1/admin/apps'),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'name': 'New App',
              'publicMetadata': true,
            }),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            json.encode({
              'id': 1,
              'name': 'New App',
              'publicMetadata': true,
            }),
            201,
          ),
        );

        final app = await client.createApp(
          name: 'New App',
          publicMetadata: true,
        );

        expect(app.id, equals(1));
        expect(app.name, equals('New App'));
        expect(app.publicMetadata, isTrue);
      });

      test('throws on non-201 response', () {
        when(
          () => httpClient.post(
            Uri.parse('$baseUrl/v1/admin/apps'),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'name': 'New App',
              'publicMetadata': true,
            }),
          ),
        ).thenAnswer((_) async => http.Response('', 400));

        expect(
          () => client.createApp(
            name: 'New App',
            publicMetadata: true,
          ),
          throwsException,
        );
      });
    });

    group('updateApp', () {
      test('updates an app successfully', () async {
        when(
          () => httpClient.patch(
            Uri.parse('$baseUrl/v1/admin/apps/1'),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'name': 'Updated App',
              'publicMetadata': false,
            }),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            json.encode({
              'id': 1,
              'name': 'Updated App',
              'publicMetadata': false,
            }),
            200,
          ),
        );

        final app = await client.updateApp(
          id: 1,
          name: 'Updated App',
          publicMetadata: false,
        );

        expect(app.id, equals(1));
        expect(app.name, equals('Updated App'));
        expect(app.publicMetadata, isFalse);
      });

      test('throws on non-200 response', () {
        when(
          () => httpClient.patch(
            Uri.parse('$baseUrl/v1/admin/apps/1'),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'name': 'Updated App',
            }),
          ),
        ).thenAnswer((_) async => http.Response('', 400));

        expect(
          () => client.updateApp(
            id: 1,
            name: 'Updated App',
          ),
          throwsException,
        );
      });
    });

    group('removeApp', () {
      test('removes an app successfully', () async {
        when(
          () => httpClient.delete(
            Uri.parse('$baseUrl/v1/admin/apps/1'),
            headers: {
              'Authorization': 'Bearer $apiKey',
            },
          ),
        ).thenAnswer((_) async => http.Response('', 204));

        await expectLater(
          client.removeApp(1),
          completes,
        );
      });

      test('throws on non-204 response', () {
        when(
          () => httpClient.delete(
            Uri.parse('$baseUrl/v1/admin/apps/1'),
            headers: {
              'Authorization': 'Bearer $apiKey',
            },
          ),
        ).thenAnswer((_) async => http.Response('', 400));

        expect(
          () => client.removeApp(1),
          throwsException,
        );
      });
    });

    group('dispose', () {
      test('closes the http client', () {
        when(() => httpClient.close()).thenReturn(null);

        client.dispose();

        verify(() => httpClient.close()).called(1);
      });
    });
  });
}

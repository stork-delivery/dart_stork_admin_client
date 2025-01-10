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

    setUpAll(() {
      registerFallbackValue(
          Uri.parse('https://stork.erickzanardoo.workers.dev'));
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
            Uri.parse(
                'https://stork.erickzanardoo.workers.dev/v1/admin/apps/1'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response(
            json.encode({
              'id': 1,
              'name': 'Test App',
              'versions': ['1.0.0'],
            }),
            200,
          ),
        );

        await client.getApp(1);

        verify(
          () => httpClient.get(
            Uri.parse(
                'https://stork.erickzanardoo.workers.dev/v1/admin/apps/1'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).called(1);
      });

      test('throws exception on non-200 response', () async {
        when(
          () => httpClient.get(
            Uri.parse(
                'https://stork.erickzanardoo.workers.dev/v1/admin/apps/1'),
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
              'versions': ['1.0.0'],
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
            Uri.parse('https://stork.erickzanardoo.workers.dev/v1/admin/apps'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response('[]', 200),
        );

        await client.listApps();

        verify(
          () => httpClient.get(
            Uri.parse('https://stork.erickzanardoo.workers.dev/v1/admin/apps'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).called(1);
      });

      test('returns list of apps on success', () async {
        when(
          () => httpClient.get(
            Uri.parse('https://stork.erickzanardoo.workers.dev/v1/admin/apps'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response(
            json.encode([
              {
                'id': 1,
                'name': 'Test App 1',
                'versions': ['1.0.0'],
              },
              {
                'id': 2,
                'name': 'Test App 2',
                'versions': ['1.0.0'],
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
            Uri.parse('https://stork.erickzanardoo.workers.dev/v1/admin/apps'),
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

    group('dispose', () {
      test('closes the http client', () {
        when(() => httpClient.close()).thenReturn(null);

        client.dispose();

        verify(() => httpClient.close()).called(1);
      });
    });
  });
}

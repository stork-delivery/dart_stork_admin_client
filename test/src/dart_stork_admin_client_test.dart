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

    group('listVersions', () {
      test('makes correct http request', () async {
        when(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps/1/versions'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response('[]', 200),
        );

        await client.listVersions(1);

        verify(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps/1/versions'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).called(1);
      });

      test('returns list of versions on success', () async {
        when(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps/1/versions'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response(
            json.encode([
              {
                'id': 1,
                'appId': 1,
                'version': '1.0.0',
                'changelog': 'Initial release',
                'createdAt': '2025-01-14 10:01:17',
              },
              {
                'id': 2,
                'appId': 1,
                'version': '1.0.1',
                'changelog': 'Bug fixes',
                'createdAt': '2025-01-14 10:01:17',
              },
            ]),
            200,
          ),
        );

        final versions = await client.listVersions(1);

        expect(versions.length, equals(2));
        expect(versions[0].id, equals(1));
        expect(versions[0].version, equals('1.0.0'));
        expect(versions[0].changelog, equals('Initial release'));
        expect(versions[0].createdAt, equals(DateTime(2025, 1, 14, 10, 1, 17)));
        expect(versions[1].id, equals(2));
        expect(versions[1].version, equals('1.0.1'));
        expect(versions[1].changelog, equals('Bug fixes'));
        expect(versions[1].createdAt, equals(DateTime(2025, 1, 14, 10, 1, 17)));
      });

      test('throws exception on error response', () async {
        when(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps/1/versions'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response('Not Found', 404),
        );

        expect(
          () => client.listVersions(1),
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
            Uri.parse('https://custom.url/v1/admin/apps/1/versions'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response('[]', 200),
        );

        await customClient.listVersions(1);

        verify(
          () => httpClient.get(
            Uri.parse('https://custom.url/v1/admin/apps/1/versions'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).called(1);
      });
    });

    group('getVersion', () {
      test('makes correct http request', () async {
        when(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps/1/versions/1.0.0'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response(
            json.encode({
              'id': 2,
              'appId': 1,
              'version': '1.0.0',
              'changelog': 'Initial release',
              'createdAt': '2025-01-14 10:01:17',
            }),
            200,
          ),
        );

        await client.getVersion(1, '1.0.0');

        verify(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps/1/versions/1.0.0'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).called(1);
      });

      test('returns version on success', () async {
        when(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps/1/versions/1.0.0'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response(
            json.encode({
              'id': 2,
              'appId': 1,
              'version': '1.0.0',
              'changelog': 'Initial release',
              'createdAt': '2025-01-14 10:01:17',
            }),
            200,
          ),
        );

        final version = await client.getVersion(1, '1.0.0');

        expect(version.id, equals(2));
        expect(version.appId, equals(1));
        expect(version.version, equals('1.0.0'));
        expect(version.changelog, equals('Initial release'));
        expect(version.createdAt, equals(DateTime(2025, 1, 14, 10, 1, 17)));
      });

      test('throws exception on error response', () async {
        when(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps/1/versions/1.0.0'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response('Not Found', 404),
        );

        expect(
          () => client.getVersion(1, '1.0.0'),
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
            Uri.parse('https://custom.url/v1/admin/apps/1/versions/1.0.0'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response(
            json.encode({
              'id': 2,
              'appId': 1,
              'version': '1.0.0',
              'changelog': 'Initial release',
              'createdAt': '2025-01-14 10:01:17',
            }),
            200,
          ),
        );

        await customClient.getVersion(1, '1.0.0');

        verify(
          () => httpClient.get(
            Uri.parse('https://custom.url/v1/admin/apps/1/versions/1.0.0'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).called(1);
      });
    });

    group('listArtifacts', () {
      test('makes correct http request', () async {
        when(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps/1/versions/1.0.0/artifacts'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response('[]', 200),
        );

        await client.listArtifacts(1, '1.0.0');

        verify(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps/1/versions/1.0.0/artifacts'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).called(1);
      });

      test('returns list of artifacts on success', () async {
        when(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps/1/versions/1.0.0/artifacts'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response(
            json.encode([
              {
                'id': 1,
                'versionId': 2,
                'name': 'app-release.apk',
                'platform': 'android',
              },
              {
                'id': 2,
                'versionId': 2,
                'name': 'app.ipa',
                'platform': 'ios',
              },
            ]),
            200,
          ),
        );

        final artifacts = await client.listArtifacts(1, '1.0.0');

        expect(artifacts.length, equals(2));
        expect(artifacts[0].id, equals(1));
        expect(artifacts[0].versionId, equals(2));
        expect(artifacts[0].name, equals('app-release.apk'));
        expect(artifacts[0].platform, equals('android'));
        expect(artifacts[1].id, equals(2));
        expect(artifacts[1].versionId, equals(2));
        expect(artifacts[1].name, equals('app.ipa'));
        expect(artifacts[1].platform, equals('ios'));
      });

      test('throws exception on error response', () async {
        when(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps/1/versions/1.0.0/artifacts'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response('Not Found', 404),
        );

        expect(
          () => client.listArtifacts(1, '1.0.0'),
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
            Uri.parse(
              'https://custom.url/v1/admin/apps/1/versions/1.0.0/artifacts',
            ),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response('[]', 200),
        );

        await customClient.listArtifacts(1, '1.0.0');

        verify(
          () => httpClient.get(
            Uri.parse(
              'https://custom.url/v1/admin/apps/1/versions/1.0.0/artifacts',
            ),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).called(1);
      });
    });

    group('downloadArtifact', () {
      test('makes correct http request', () async {
        when(
          () => httpClient.get(
            Uri.parse(
              '$baseUrl/v1/admin/apps/1/versions/1.0.0/artifacts/platforms/android/download',
            ),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response('binary-data', 200),
        );

        await client.downloadArtifact(1, '1.0.0', 'android');

        verify(
          () => httpClient.get(
            Uri.parse(
              '$baseUrl/v1/admin/apps/1/versions/1.0.0/artifacts/platforms/android/download',
            ),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).called(1);
      });

      test('returns binary data on success', () async {
        final binaryData = [1, 2, 3, 4, 5];
        when(
          () => httpClient.get(
            Uri.parse(
              '$baseUrl/v1/admin/apps/1/versions/1.0.0/artifacts/platforms/android/download',
            ),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response.bytes(
            binaryData,
            200,
          ),
        );

        final result = await client.downloadArtifact(1, '1.0.0', 'android');
        expect(result, equals(binaryData));
      });

      test('throws exception on error response', () async {
        when(
          () => httpClient.get(
            Uri.parse(
              '$baseUrl/v1/admin/apps/1/versions/1.0.0/artifacts/platforms/android/download',
            ),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response('Not Found', 404),
        );

        expect(
          () => client.downloadArtifact(1, '1.0.0', 'android'),
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
            Uri.parse(
              'https://custom.url/v1/admin/apps/1/versions/1.0.0/artifacts/platforms/android/download',
            ),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response('binary-data', 200),
        );

        await customClient.downloadArtifact(1, '1.0.0', 'android');

        verify(
          () => httpClient.get(
            Uri.parse(
              'https://custom.url/v1/admin/apps/1/versions/1.0.0/artifacts/platforms/android/download',
            ),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).called(1);
      });
    });

    group('getItchIOData', () {
      test('makes correct http request', () async {
        when(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps/1/itchio'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer(
          (_) async => http.Response(
            json.encode({
              'id': 1,
              'appId': 1,
              'buttlerKey': 'test-key',
              'itchIOUsername': 'test-user',
              'itchIOGameName': 'test-game',
            }),
            200,
          ),
        );

        final data = await client.getItchIOData(1);

        expect(data?.id, equals(1));
        expect(data?.appId, equals(1));
        expect(data?.buttlerKey, equals('test-key'));
        expect(data?.itchIOUsername, equals('test-user'));
        expect(data?.itchIOGameName, equals('test-game'));
      });

      test('returns null on 404', () async {
        when(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps/1/itchio'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer((_) async => http.Response('', 404));

        final data = await client.getItchIOData(1);
        expect(data, isNull);
      });

      test('throws on non 200/404 response', () async {
        when(
          () => httpClient.get(
            Uri.parse('$baseUrl/v1/admin/apps/1/itchio'),
            headers: {'Authorization': 'Bearer $apiKey'},
          ),
        ).thenAnswer((_) async => http.Response('', 500));

        expect(
          () => client.getItchIOData(1),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('updateItchIOData', () {
      test('makes correct http request', () async {
        when(
          () => httpClient.put(
            Uri.parse('$baseUrl/v1/admin/apps/1/itchio'),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'buttlerKey': 'test-key',
              'itchIOUsername': 'test-user',
              'itchIOGameName': 'test-game',
            }),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            json.encode({
              'id': 1,
              'appId': 1,
              'buttlerKey': 'test-key',
              'itchIOUsername': 'test-user',
              'itchIOGameName': 'test-game',
            }),
            200,
          ),
        );

        final data = await client.updateItchIOData(
          appId: 1,
          buttlerKey: 'test-key',
          itchIOUsername: 'test-user',
          itchIOGameName: 'test-game',
        );

        expect(data.id, equals(1));
        expect(data.appId, equals(1));
        expect(data.buttlerKey, equals('test-key'));
        expect(data.itchIOUsername, equals('test-user'));
        expect(data.itchIOGameName, equals('test-game'));
      });

      test('throws on non 200 response', () async {
        when(
          () => httpClient.put(
            Uri.parse('$baseUrl/v1/admin/apps/1/itchio'),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'buttlerKey': 'test-key',
              'itchIOUsername': 'test-user',
              'itchIOGameName': 'test-game',
            }),
          ),
        ).thenAnswer((_) async => http.Response('', 500));

        expect(
          () => client.updateItchIOData(
            appId: 1,
            buttlerKey: 'test-key',
            itchIOUsername: 'test-user',
            itchIOGameName: 'test-game',
          ),
          throwsA(isA<Exception>()),
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

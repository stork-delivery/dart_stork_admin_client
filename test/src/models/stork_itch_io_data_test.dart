// ignore_for_file: prefer_const_constructors
import 'package:dart_stork_admin_client/dart_stork_admin_client.dart';
import 'package:test/test.dart';

void main() {
  group('StorkItchIOData', () {
    test('can be instantiated', () {
      expect(
        StorkItchIOData(
          id: 1,
          appId: 2,
          buttlerKey: 'test-key',
          itchIOUsername: 'test-user',
          itchIOGameName: 'test-game',
        ),
        isNotNull,
      );
    });

    group('fromJson', () {
      test('creates correct instance from json', () {
        final data = StorkItchIOData.fromJson({
          'id': 1,
          'appId': 2,
          'buttlerKey': 'test-key',
          'itchIOUsername': 'test-user',
          'itchIOGameName': 'test-game',
        });

        expect(data.id, equals(1));
        expect(data.appId, equals(2));
        expect(data.buttlerKey, equals('test-key'));
        expect(data.itchIOUsername, equals('test-user'));
        expect(data.itchIOGameName, equals('test-game'));
      });

      test('throws when id is not an int', () {
        expect(
          () => StorkItchIOData.fromJson({
            'id': '1',
            'appId': 2,
            'buttlerKey': 'test-key',
            'itchIOUsername': 'test-user',
            'itchIOGameName': 'test-game',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws when appId is not an int', () {
        expect(
          () => StorkItchIOData.fromJson({
            'id': 1,
            'appId': '2',
            'buttlerKey': 'test-key',
            'itchIOUsername': 'test-user',
            'itchIOGameName': 'test-game',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws when buttlerKey is not a string', () {
        expect(
          () => StorkItchIOData.fromJson({
            'id': 1,
            'appId': 2,
            'buttlerKey': 1,
            'itchIOUsername': 'test-user',
            'itchIOGameName': 'test-game',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws when itchIOUsername is not a string', () {
        expect(
          () => StorkItchIOData.fromJson({
            'id': 1,
            'appId': 2,
            'buttlerKey': 'test-key',
            'itchIOUsername': 1,
            'itchIOGameName': 'test-game',
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws when itchIOGameName is not a string', () {
        expect(
          () => StorkItchIOData.fromJson({
            'id': 1,
            'appId': 2,
            'buttlerKey': 'test-key',
            'itchIOUsername': 'test-user',
            'itchIOGameName': 1,
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });
  });
}

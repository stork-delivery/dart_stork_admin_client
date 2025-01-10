// ignore_for_file: prefer_const_constructors
import 'package:dart_stork_admin_client/dart_stork_admin_client.dart';
import 'package:test/test.dart';

void main() {
  group('StorkApp', () {
    test('can be instantiated', () {
      expect(
        StorkApp(
          id: 1,
          name: 'test',
          publicMetadata: true,
        ),
        isNotNull,
      );
    });

    group('fromJson', () {
      test('creates correct instance from json', () {
        final app = StorkApp.fromJson({
          'id': 1,
          'name': 'test',
          'publicMetadata': true,
        });

        expect(app.id, equals(1));
        expect(app.name, equals('test'));
        expect(app.publicMetadata, equals(true));
      });

      test('throws when id is not an int', () {
        expect(
          () => StorkApp.fromJson({
            'id': '1',
            'name': 'test',
            'publicMetadata': true,
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws when name is not a string', () {
        expect(
          () => StorkApp.fromJson({
            'id': 1,
            'name': 1,
            'publicMetadata': true,
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws when publicMetadata is not a bool', () {
        expect(
          () => StorkApp.fromJson({
            'id': 1,
            'name': 'test',
            'publicMetadata': 'true',
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });
  });
}

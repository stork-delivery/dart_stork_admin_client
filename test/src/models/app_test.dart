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
        ),
        isNotNull,
      );
    });

    group('fromJson', () {
      test('creates correct instance from json', () {
        final app = StorkApp.fromJson({
          'id': 1,
          'name': 'test',
          'versions': ['1.0.0', '1.0.1'],
        });

        expect(app.id, equals(1));
        expect(app.name, equals('test'));
      });

      test('throws when id is not an int', () {
        expect(
          () => StorkApp.fromJson({
            'id': '1',
            'name': 'test',
            'versions': ['1.0.0'],
          }),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws when name is not a string', () {
        expect(
          () => StorkApp.fromJson({
            'id': 1,
            'name': 1,
            'versions': ['1.0.0'],
          }),
          throwsA(isA<TypeError>()),
        );
      });
    });
  });
}

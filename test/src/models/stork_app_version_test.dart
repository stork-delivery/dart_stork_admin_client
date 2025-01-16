// ignore_for_file: avoid_redundant_argument_values

import 'package:dart_stork_admin_client/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('StorkAppVersion', () {
    final testDateTime = DateTime(2025, 1, 14, 9, 57, 47);

    test('can be instantiated', () {
      final version = StorkAppVersion(
        id: 1,
        appId: 2,
        version: '1.0.0',
        changelog: 'Initial release',
        createdAt: testDateTime,
      );

      expect(version.id, equals(1));
      expect(version.appId, equals(2));
      expect(version.version, equals('1.0.0'));
      expect(version.changelog, equals('Initial release'));
      expect(version.createdAt, equals(testDateTime));
    });

    test('fromJson creates correct instance', () {
      final json = {
        'id': 1,
        'appId': 2,
        'version': '1.0.0',
        'changelog': 'Initial release',
        'createdAt': '2025-01-14 09:57:47',
      };

      final version = StorkAppVersion.fromJson(json);

      expect(version.id, equals(1));
      expect(version.appId, equals(2));
      expect(version.version, equals('1.0.0'));
      expect(version.changelog, equals('Initial release'));
      expect(version.createdAt, equals(testDateTime));
    });

    test('fromJson returns epoch time when date parsing fails', () {
      final json = {
        'id': 1,
        'appId': 2,
        'version': '1.0.0',
        'changelog': 'Initial release',
        'createdAt': 'invalid-date',
      };

      final version = StorkAppVersion.fromJson(json);
      final epochTime = DateTime.fromMillisecondsSinceEpoch(0);

      expect(version.id, equals(1));
      expect(version.appId, equals(2));
      expect(version.version, equals('1.0.0'));
      expect(version.changelog, equals('Initial release'));
      expect(version.createdAt, equals(epochTime));
    });

    test('toJson creates correct map', () {
      final version = StorkAppVersion(
        id: 1,
        appId: 2,
        version: '1.0.0',
        changelog: 'Initial release',
        createdAt: testDateTime,
      );

      final json = version.toJson();

      expect(
        json,
        equals(
          {
            'id': 1,
            'appId': 2,
            'version': '1.0.0',
            'changelog': 'Initial release',
            'createdAt': '2025-01-14 09:57:47',
          },
        ),
      );
    });

    test('copyWith returns new instance with updated values', () {
      final version = StorkAppVersion(
        id: 1,
        appId: 2,
        version: '1.0.0',
        changelog: 'Initial release',
        createdAt: testDateTime,
      );

      final newDateTime = DateTime(2025, 1, 14, 10, 0, 0);
      final updatedVersion = version.copyWith(
        version: '1.0.1',
        changelog: 'Bug fixes',
        createdAt: newDateTime,
      );

      expect(updatedVersion.id, equals(1)); // unchanged
      expect(updatedVersion.appId, equals(2)); // unchanged
      expect(updatedVersion.version, equals('1.0.1')); // changed
      expect(updatedVersion.changelog, equals('Bug fixes')); // changed
      expect(updatedVersion.createdAt, equals(newDateTime)); // changed
    });

    test('copyWith returns new instance when no parameters are provided', () {
      final version = StorkAppVersion(
        id: 1,
        appId: 2,
        version: '1.0.0',
        changelog: 'Initial release',
        createdAt: testDateTime,
      );

      final copiedVersion = version.copyWith();

      expect(copiedVersion.id, equals(version.id));
      expect(copiedVersion.appId, equals(version.appId));
      expect(copiedVersion.version, equals(version.version));
      expect(copiedVersion.changelog, equals(version.changelog));
      expect(copiedVersion.createdAt, equals(version.createdAt));
      expect(identical(version, copiedVersion), isFalse);
    });
  });
}

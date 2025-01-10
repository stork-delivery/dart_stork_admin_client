import 'package:dart_stork_admin_client/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Version', () {
    test('can be instantiated', () {
      const version = Version(
        id: 1,
        appId: 2,
        version: '1.0.0',
        changelog: 'Initial release',
      );

      expect(version.id, equals(1));
      expect(version.appId, equals(2));
      expect(version.version, equals('1.0.0'));
      expect(version.changelog, equals('Initial release'));
    });

    test('fromJson creates correct instance', () {
      final json = {
        'id': 1,
        'appId': 2,
        'version': '1.0.0',
        'changelog': 'Initial release',
      };

      final version = Version.fromJson(json);

      expect(version.id, equals(1));
      expect(version.appId, equals(2));
      expect(version.version, equals('1.0.0'));
      expect(version.changelog, equals('Initial release'));
    });

    test('toJson creates correct map', () {
      const version = Version(
        id: 1,
        appId: 2,
        version: '1.0.0',
        changelog: 'Initial release',
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
          },
        ),
      );
    });

    test('copyWith returns new instance with updated values', () {
      const version = Version(
        id: 1,
        appId: 2,
        version: '1.0.0',
        changelog: 'Initial release',
      );

      final updatedVersion = version.copyWith(
        version: '1.0.1',
        changelog: 'Bug fixes',
      );

      expect(updatedVersion.id, equals(1)); // unchanged
      expect(updatedVersion.appId, equals(2)); // unchanged
      expect(updatedVersion.version, equals('1.0.1')); // changed
      expect(updatedVersion.changelog, equals('Bug fixes')); // changed
    });

    test('copyWith returns new instance when no parameters are provided', () {
      const version = Version(
        id: 1,
        appId: 2,
        version: '1.0.0',
        changelog: 'Initial release',
      );

      final copiedVersion = version.copyWith();

      expect(copiedVersion.id, equals(version.id));
      expect(copiedVersion.appId, equals(version.appId));
      expect(copiedVersion.version, equals(version.version));
      expect(copiedVersion.changelog, equals(version.changelog));
      expect(identical(version, copiedVersion), isFalse);
    });
  });
}

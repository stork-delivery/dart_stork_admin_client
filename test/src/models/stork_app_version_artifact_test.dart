import 'package:dart_stork_admin_client/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('StorkAppVersionArtifact', () {
    test('can be instantiated', () {
      const artifact = StorkAppVersionArtifact(
        id: 1,
        versionId: 2,
        name: 'app-release.apk',
        platform: 'android',
        fileName: 'my-app-1.0.0.apk',
      );

      expect(artifact.id, equals(1));
      expect(artifact.versionId, equals(2));
      expect(artifact.name, equals('app-release.apk'));
      expect(artifact.platform, equals('android'));
      expect(artifact.fileName, equals('my-app-1.0.0.apk'));
    });

    test('can be instantiated without fileName', () {
      const artifact = StorkAppVersionArtifact(
        id: 1,
        versionId: 2,
        name: 'app-release.apk',
        platform: 'android',
      );

      expect(artifact.id, equals(1));
      expect(artifact.versionId, equals(2));
      expect(artifact.name, equals('app-release.apk'));
      expect(artifact.platform, equals('android'));
      expect(artifact.fileName, isNull);
    });

    test('fromJson creates correct instance with fileName', () {
      final json = {
        'id': 1,
        'versionId': 2,
        'name': 'app-release.apk',
        'platform': 'android',
        'fileName': 'my-app-1.0.0.apk',
      };

      final artifact = StorkAppVersionArtifact.fromJson(json);

      expect(artifact.id, equals(1));
      expect(artifact.versionId, equals(2));
      expect(artifact.name, equals('app-release.apk'));
      expect(artifact.platform, equals('android'));
      expect(artifact.fileName, equals('my-app-1.0.0.apk'));
    });

    test('fromJson creates correct instance without fileName', () {
      final json = {
        'id': 1,
        'versionId': 2,
        'name': 'app-release.apk',
        'platform': 'android',
      };

      final artifact = StorkAppVersionArtifact.fromJson(json);

      expect(artifact.id, equals(1));
      expect(artifact.versionId, equals(2));
      expect(artifact.name, equals('app-release.apk'));
      expect(artifact.platform, equals('android'));
      expect(artifact.fileName, isNull);
    });

    test('toJson creates correct map with fileName', () {
      const artifact = StorkAppVersionArtifact(
        id: 1,
        versionId: 2,
        name: 'app-release.apk',
        platform: 'android',
        fileName: 'my-app-1.0.0.apk',
      );

      final json = artifact.toJson();

      expect(
        json,
        equals(
          {
            'id': 1,
            'versionId': 2,
            'name': 'app-release.apk',
            'platform': 'android',
            'fileName': 'my-app-1.0.0.apk',
          },
        ),
      );
    });

    test('toJson creates correct map without fileName', () {
      const artifact = StorkAppVersionArtifact(
        id: 1,
        versionId: 2,
        name: 'app-release.apk',
        platform: 'android',
      );

      final json = artifact.toJson();

      expect(
        json,
        equals(
          {
            'id': 1,
            'versionId': 2,
            'name': 'app-release.apk',
            'platform': 'android',
          },
        ),
      );
    });

    test('copyWith returns new instance with updated values', () {
      const artifact = StorkAppVersionArtifact(
        id: 1,
        versionId: 2,
        name: 'app-release.apk',
        platform: 'android',
        fileName: 'my-app-1.0.0.apk',
      );

      final updatedArtifact = artifact.copyWith(
        name: 'app-debug.apk',
        platform: 'ios',
        fileName: 'my-app-1.0.0-debug.apk',
      );

      expect(updatedArtifact.id, equals(1)); // unchanged
      expect(updatedArtifact.versionId, equals(2)); // unchanged
      expect(updatedArtifact.name, equals('app-debug.apk')); // changed
      expect(updatedArtifact.platform, equals('ios')); // changed
      expect(
        updatedArtifact.fileName,
        equals('my-app-1.0.0-debug.apk'),
      ); // changed
    });

    test('copyWith returns new instance when no parameters are provided', () {
      const artifact = StorkAppVersionArtifact(
        id: 1,
        versionId: 2,
        name: 'app-release.apk',
        platform: 'android',
        fileName: 'my-app-1.0.0.apk',
      );

      final copiedArtifact = artifact.copyWith();

      expect(copiedArtifact.id, equals(artifact.id));
      expect(copiedArtifact.versionId, equals(artifact.versionId));
      expect(copiedArtifact.name, equals(artifact.name));
      expect(copiedArtifact.platform, equals(artifact.platform));
      expect(copiedArtifact.fileName, equals(artifact.fileName));
      expect(identical(artifact, copiedArtifact), isFalse);
    });
  });
}

/// {@template stork_app_version_artifact}
/// A model representing an artifact of a version of an app.
/// {@endtemplate}
class StorkAppVersionArtifact {
  /// {@macro stork_app_version_artifact}
  const StorkAppVersionArtifact({
    required this.id,
    required this.versionId,
    required this.name,
    required this.platform,
  });

  /// Creates a [StorkAppVersionArtifact] from a json map.
  factory StorkAppVersionArtifact.fromJson(Map<String, dynamic> json) {
    return StorkAppVersionArtifact(
      id: json['id'] as int,
      versionId: json['versionId'] as int,
      name: json['name'] as String,
      platform: json['platform'] as String,
    );
  }

  /// The unique identifier of the artifact.
  final int id;

  /// The ID of the version this artifact belongs to.
  final int versionId;

  /// The name of the artifact.
  final String name;

  /// The platform of the artifact.
  final String platform;

  /// Converts the artifact to a json map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'versionId': versionId,
      'name': name,
      'platform': platform,
    };
  }

  /// Creates a copy of this artifact with the given fields replaced with new
  /// values.
  StorkAppVersionArtifact copyWith({
    int? id,
    int? versionId,
    String? name,
    String? platform,
  }) {
    return StorkAppVersionArtifact(
      id: id ?? this.id,
      versionId: versionId ?? this.versionId,
      name: name ?? this.name,
      platform: platform ?? this.platform,
    );
  }
}

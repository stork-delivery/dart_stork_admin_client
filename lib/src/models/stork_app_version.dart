/// {@template stork_app_version}
/// A model representing a version of an app.
/// {@endtemplate}
class StorkAppVersion {
  /// {@macro stork_app_version}
  const StorkAppVersion({
    required this.id,
    required this.appId,
    required this.version,
    required this.changelog,
  });

  /// Creates a [StorkAppVersion] from a json map.
  factory StorkAppVersion.fromJson(Map<String, dynamic> json) {
    return StorkAppVersion(
      id: json['id'] as int,
      appId: json['appId'] as int,
      version: json['version'] as String,
      changelog: json['changelog'] as String,
    );
  }

  /// The unique identifier of the version.
  final int id;

  /// The ID of the app this version belongs to.
  final int appId;

  /// The version string.
  final String version;

  /// The changelog for this version.
  final String changelog;

  /// Converts the version to a json map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appId': appId,
      'version': version,
      'changelog': changelog,
    };
  }

  /// Creates a copy of this version with the given fields replaced with new
  /// values.
  StorkAppVersion copyWith({
    int? id,
    int? appId,
    String? version,
    String? changelog,
  }) {
    return StorkAppVersion(
      id: id ?? this.id,
      appId: appId ?? this.appId,
      version: version ?? this.version,
      changelog: changelog ?? this.changelog,
    );
  }
}

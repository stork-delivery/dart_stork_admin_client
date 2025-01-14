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
    required this.createdAt,
  });

  /// Creates a [StorkAppVersion] from a json map.
  factory StorkAppVersion.fromJson(Map<String, dynamic> json) {
    final createdAtStr = json['createdAt'] as String;
    final parts = createdAtStr.split(' ');
    final dateParts = parts[0].split('-');
    final timeParts = parts[1].split(':');

    return StorkAppVersion(
      id: json['id'] as int,
      appId: json['appId'] as int,
      version: json['version'] as String,
      changelog: json['changelog'] as String,
      createdAt: DateTime(
        int.parse(dateParts[0]), // year
        int.parse(dateParts[1]), // month
        int.parse(dateParts[2]), // day
        int.parse(timeParts[0]), // hour
        int.parse(timeParts[1]), // minute
        int.parse(timeParts[2]), // second
      ),
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

  /// The creation date of this version.
  final DateTime createdAt;

  /// Converts the version to a json map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appId': appId,
      'version': version,
      'changelog': changelog,
      'createdAt': '${createdAt.year.toString().padLeft(4, '0')}-'
          '${createdAt.month.toString().padLeft(2, '0')}-'
          '${createdAt.day.toString().padLeft(2, '0')} '
          '${createdAt.hour.toString().padLeft(2, '0')}:'
          '${createdAt.minute.toString().padLeft(2, '0')}:'
          '${createdAt.second.toString().padLeft(2, '0')}',
    };
  }

  /// Creates a copy of this version with the given fields replaced with new
  /// values.
  StorkAppVersion copyWith({
    int? id,
    int? appId,
    String? version,
    String? changelog,
    DateTime? createdAt,
  }) {
    return StorkAppVersion(
      id: id ?? this.id,
      appId: appId ?? this.appId,
      version: version ?? this.version,
      changelog: changelog ?? this.changelog,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

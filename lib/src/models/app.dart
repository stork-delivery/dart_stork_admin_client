/// {@template stork_app}
/// Model representing a Stork app.
/// {@endtemplate}
class StorkApp {
  /// {@macro stork_app}
  const StorkApp({
    required this.id,
    required this.name,
    required this.versions,
  });

  /// Creates a [StorkApp] from a JSON map.
  factory StorkApp.fromJson(Map<String, dynamic> json) {
    return StorkApp(
      id: json['id'] as int,
      name: json['name'] as String,
      versions: (json['versions'] as List<dynamic>).cast<String>(),
    );
  }

  /// The app ID.
  final int id;

  /// The app name.
  final String name;

  /// List of available versions.
  final List<String> versions;
}

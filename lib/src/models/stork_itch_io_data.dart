/// Data class representing Itch.io integration data
class StorkItchIOData {
  /// Creates a new instance of [StorkItchIOData]
  const StorkItchIOData({
    required this.id,
    required this.appId,
    required this.buttlerKey,
    required this.itchIOUsername,
    required this.itchIOGameName,
  });

  /// Creates a new instance of [StorkItchIOData] from a JSON map
  factory StorkItchIOData.fromJson(Map<String, dynamic> json) {
    return StorkItchIOData(
      id: json['id'] as int,
      appId: json['appId'] as int,
      buttlerKey: json['buttlerKey'] as String,
      itchIOUsername: json['itchIOUsername'] as String,
      itchIOGameName: json['itchIOGameName'] as String,
    );
  }

  /// The unique identifier
  final int id;

  /// The associated app ID
  final int appId;

  /// The Buttler key used for authentication
  final String buttlerKey;

  /// The Itch.io username
  final String itchIOUsername;

  /// The Itch.io game name
  final String itchIOGameName;
}

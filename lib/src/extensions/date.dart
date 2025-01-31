/// Extension for DateTime
extension DateExtension on DateTime {
  /// Serializes the date to a string in ISO 8601 format
  /// (e.g., "2025-01-31T17:10:18.000Z").
  String serialize() => toUtc().toIso8601String();

  /// Deserializes a string in ISO 8601 format into a DateTime.
  /// Returns epoch (1970-01-01) if the string cannot be parsed.
  static DateTime deserialize(String date) {
    try {
      return DateTime.parse(date).toLocal();
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }
}

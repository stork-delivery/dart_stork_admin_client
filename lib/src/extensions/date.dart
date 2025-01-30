/// Extension for DateTime
extension DateExtension on DateTime {
  /// Serializes the date to a string.
  String serialize() => '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')} '
      '${hour.toString().padLeft(2, '0')}:'
      '${minute.toString().padLeft(2, '0')}:'
      '${second.toString().padLeft(2, '0')}';

  /// Deserializes a string into a DateTime.
  static DateTime deserialize(String date) {
    try {
      final parts = date.split(' ');
      final dateParts = parts[0].split('-');
      final timeParts = parts[1].split(':');

      return DateTime(
        int.parse(dateParts[0]), // year
        int.parse(dateParts[1]), // month
        int.parse(dateParts[2]), // day
        int.parse(timeParts[0]), // hour
        int.parse(timeParts[1]), // minute
        int.parse(timeParts[2]), // second
      );
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }
}

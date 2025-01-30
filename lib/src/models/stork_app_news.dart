import 'package:dart_stork_admin_client/src/extensions/date.dart';

/// {@template stork_app_news}
/// A model representing a news of an app.
/// {@endtemplate}
class StorkAppNews {
  /// {@macro stork_app_news}
  const StorkAppNews({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  /// Creates a [StorkAppNews] from a json map.
  factory StorkAppNews.fromJson(Map<String, dynamic> json) {
    return StorkAppNews(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateExtension.deserialize(json['createdAt'] as String),
    );
  }

  /// Id
  final int id;

  /// Title
  final String title;

  /// Content
  final String content;

  /// Created at
  final DateTime createdAt;

  /// Converts the news to a json map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.serialize(),
    };
  }
}

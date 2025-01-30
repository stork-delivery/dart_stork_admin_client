// ignore_for_file: avoid_redundant_argument_values

import 'package:dart_stork_admin_client/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('StorkAppNews', () {
    test('can be instantiated', () {
      expect(
        StorkAppNews(
          id: 1,
          title: 'test',
          content: 'test',
          createdAt: DateTime(2024),
        ),
        isNotNull,
      );
    });

    test('can deserialize from json', () {
      final news = StorkAppNews.fromJson({
        'id': 1,
        'title': 'test',
        'content': 'test',
        'createdAt': '2024-01-01 00:00:00',
      });
      expect(news.id, equals(1));
      expect(news.title, equals('test'));
      expect(news.content, equals('test'));
      expect(news.createdAt, equals(DateTime(2024, 1, 1, 0, 0)));
    });

    test('can serialize to json', () {
      final news = StorkAppNews(
        id: 1,
        title: 'test',
        content: 'test',
        createdAt: DateTime(2024, 1, 1, 0, 0),
      );
      expect(news.toJson(), {
        'id': 1,
        'title': 'test',
        'content': 'test',
        'createdAt': '2024-01-01 00:00:00',
      });
    });
  });
}

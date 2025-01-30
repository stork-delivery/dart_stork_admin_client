import 'dart:convert';

import 'package:dart_stork_admin_client/src/models/models.dart';
import 'package:http/http.dart' as http;

/// {@template dart_stork_admin_client}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class DartStorkAdminClient {
  /// {@macro dart_stork_admin_client}
  DartStorkAdminClient({
    required String apiKey,
    String? baseUrl,
    http.Client? client,
  })  : _baseUrl = baseUrl ?? 'https://stork.erickzanardoo.workers.dev',
        _client = client ?? http.Client(),
        _apiKey = apiKey;

  final String _baseUrl;
  final http.Client _client;
  final String _apiKey;

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $_apiKey',
      };

  /// Fetches app information by its ID.
  Future<StorkApp> getApp(int appId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/v1/admin/apps/$appId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch app: ${response.statusCode}');
    }

    return StorkApp.fromJson(
      json.decode(response.body) as Map<String, dynamic>,
    );
  }

  /// Lists all available apps.
  Future<List<StorkApp>> listApps() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/v1/admin/apps'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to list apps: ${response.statusCode}');
    }

    final body = json.decode(response.body) as List<dynamic>;
    return body.cast<Map<String, dynamic>>().map(StorkApp.fromJson).toList();
  }

  /// Creates a new app.
  Future<StorkApp> createApp({
    required String name,
    required bool publicMetadata,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/v1/admin/apps'),
      headers: {
        ..._headers,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'publicMetadata': publicMetadata,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create app: ${response.statusCode}');
    }

    return StorkApp.fromJson(
      json.decode(response.body) as Map<String, dynamic>,
    );
  }

  /// Updates an existing app.
  Future<StorkApp> updateApp({
    required int id,
    String? name,
    bool? publicMetadata,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (publicMetadata != null) body['publicMetadata'] = publicMetadata;

    final response = await _client.patch(
      Uri.parse('$_baseUrl/v1/admin/apps/$id'),
      headers: {
        ..._headers,
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update app: ${response.statusCode}');
    }

    return StorkApp.fromJson(
      json.decode(response.body) as Map<String, dynamic>,
    );
  }

  /// Removes an app.
  Future<void> removeApp(int id) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/v1/admin/apps/$id'),
      headers: _headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to remove app: ${response.statusCode}');
    }
  }

  /// Lists all versions for a specific app.
  Future<List<StorkAppVersion>> listVersions(int appId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/v1/admin/apps/$appId/versions'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to list versions: ${response.statusCode}');
    }

    final body = json.decode(response.body) as List<dynamic>;
    return body
        .cast<Map<String, dynamic>>()
        .map(StorkAppVersion.fromJson)
        .toList();
  }

  /// Gets a specific version of an app.
  Future<StorkAppVersion> getVersion(int appId, String versionName) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/v1/admin/apps/$appId/versions/$versionName'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch version: ${response.statusCode}');
    }

    return StorkAppVersion.fromJson(
      json.decode(response.body) as Map<String, dynamic>,
    );
  }

  /// Lists all artifacts for a specific version.
  Future<List<StorkAppVersionArtifact>> listArtifacts(
    int appId,
    String versionName,
  ) async {
    final response = await _client.get(
      Uri.parse(
        '$_baseUrl/v1/admin/apps/$appId/versions/$versionName/artifacts',
      ),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch artifacts: ${response.statusCode}');
    }

    final body = json.decode(response.body) as List<dynamic>;
    return body
        .cast<Map<String, dynamic>>()
        .map(StorkAppVersionArtifact.fromJson)
        .toList();
  }

  /// Downloads a single artifact for a specific version and platform.
  Future<List<int>> downloadArtifact(
    int appId,
    String versionName,
    String platform,
  ) async {
    final response = await _client.get(
      Uri.parse(
        '$_baseUrl/v1/admin/apps/$appId/versions/$versionName/artifacts/platforms/$platform/download',
      ),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to download artifact: ${response.statusCode}');
    }

    return response.bodyBytes;
  }

  /// Gets the Itch.io integration data for a specific app.
  Future<StorkItchIOData?> getItchIOData(int appId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/v1/admin/apps/$appId/itchio'),
      headers: _headers,
    );

    if (response.statusCode == 404) {
      return null;
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch Itch.io data: ${response.statusCode}');
    }

    return StorkItchIOData.fromJson(
      json.decode(response.body) as Map<String, dynamic>,
    );
  }

  /// Updates the Itch.io integration data for a specific app.
  Future<StorkItchIOData> updateItchIOData({
    required int appId,
    required String buttlerKey,
    required String itchIOUsername,
    required String itchIOGameName,
  }) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/v1/admin/apps/$appId/itchio'),
      headers: {
        ..._headers,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'buttlerKey': buttlerKey,
        'itchIOUsername': itchIOUsername,
        'itchIOGameName': itchIOGameName,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update Itch.io data: ${response.statusCode}');
    }

    return StorkItchIOData.fromJson(
      json.decode(response.body) as Map<String, dynamic>,
    );
  }

  /// Lists all news, paginated, from an app
  Future<List<StorkAppNews>> listNews({
    required int appId,
    required int page,
    required int perPage,
  }) async {
    final response = await _client.get(
      Uri.parse(
          '$_baseUrl/v1/admin/apps/$appId/news?page=$page&perPage=$perPage'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to list news: ${response.statusCode}');
    }

    return (json.decode(response.body) as List)
        .map((e) => StorkAppNews.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get a single news from an app
  Future<StorkAppNews> getNews({
    required int appId,
    required int newsId,
  }) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/v1/admin/apps/$appId/news/$newsId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get news: ${response.statusCode}');
    }

    return StorkAppNews.fromJson(
      json.decode(response.body) as Map<String, dynamic>,
    );
  }

  /// Creates a new news
  Future<StorkAppNews> createNews({
    required int appId,
    required String title,
    required String content,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/v1/admin/apps/$appId/news'),
      headers: {
        ..._headers,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'title': title,
        'content': content,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create news: ${response.statusCode}');
    }

    return StorkAppNews.fromJson(
      json.decode(response.body) as Map<String, dynamic>,
    );
  }

  /// Updates an existing news
  Future<StorkAppNews> updateNews({
    required int appId,
    required int newsId,
    required String title,
    required String content,
  }) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/v1/admin/apps/$appId/news/$newsId'),
      headers: {
        ..._headers,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'title': title,
        'content': content,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update news: ${response.statusCode}');
    }

    return StorkAppNews.fromJson(
      json.decode(response.body) as Map<String, dynamic>,
    );
  }

  /// Closes the client and cleans up resources.
  void dispose() => _client.close();
}

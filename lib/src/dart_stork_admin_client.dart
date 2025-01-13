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
  Future<StorkAppVersion> getVersion(int appId, int versionId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/v1/admin/apps/$appId/versions/$versionId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch version: ${response.statusCode}');
    }

    return StorkAppVersion.fromJson(
      json.decode(response.body) as Map<String, dynamic>,
    );
  }

  /// Gets all artifacts for a specific version.
  Future<List<StorkAppVersionArtifact>> getArtifacts(
    int appId,
    int versionId,
  ) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/v1/admin/apps/$appId/versions/$versionId/artifacts'),
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

  /// Closes the client and cleans up resources.
  void dispose() => _client.close();
}

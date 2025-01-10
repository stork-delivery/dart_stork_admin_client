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

    final data = json.decode(response.body) as List<dynamic>;
    return data
        .map((json) => StorkApp.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Closes the client and cleans up resources.
  void dispose() => _client.close();
}

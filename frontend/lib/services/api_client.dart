import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../core/api_exception.dart';
import '../core/app_config.dart';
import 'auth_token_store.dart';

/// Cliente HTTP singleton para a API Spring Boot.
class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  String? _bearer;

  void setBearerToken(String? token) {
    _bearer = (token == null || token.isEmpty) ? null : token;
  }

  /// Carrega JWT salvo (admin) antes das primeiras requisições.
  Future<void> init() async {
    final t = await AuthTokenStore.read();
    _bearer = t;
  }

  Uri _uri(String path, [Map<String, String>? query]) {
    final base = AppConfig.apiBaseUrl;
    final p = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$base$p').replace(queryParameters: query);
  }

  Map<String, String> _headers({required bool auth}) {
    return {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      if (auth && _bearer != null && _bearer!.isNotEmpty)
        HttpHeaders.authorizationHeader: 'Bearer $_bearer',
    };
  }

  void _throwIfError(http.Response r) {
    if (r.statusCode >= 200 && r.statusCode < 300) return;
    var msg = 'Erro HTTP ${r.statusCode}';
    final body = r.body;
    if (body.isNotEmpty) {
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map && decoded['erro'] != null) {
          msg = decoded['erro'].toString();
        }
      } catch (_) {}
    }
    throw ApiException(msg, r.statusCode);
  }

  Future<http.Response> get(
    String path, {
    bool auth = true,
    Map<String, String>? query,
  }) async {
    final r = await http.get(_uri(path, query), headers: _headers(auth: auth));
    _throwIfError(r);
    return r;
  }

  Future<http.Response> post(
    String path, {
    required String body,
    bool auth = true,
  }) async {
    final r = await http.post(
      _uri(path),
      headers: _headers(auth: auth),
      body: body,
    );
    _throwIfError(r);
    return r;
  }

  Future<http.Response> put(
    String path, {
    required String body,
    bool auth = true,
  }) async {
    final r = await http.put(
      _uri(path),
      headers: _headers(auth: auth),
      body: body,
    );
    _throwIfError(r);
    return r;
  }

  Future<void> delete(String path, {bool auth = true}) async {
    final r = await http.delete(_uri(path), headers: _headers(auth: auth));
    _throwIfError(r);
  }
}

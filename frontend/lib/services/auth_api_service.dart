import 'dart:convert';

import 'api_client.dart';
import 'auth_token_store.dart';

/// Login administrativo (`POST /auth/login`).
class AuthApiService {
  AuthApiService(this._client);

  final ApiClient _client;

  Future<LoginResult> login({required String usuario, required String senha}) async {
    final res = await _client.post(
      '/auth/login',
      body: jsonEncode({'usuario': usuario, 'senha': senha}),
      auth: false,
    );
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final token = map['token'] as String;
    await AuthTokenStore.write(token);
    _client.setBearerToken(token);
    return LoginResult(
      token: token,
      nome: map['nome'] as String? ?? usuario,
    );
  }

  Future<void> logout() async {
    await AuthTokenStore.clear();
    _client.setBearerToken(null);
  }

  /// Carrega token salvo e configura o cliente HTTP.
  Future<void> restoreSession() async {
    final t = await AuthTokenStore.read();
    _client.setBearerToken(t);
  }
}

class LoginResult {
  const LoginResult({required this.token, required this.nome});

  final String token;
  final String nome;
}

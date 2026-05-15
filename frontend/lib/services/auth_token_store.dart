import 'package:shared_preferences/shared_preferences.dart';

/// Persiste o JWT do admin entre sessões do app.
class AuthTokenStore {
  AuthTokenStore._();

  static const _key = 'qbonita_jwt';

  static Future<String?> read() async {
    final p = await SharedPreferences.getInstance();
    final v = p.getString(_key);
    if (v == null || v.isEmpty) return null;
    return v;
  }

  static Future<void> write(String token) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_key, token);
  }

  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_key);
  }
}

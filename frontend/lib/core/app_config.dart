// core/app_config.dart
import 'dart:io' show Platform;

/// Configurações globais da loja e da API.
///
/// - [whatsappE164]: apenas dígitos (DDI + DDD + número).
/// - [apiBaseUrlOverride]: deixe vazio para usar o padrão por plataforma.
///   Em aparelho físico Android, use `--dart-define=API_BASE_URL=http://SEU_IP:8080`
///   ou altere temporariamente aqui.
class AppConfig {
  AppConfig._();

  static const String whatsappE164 = '5511999999999';

  static const String lojaTagline =
      'Papelaria, presentes e variedades para deixar seu dia mais bonito.';

  /// Definido em tempo de compilação: `--dart-define=API_BASE_URL=http://10.0.2.2:8080`
  static const String apiBaseUrlOverride =
      String.fromEnvironment('API_BASE_URL');

  /// URL base da API (sem barra no final).
  static String get apiBaseUrl {
    if (apiBaseUrlOverride.isNotEmpty) {
      return apiBaseUrlOverride.replaceAll(RegExp(r'/$'), '');
    }
    if (Platform.isAndroid) {
      // Emulador Android → host da máquina
      // return 'http://10.0.2.2:8080';
      return 'http://192.168.1.23:8080';
    }
    return 'http://localhost:8080';
  }
}

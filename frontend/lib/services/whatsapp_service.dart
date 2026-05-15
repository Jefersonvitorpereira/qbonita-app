import 'package:url_launcher/url_launcher.dart';

import '../core/app_config.dart';

/// Abre o WhatsApp com mensagem de interesse no produto.
class WhatsappService {
  WhatsappService._();

  static Future<bool> abrirInteresseProduto({
    required String nomeProduto,
    required double valor,
  }) async {
    final valorStr = valor.toStringAsFixed(2).replaceAll('.', ',');
    final texto =
        'Olá, tenho interesse no produto: $nomeProduto, no valor de R\$ $valorStr. Ainda está disponível?';
    final uri = Uri.parse(
      'https://wa.me/${AppConfig.whatsappE164}?text=${Uri.encodeComponent(texto)}',
    );
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  /// Contato genérico (tela Atendimento).
  static Future<bool> abrirAtendimento() async {
    final texto = Uri.encodeComponent(
      'Olá, vim pelo app QBonita e gostaria de tirar uma dúvida.',
    );
    final uri = Uri.parse(
      'https://wa.me/${AppConfig.whatsappE164}?text=$texto',
    );
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

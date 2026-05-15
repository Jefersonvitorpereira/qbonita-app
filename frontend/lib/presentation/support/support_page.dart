import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../services/whatsapp_service.dart';

/// Atendimento via WhatsApp.
class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pageBackground,
      appBar: AppBar(title: const Text('Atendimento')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Fale com a QBonita',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tire dúvidas sobre produtos, prazos e disponibilidade pelo WhatsApp.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.45,
                  ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final ok = await WhatsappService.abrirAtendimento();
                if (!context.mounted) return;
                if (!ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Não foi possível abrir o WhatsApp.'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.chat_rounded),
              label: const Text('Chamar no WhatsApp'),
            ),
          ],
        ),
      ),
    );
  }
}

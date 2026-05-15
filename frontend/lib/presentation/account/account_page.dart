import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../admin/admin_login_page.dart';

/// Conta do usuário + acesso discreto à área administrativa (estudo).
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pageBackground,
      appBar: AppBar(title: const Text('Conta')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Olá!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Esta área pode evoluir para login de cliente.\n'
            'Por enquanto, use o catálogo e o WhatsApp para compras.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.45,
                ),
          ),
          const SizedBox(height: 32),
          Text(
            'Administração',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.4,
                ),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(
              'Área administrativa',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text(
              'Cadastro de produtos (API + login JWT)',
              style: TextStyle(fontSize: 12),
            ),
            trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const AdminLoginPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Placeholder do carrinho / lista de interesse (evolução futura).
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pageBackground,
      appBar: AppBar(title: const Text('Carrinho')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No MVP os produtos são consultados no catálogo.\n'
            'Aqui você poderá guardar itens de interesse quando evoluir o app.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.45,
                ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/api_exception.dart';
import '../../core/app_config.dart';
import '../../core/app_dependencies.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/produto.dart';
import '../../services/whatsapp_service.dart';

/// Detalhes do produto + WhatsApp (API).
class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.produtoId});

  final int produtoId;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late Future<Produto> _future;

  @override
  void initState() {
    super.initState();
    _future = AppDependencies.catalog.buscarProduto(widget.produtoId);
  }

  void _recarregar() {
    setState(() {
      _future = AppDependencies.catalog.buscarProduto(widget.produtoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pageBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Detalhes', style: TextStyle(fontSize: 16)),
      ),
      body: FutureBuilder<Produto>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            final msg = snap.error is ApiException
                ? (snap.error as ApiException).message
                : 'Produto não encontrado ou API indisponível (${AppConfig.apiBaseUrl}).';
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(msg, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton(onPressed: _recarregar, child: const Text('Tentar novamente')),
                  ],
                ),
              ),
            );
          }
          final p = snap.data!;
          final imagens = <String>[
            p.imagemPrincipal,
            if (p.imagemSecundaria != null && p.imagemSecundaria!.isNotEmpty)
              p.imagemSecundaria!,
          ];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 280,
                  child: PageView.builder(
                    itemCount: imagens.length,
                    itemBuilder: (context, i) {
                      return Image.network(
                        imagens[i],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppTheme.surfaceTint,
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported_outlined, size: 48),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.nome,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatarReal(p.valor),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppTheme.primaryPink,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.label_outline_rounded,
                              size: 18, color: Colors.grey.shade600),
                          const SizedBox(width: 6),
                          Text(
                            p.categoriaNome ?? 'Categoria',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Descrição',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        p.descricao,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.45,
                              color: const Color(0xFF4B5563),
                            ),
                      ),
                      const SizedBox(height: 28),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          final ok = await WhatsappService.abrirInteresseProduto(
                            nomeProduto: p.nome,
                            valor: p.valor,
                          );
                          if (!context.mounted) return;
                          if (!ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Não foi possível abrir o WhatsApp. Verifique o app instalado.',
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.chat_rounded),
                        label: const Text('Tenho interesse'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

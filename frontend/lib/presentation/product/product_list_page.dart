import 'package:flutter/material.dart';

import '../../core/api_exception.dart';
import '../../core/app_config.dart';
import '../../core/app_dependencies.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/produto.dart';
import '../../widgets/product_card.dart';
import '../search/search_results_page.dart';
import 'product_details_page.dart';

/// Produtos filtrados por categoria (API).
class ProductListPage extends StatefulWidget {
  const ProductListPage({
    super.key,
    required this.categoriaId,
    required this.titulo,
  });

  final int categoriaId;
  final String titulo;

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<Produto>> _future;

  @override
  void initState() {
    super.initState();
    _future = AppDependencies.catalog.listarPorCategoria(widget.categoriaId);
  }

  void _recarregar() {
    setState(() {
      _future = AppDependencies.catalog.listarPorCategoria(widget.categoriaId);
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
        title: Text(
          widget.titulo,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        actions: [
          IconButton(
            tooltip: 'Pesquisar',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const SearchResultsPage(initialQuery: ''),
                ),
              );
            },
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: FutureBuilder<List<Produto>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            final msg = snap.error is ApiException
                ? (snap.error as ApiException).message
                : 'Erro ao carregar produtos. API em ${AppConfig.apiBaseUrl}?';
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
          final produtos = snap.data ?? [];
          if (produtos.isEmpty) {
            return const Center(child: Text('Nenhum produto nesta categoria.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.62,
            ),
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              final p = produtos[index];
              return ProductCard(
                produto: p,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ProductDetailsPage(produtoId: p.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/api_exception.dart';
import '../../core/app_config.dart';
import '../../core/app_dependencies.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/produto.dart';
import '../../widgets/product_card.dart';
import '../product/product_details_page.dart';

/// Pesquisa por nome (API).
class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key, required this.initialQuery});

  final String initialQuery;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late final TextEditingController _controller;
  late Future<List<Produto>> _future;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _future = AppDependencies.catalog.buscarPorNome(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _executarBusca() {
    setState(() {
      _future = AppDependencies.catalog.buscarPorNome(_controller.text);
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
        title: TextField(
          controller: _controller,
          autofocus: widget.initialQuery.isEmpty,
          decoration: const InputDecoration(
            hintText: 'Buscar produtos…',
            border: InputBorder.none,
            isDense: true,
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _executarBusca(),
        ),
        actions: [
          IconButton(
            onPressed: _executarBusca,
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
                : 'Erro na busca. API em ${AppConfig.apiBaseUrl}?';
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(msg, textAlign: TextAlign.center),
              ),
            );
          }
          final resultados = snap.data ?? [];
          if (_controller.text.trim().isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Digite na barra acima para buscar por nome (ex.: caneca).',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ),
            );
          }
          if (resultados.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Nenhum produto encontrado para "${_controller.text.trim()}".',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.62,
            ),
            itemCount: resultados.length,
            itemBuilder: (context, index) {
              final p = resultados[index];
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

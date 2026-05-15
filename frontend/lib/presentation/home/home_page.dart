import 'package:flutter/material.dart';

import '../../core/api_exception.dart';
import '../../core/app_config.dart';
import '../../core/app_dependencies.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/produto.dart';
import '../../widgets/product_card.dart';
import '../../widgets/qbonita_logo.dart';
import '../product/product_details_page.dart';
import '../search/search_results_page.dart';

/// Tela inicial: apresentação da loja e vitrine de produtos em destaque (API).
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Produto>> _future;

  @override
  void initState() {
    super.initState();
    _future = AppDependencies.catalog.listarDestaques();
  }

  void _recarregar() {
    setState(() {
      _future = AppDependencies.catalog.listarDestaques();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pageBackground,
      appBar: AppBar(
        title: const QBonitaLogo(compact: true),
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
            return _ErroApi(
              erro: snap.error,
              onRetry: _recarregar,
            );
          }
          final destaques = snap.data ?? [];
          if (destaques.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Nenhum produto em destaque no momento.'),
              ),
            );
          }
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConfig.lojaTagline,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textSecondary,
                              height: 1.45,
                            ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Em destaque',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.62,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final p = destaques[index];
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
                    childCount: destaques.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }
}

class _ErroApi extends StatelessWidget {
  const _ErroApi({required this.erro, required this.onRetry});

  final Object? erro;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final msg = erro is ApiException
        ? (erro as ApiException).message
        : 'Não foi possível carregar os dados. Verifique se a API está rodando em ${AppConfig.apiBaseUrl}';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(msg, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

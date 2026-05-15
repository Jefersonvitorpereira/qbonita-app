import 'package:flutter/material.dart';

import '../../core/api_exception.dart';
import '../../core/app_config.dart';
import '../../core/app_dependencies.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/categoria.dart';
import '../../widgets/qbonita_logo.dart';
import '../product/product_list_page.dart';
import '../search/search_results_page.dart';

/// Lista de categorias (API).
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Future<List<Categoria>> _future;

  @override
  void initState() {
    super.initState();
    _future = AppDependencies.catalog.listarCategoriasLoja();
  }

  void _recarregar() {
    setState(() {
      _future = AppDependencies.catalog.listarCategoriasLoja();
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
      body: FutureBuilder<List<Categoria>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            final msg = snap.error is ApiException
                ? (snap.error as ApiException).message
                : 'Erro ao carregar categorias. API em ${AppConfig.apiBaseUrl}?';
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
          final categorias = snap.data ?? [];
          return ListView.separated(
            itemCount: categorias.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 20),
            itemBuilder: (context, index) {
              final c = categorias[index];
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                title: Text(
                  c.nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ProductListPage(
                        categoriaId: c.id,
                        titulo: c.nome,
                      ),
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

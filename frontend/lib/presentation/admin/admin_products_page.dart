// presentation/admin/admin_products_page.dart
import 'package:flutter/material.dart';

import '../../core/api_exception.dart';
import '../../core/app_config.dart';
import '../../core/app_dependencies.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/produto.dart';
import 'product_form_page.dart';

/// Lista produtos via API (admin autenticado).
class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({super.key});

  @override
  State<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  late Future<List<Produto>> _future;

  @override
  void initState() {
    super.initState();
    _future = AppDependencies.catalog.listarTodosAdmin();
  }

  void _recarregar() {
    setState(() {
      _future = AppDependencies.catalog.listarTodosAdmin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Produtos (admin)'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push<bool>(
            MaterialPageRoute<bool>(
              builder: (_) => const ProductFormPage(),
            ),
          );
          _recarregar();
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Novo'),
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
                : 'Erro ao listar. Token válido? API em ${AppConfig.apiBaseUrl}?';
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(msg, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton(
                        onPressed: _recarregar,
                        child: const Text('Tentar novamente')),
                  ],
                ),
              ),
            );
          }
          final produtos = snap.data ?? [];
          return RefreshIndicator(
            onRefresh: () async {
              final f = AppDependencies.catalog.listarTodosAdmin();
              setState(() => _future = f);
              await f;
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: produtos.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final p = produtos[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Image.network(
                        p.imagemPrincipal,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const ColoredBox(color: Color(0xFFF3F4F6)),
                      ),
                    ),
                  ),
                  title: Text(p.nome,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(
                    '${p.categoriaNome ?? 'Categoria'} · ${formatarReal(p.valor)}${p.ativo ? '' : ' (inativo)'}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Icon(Icons.chevron_right_rounded,
                      color: Colors.grey.shade400),
                  onTap: () async {
                    await Navigator.of(context).push<bool>(
                      MaterialPageRoute<bool>(
                        builder: (_) => ProductFormPage(produtoId: p.id),
                      ),
                    );
                    _recarregar();
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

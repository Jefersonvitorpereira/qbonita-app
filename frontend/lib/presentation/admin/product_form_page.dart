import 'package:flutter/material.dart';

import '../../core/api_exception.dart';
import '../../core/app_dependencies.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/categoria.dart';

/// Cadastro / edição de produto via API.
class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key, this.produtoId});

  final int? produtoId;

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _nome = TextEditingController();
  final _descricao = TextEditingController();
  final _valor = TextEditingController();
  final _img1 = TextEditingController();
  final _img2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Categoria> _categorias = [];
  int? _categoriaId;
  bool _ativo = true;
  bool _destaque = false;
  bool _loading = true;
  bool _salvando = false;

  bool get _isNovo => widget.produtoId == null;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _loading = true);
    try {
      final cats = await AppDependencies.catalog.listarCategoriasAdmin();
      _categorias = cats;
      if (widget.produtoId != null) {
        final p = await AppDependencies.catalog.buscarProduto(
          widget.produtoId!,
          admin: true,
        );
        _nome.text = p.nome;
        _descricao.text = p.descricao;
        _valor.text = p.valor.toStringAsFixed(2);
        _img1.text = p.imagemPrincipal;
        _img2.text = p.imagemSecundaria ?? '';
        _categoriaId = p.categoriaId;
        _ativo = p.ativo;
        _destaque = p.destaque;
      }
      _categoriaId ??= _categorias.isNotEmpty ? _categorias.first.id : null;
    } catch (e) {
      if (mounted) {
        final msg = e is ApiException ? e.message : e.toString();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nome.dispose();
    _descricao.dispose();
    _valor.dispose();
    _img1.dispose();
    _img2.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categoriaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma categoria.')),
      );
      return;
    }
    final valor = double.tryParse(_valor.text.replaceAll(',', '.'));
    if (valor == null) return;

    setState(() => _salvando = true);
    try {
      final sec = _img2.text.trim().isEmpty ? null : _img2.text.trim();
      if (_isNovo) {
        await AppDependencies.catalog.criarProduto(
          nome: _nome.text.trim(),
          descricao: _descricao.text.trim(),
          valor: valor,
          categoriaId: _categoriaId!,
          imagemPrincipal: _img1.text.trim(),
          imagemSecundaria: sec,
          ativo: _ativo,
          destaque: _destaque,
        );
      } else {
        await AppDependencies.catalog.atualizarProduto(
          widget.produtoId!,
          nome: _nome.text.trim(),
          descricao: _descricao.text.trim(),
          valor: valor,
          categoriaId: _categoriaId!,
          imagemPrincipal: _img1.text.trim(),
          imagemSecundaria: sec,
          ativo: _ativo,
          destaque: _destaque,
        );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto salvo com sucesso.')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      final msg = e is ApiException ? e.message : e.toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Future<void> _excluir() async {
    if (_isNovo) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir produto'),
        content: const Text('Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Excluir')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _salvando = true);
    try {
      await AppDependencies.catalog.excluirProduto(widget.produtoId!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto excluído.')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      final msg = e is ApiException ? e.message : e.toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(_isNovo ? 'Novo produto' : 'Editar produto'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_categorias.isEmpty || _categoriaId == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Produto'),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('Nenhuma categoria disponível. Rode database/init.sql ou cadastre via API.'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(_isNovo ? 'Novo produto' : 'Editar produto'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nome,
              decoration: const InputDecoration(labelText: 'Nome do produto'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descricao,
              decoration: const InputDecoration(
                labelText: 'Descrição breve',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _valor,
              decoration: const InputDecoration(
                labelText: 'Valor (ex.: 19.90)',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Obrigatório';
                final n = double.tryParse(v.replaceAll(',', '.'));
                if (n == null || n < 0) return 'Valor inválido';
                return null;
              },
            ),
            const SizedBox(height: 8),
            Text(
              _valor.text.trim().isEmpty
                  ? ''
                  : 'Prévia: ${formatarReal(double.tryParse(_valor.text.replaceAll(',', '.')) ?? 0)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _categoriaId,
              decoration: const InputDecoration(labelText: 'Categoria'),
              items: _categorias
                  .map(
                    (Categoria c) => DropdownMenuItem(
                      value: c.id,
                      child: Text(c.nome, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _categoriaId = v),
              validator: (v) => v == null ? 'Escolha uma categoria' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _img1,
              decoration: const InputDecoration(
                labelText: 'URL foto principal',
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _img2,
              decoration: const InputDecoration(
                labelText: 'URL segunda foto (opcional)',
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Produto ativo'),
              value: _ativo,
              onChanged: (v) => setState(() => _ativo = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Destaque na home'),
              value: _destaque,
              onChanged: (v) => setState(() => _destaque = v),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _salvando ? null : _salvar,
              child: _salvando
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Salvar'),
            ),
            if (!_isNovo) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _salvando ? null : _excluir,
                child: const Text('Excluir'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

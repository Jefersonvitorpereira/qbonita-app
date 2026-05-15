import 'dart:convert';

import '../domain/categoria.dart';
import '../domain/produto.dart';
import '../services/api_client.dart';

/// Acesso ao catálogo via REST.
class CatalogApiRepository {
  CatalogApiRepository(this._client);

  final ApiClient _client;

  Future<List<Categoria>> listarCategoriasLoja() async {
    final r = await _client.get('/categorias', auth: false);
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => Categoria.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Com JWT admin, retorna também categorias inativas.
  Future<List<Categoria>> listarCategoriasAdmin() async {
    final r = await _client.get('/categorias', auth: true);
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => Categoria.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Produto>> listarDestaques() async {
    final r = await _client.get('/produtos/destaques', auth: false);
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => Produto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Produto>> listarPorCategoria(int categoriaId) async {
    final r = await _client.get('/produtos/categoria/$categoriaId', auth: false);
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => Produto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Produto>> buscarPorNome(String nome) async {
    final q = nome.trim();
    if (q.isEmpty) return [];
    final r = await _client.get(
      '/produtos/buscar',
      auth: false,
      query: {'nome': q},
    );
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => Produto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Produto> buscarProduto(int id, {bool admin = false}) async {
    final r = await _client.get('/produtos/$id', auth: admin);
    final map = jsonDecode(r.body) as Map<String, dynamic>;
    return Produto.fromJson(map);
  }

  Future<List<Produto>> listarTodosAdmin() async {
    final r = await _client.get('/produtos', auth: true);
    final list = jsonDecode(r.body) as List<dynamic>;
    return list.map((e) => Produto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Produto> criarProduto({
    required String nome,
    required String descricao,
    required double valor,
    required int categoriaId,
    required String imagemPrincipal,
    String? imagemSecundaria,
    required bool ativo,
    required bool destaque,
  }) async {
    final body = jsonEncode({
      'nome': nome,
      'descricao': descricao,
      'valor': valor,
      'categoriaId': categoriaId,
      'imagemPrincipal': imagemPrincipal,
      'imagemSecundaria': imagemSecundaria,
      'ativo': ativo,
      'destaque': destaque,
    });
    final r = await _client.post('/produtos', body: body, auth: true);
    final map = jsonDecode(r.body) as Map<String, dynamic>;
    return Produto.fromJson(map);
  }

  Future<Produto> atualizarProduto(
    int id, {
    required String nome,
    required String descricao,
    required double valor,
    required int categoriaId,
    required String imagemPrincipal,
    String? imagemSecundaria,
    required bool ativo,
    required bool destaque,
  }) async {
    final body = jsonEncode({
      'nome': nome,
      'descricao': descricao,
      'valor': valor,
      'categoriaId': categoriaId,
      'imagemPrincipal': imagemPrincipal,
      'imagemSecundaria': imagemSecundaria,
      'ativo': ativo,
      'destaque': destaque,
    });
    final r = await _client.put('/produtos/$id', body: body, auth: true);
    final map = jsonDecode(r.body) as Map<String, dynamic>;
    return Produto.fromJson(map);
  }

  Future<void> excluirProduto(int id) async {
    await _client.delete('/produtos/$id', auth: true);
  }
}

/// Produto vindo da API (`/produtos`).
class Produto {
  const Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.valor,
    required this.categoriaId,
    required this.imagemPrincipal,
    this.imagemSecundaria,
    this.ativo = true,
    this.destaque = false,
    this.categoriaNome,
  });

  final int id;
  final String nome;
  final String descricao;
  final double valor;
  final int categoriaId;
  final String imagemPrincipal;
  final String? imagemSecundaria;
  final bool ativo;
  final bool destaque;

  /// Preenchido quando a API envia `categoria` embutida (exibição em cards).
  final String? categoriaNome;

  factory Produto.fromJson(Map<String, dynamic> json) {
    final cat = json['categoria'] as Map<String, dynamic>?;
    final cid = cat != null
        ? (cat['id'] as num).toInt()
        : (json['categoriaId'] as num).toInt();
    return Produto(
      id: (json['id'] as num).toInt(),
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      valor: (json['valor'] as num).toDouble(),
      categoriaId: cid,
      imagemPrincipal: json['imagemPrincipal'] as String,
      imagemSecundaria: json['imagemSecundaria'] as String?,
      ativo: json['ativo'] as bool? ?? true,
      destaque: json['destaque'] as bool? ?? false,
      categoriaNome: cat?['nome'] as String?,
    );
  }
}

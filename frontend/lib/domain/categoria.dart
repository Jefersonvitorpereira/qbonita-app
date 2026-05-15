/// Categoria vinda da API (`/categorias`).
class Categoria {
  const Categoria({
    required this.id,
    required this.nome,
    this.ativo = true,
  });

  final int id;
  final String nome;
  final bool ativo;

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: (json['id'] as num).toInt(),
      nome: json['nome'] as String,
      ativo: json['ativo'] as bool? ?? true,
    );
  }
}

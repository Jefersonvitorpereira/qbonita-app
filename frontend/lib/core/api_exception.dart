/// Erro retornado pela API (`{ "erro": "..." }`) ou falha de rede.
class ApiException implements Exception {
  ApiException(this.message, [this.statusCode]);

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

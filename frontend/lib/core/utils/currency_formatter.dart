import 'package:intl/intl.dart';

/// Formata valores em Real (pt-BR).
String formatarReal(double valor) {
  return NumberFormat.currency(
    locale: 'pt_BR',
    symbol: r'R$',
    decimalDigits: 2,
  ).format(valor);
}

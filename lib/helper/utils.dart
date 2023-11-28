import 'package:intl/intl.dart';

class Utils {
  static String formatPrice(int price) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
      customPattern: '\u00A4 #,###',
    );
    return formatter.format(price);
  }

  static String formatDate(int price) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
      customPattern: '\u00A4 #,###',
    );
    return formatter.format(price);
  }
}

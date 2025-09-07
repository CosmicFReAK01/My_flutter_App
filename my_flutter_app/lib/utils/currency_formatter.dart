class CurrencyFormatter {
  static String format(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  static String formatWithSymbol(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }
}

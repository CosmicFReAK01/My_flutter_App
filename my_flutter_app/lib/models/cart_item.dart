class CartItem {
  final String id;
  final String serviceId;
  final String serviceName;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.quantity,
    required this.price,
  });

  double get totalPrice => quantity * price;
}

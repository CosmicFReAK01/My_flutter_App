import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../models/address.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class AppProvider extends ChangeNotifier {
  Profile? _currentProfile;
  List<Address> _addresses = [];
  final List<CartItem> _cartItems = [];
  List<Order> _orders = [];

  Profile? get currentProfile => _currentProfile;
  List<Address> get addresses => _addresses;
  List<CartItem> get cartItems => _cartItems;
  List<Order> get orders => _orders;


  void initializeCustomerData() {
    _currentProfile = Profile(
      userId: "customer_1",
      name: "John Doe",
      email: "john.doe@example.com",
      userType: UserType.customer,
      phone: "+1234567890",
    );

    _addresses = [
      Address(
        id: "1",
        street: "123 Main St",
        city: "Anytown",
        state: "CA",
        zipCode: "12345",
        label: "Home",
      ),
    ];
    notifyListeners();
  }

  void initializeConsumerData() {
    _currentProfile = Profile(
      userId: "consumer_1",
      name: "Clean & Fresh Laundry",
      email: "contact@cleanfresh.com",
      userType: UserType.consumer,
      phone: "+1234567890",
      businessName: "Clean & Fresh Laundry",
      businessDescription: "Professional laundry and dry cleaning services",
      serviceCategories: ["Washing", "Dry Cleaning", "Ironing"],
    );

    _addresses = [
      Address(
        id: "1",
        street: "789 Business Ave",
        city: "Anytown",
        state: "CA",
        zipCode: "12345",
        label: "Main Shop",
        isShopAddress: true,
        shopName: "Clean & Fresh Laundry",
        operatingHours: "Mon-Sat: 8AM-8PM, Sun: 10AM-6PM",
      ),
    ];
    notifyListeners();
  }

  void setProfile(Profile profile) {
    _currentProfile = profile;
    notifyListeners();
  }

  void setAddresses(List<Address> addresses) {
    _addresses = addresses;
    notifyListeners();
  }

  void addToCart(CartItem item) {
    // Check if item already exists in cart
    final index = _cartItems.indexWhere((cartItem) => cartItem.serviceId == item.serviceId);
    if (index != -1) {
      // Update quantity
      _cartItems[index] = CartItem(
        id: _cartItems[index].id,
        serviceId: _cartItems[index].serviceId,
        serviceName: _cartItems[index].serviceName,
        quantity: _cartItems[index].quantity + item.quantity,
        price: _cartItems[index].price,
      );
    } else {
      _cartItems.add(item);
    }
    notifyListeners();
  }

  void removeFromCart(String serviceId) {
    _cartItems.removeWhere((item) => item.serviceId == serviceId);
    notifyListeners();
  }

  void updateCartItemQuantity(String serviceId, int newQuantity) {
    final index = _cartItems.indexWhere((item) => item.serviceId == serviceId);
    if (index != -1) {
      _cartItems[index] = CartItem(
        id: _cartItems[index].id,
        serviceId: _cartItems[index].serviceId,
        serviceName: _cartItems[index].serviceName,
        quantity: newQuantity,
        price: _cartItems[index].price,
      );
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void setOrders(List<Order> orders) {
    _orders = orders;
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      final order = _orders[index];
      _orders[index] = Order(
        id: order.id,
        userId: order.userId,
        customerName: order.customerName,
        customerPhone: order.customerPhone,
        deliveryAddress: order.deliveryAddress,
        orderDate: order.orderDate,
        pickupDate: order.pickupDate,
        deliveryDate: order.deliveryDate,
        totalAmount: order.totalAmount,
        status: newStatus,
        items: order.items,
      );
      notifyListeners();
    }
  }

  void initializeDemoOrders() {
    _orders = [
      Order(
        id: "ORD001",
        userId: "customer_1",
        customerName: "Alice Johnson",
        customerPhone: "+1234567890",
        deliveryAddress: "123 Main St, Anytown, CA 12345",
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        pickupDate: DateTime.now().subtract(const Duration(days: 1)),
        deliveryDate: DateTime.now().add(const Duration(days: 1)),
        totalAmount: 150.0,
        status: "Pending",
        items: [
          OrderItem(
            id: "item1",
            serviceId: "wash_fold",
            serviceName: "Wash & Fold",
            quantity: 2,
            price: 50.0,
          ),
          OrderItem(
            id: "item2",
            serviceId: "dry_clean",
            serviceName: "Dry Cleaning",
            quantity: 1,
            price: 50.0,
          ),
        ],
      ),
      Order(
        id: "ORD002",
        userId: "customer_2",
        customerName: "Bob Smith",
        customerPhone: "+1987654321",
        deliveryAddress: "456 Oak Ave, Anytown, CA 12345",
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        pickupDate: DateTime.now(),
        deliveryDate: DateTime.now().add(const Duration(days: 2)),
        totalAmount: 75.0,
        status: "In Progress",
        items: [
          OrderItem(
            id: "item3",
            serviceId: "iron",
            serviceName: "Ironing",
            quantity: 3,
            price: 25.0,
          ),
        ],
      ),
    ];
    notifyListeners();
  }

  // Additional methods for updating profile, addresses, etc. can be added as needed
}

import 'package:flutter/material.dart';
import '../../widgets/notifications_drawer.dart';
import '../../services/cart_manager.dart';
import '../../services/order_manager.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late CartManager _cartManager;

  @override
  void initState() {
    super.initState();
    _cartManager = CartManager();
    _cartManager.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cartManager.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    setState(() {});
  }

  void _removeItem(int index) {
    _cartManager.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const NotificationsEndDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/laundry_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar with back button
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Booking Cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Builder(
                      builder: (drawerContext) => IconButton(
                        icon: const Icon(Icons.notifications, color: Colors.white),
                        onPressed: () {
                          Scaffold.of(drawerContext).openEndDrawer();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: _cartManager.items.isEmpty
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.shopping_cart_outlined,
                                      color: Colors.white70,
                                      size: 64,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Your cart is empty',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Add items from popular consumers',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: _cartManager.items.length,
                                itemBuilder: (context, index) {
                                  final item = _cartManager.items[index];
                                  return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xB29A9898),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(
                                    0xFFFFFFFF)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: const Color(0xA1514F4F),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFFFFFFFF))
                                    ),
                                    child: const Icon(
                                      Icons.local_laundry_service,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['title'] ?? 'Service',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['provider'] ?? 'Provider',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['price'] ?? '₹0',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _removeItem(index);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      if (_cartManager.items.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xB29A9898),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFFFFFFF)),
                          ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Total: ₹${_cartManager.calculateTotal().toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                                                  // Create order from cart items
                                  final orderManager = OrderManager();
                                  orderManager.createOrder(
                                    items: List<Map<String, dynamic>>.from(_cartManager.items),
                                    total: _cartManager.calculateTotal(),
                                    status: 'Pending',
                                  );
                                  
                                  // Clear cart after order creation
                                  _cartManager.clear();
                                
                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Order placed successfully!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                
                                // Navigate to orders page
                                Navigator.pushReplacementNamed(context, '/orders');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2A62FF),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Checkout'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

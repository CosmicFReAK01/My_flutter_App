import 'package:flutter/material.dart';
import '../../widgets/notifications_drawer.dart';
import '../../services/order_manager.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late OrderManager _orderManager;

  @override
  void initState() {
    super.initState();
    _orderManager = OrderManager();
    _orderManager.addListener(_onOrdersChanged);
  }

  @override
  void dispose() {
    _orderManager.removeListener(_onOrdersChanged);
    super.dispose();
  }

  void _onOrdersChanged() {
    setState(() {});
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
                      'My Orders',
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
                  child: _orderManager.getOrders().isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2,
                                color: Colors.white70,
                                size: 64,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No orders yet',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Your orders will appear here',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                                                  : ListView.builder(
                                itemCount: _orderManager.getOrders().length,
                                itemBuilder: (context, index) {
                                  final order = _orderManager.getOrders()[index];
                            final orderNumber = order['orderNumber'] as int;
                            final status = order['status'] as String;
                            final total = order['total'] as double;
                            final items = order['items'] as List<Map<String, dynamic>>;
                            final date = DateTime.parse(order['date'] as String);
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xB29A9898),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFFFFFFF)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
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
                                              'Order #$orderNumber',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Status: $status',
                                              style: TextStyle(
                                                color: status == 'Completed' ? Colors.green : Colors.orange,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '₹${total.toStringAsFixed(0)}',
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${items.length} item${items.length > 1 ? 's' : ''}',
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.visibility, color: Colors.white),
                                        onPressed: () {
                                          _showOrderDetails(context, order);
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Ordered on ${date.day}/${date.month}/${date.year}',
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    final orderNumber = order['orderNumber'] as int;
    final status = order['status'] as String;
    final total = order['total'] as double;
    final items = order['items'] as List<Map<String, dynamic>>;
    final date = DateTime.parse(order['date'] as String);
    final estimatedDelivery = DateTime.parse(order['estimatedDelivery'] as String);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C3E50),
          title: Text(
            'Order #$orderNumber',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status: $status',
                  style: TextStyle(
                    color: status == 'Completed' ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Order Date: ${date.day}/${date.month}/${date.year}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  'Estimated Delivery: ${estimatedDelivery.day}/${estimatedDelivery.month}/${estimatedDelivery.year}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Items:',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${item['title']} - ${item['provider']}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      Text(
                        item['price'] ?? '₹0',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )).toList(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '₹${total.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

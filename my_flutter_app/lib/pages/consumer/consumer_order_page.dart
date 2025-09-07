import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/order.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ConsumerOrderPage extends StatefulWidget {
  final VoidCallback? onBack;
  const ConsumerOrderPage({Key? key, this.onBack}) : super(key: key);

  @override
  State<ConsumerOrderPage> createState() => _ConsumerOrderPageState();
}

class _ConsumerOrderPageState extends State<ConsumerOrderPage> {
  String searchTerm = '';
  String filterStatus = 'all';

  List<Order> getFilteredOrders(List<Order> orders) {
    return orders.where((order) {
      final matchesSearch = order.customerName.toLowerCase().contains(searchTerm.toLowerCase()) ||
          order.id.toString().contains(searchTerm);
      final matchesStatus = filterStatus == 'all' ||
          order.status.toLowerCase().replaceAll('-', ' ') == filterStatus.toLowerCase();
      return matchesSearch && matchesStatus;
    }).toList();
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'ready':
        return Colors.purple;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final orders = appProvider.orders;
        final filteredOrders = getFilteredOrders(orders);
        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/laundry_background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.4),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: widget.onBack ??
                                  () {
                                Navigator.pushReplacementNamed(context, '/consumer-home');
                              },
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Received Orders',
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Manage and track all your laundry orders.',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (value) => setState(() => searchTerm = value),
                            decoration: const InputDecoration(
                              hintText: 'Search orders by customer name or order ID...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              if (constraints.maxWidth < 600) {
                                return Column(
                                  children: [
                                    DropdownButtonFormField<String>(
                                      value: filterStatus,
                                      decoration: const InputDecoration(
                                        labelText: 'Filter by Status',
                                        border: OutlineInputBorder(),
                                      ),
                                      items: const [
                                        DropdownMenuItem(value: 'all', child: Text('All Status')),
                                        DropdownMenuItem(value: 'pending', child: Text('Pending')),
                                        DropdownMenuItem(value: 'in progress', child: Text('In Progress')),
                                        DropdownMenuItem(value: 'ready', child: Text('Ready')),
                                        DropdownMenuItem(value: 'completed', child: Text('Completed')),
                                        DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                                      ],
                                      onChanged: (value) => setState(() => filterStatus = value!),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (appProvider.orders.isEmpty) {
                                            appProvider.initializeDemoOrders();
                                          }
                                        },
                                        child: const Text('Load Demo Orders'),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        value: filterStatus,
                                        decoration: const InputDecoration(
                                          labelText: 'Filter by Status',
                                          border: OutlineInputBorder(),
                                        ),
                                        items: const [
                                          DropdownMenuItem(value: 'all', child: Text('All Status')),
                                          DropdownMenuItem(value: 'pending', child: Text('Pending')),
                                          DropdownMenuItem(value: 'in progress', child: Text('In Progress')),
                                          DropdownMenuItem(value: 'ready', child: Text('Ready')),
                                          DropdownMenuItem(value: 'completed', child: Text('Completed')),
                                          DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                                        ],
                                        onChanged: (value) => setState(() => filterStatus = value!),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (appProvider.orders.isEmpty) {
                                          appProvider.initializeDemoOrders();
                                        }
                                      },
                                      child: const Text('Load Demo Orders'),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (filteredOrders.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(48),
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.inbox_outlined, size: 64, color: Colors.white70),
                              SizedBox(height: 16),
                              Text(
                                'No orders received',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Customer orders will appear here',
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      AnimationLimiter(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredOrders.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final order = filteredOrders[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 400),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: _buildOrderCard(order, appProvider),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(Order order, AppProvider appProvider) {
    Color statusColor = getStatusColor(order.status);
    int totalItems = order.items.fold(0, (sum, item) => sum + item.quantity);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #${order.id}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    order.customerName,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildOrderDetail(Icons.phone, order.customerPhone),
                    const SizedBox(height: 8),
                    _buildOrderDetail(Icons.location_on, order.deliveryAddress),
                    const SizedBox(height: 8),
                    _buildOrderDetail(Icons.calendar_today,
                        'Created: ${order.orderDate.toString().split(' ')[0]}'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Items:', '$totalItems pieces'),
                    _buildDetailRow('Pickup:', order.pickupDate.toString().split(' ')[0]),
                    _buildDetailRow('Delivery:', order.deliveryDate.toString().split(' ')[0]),
                    const Divider(),
                    _buildDetailRow('Total:', '₹${order.totalAmount.toStringAsFixed(2)}', isTotal: true),
                    const SizedBox(height: 16),
                    if (order.status.toLowerCase() == 'pending')
                    // Vertical button layout for Accept and Reject
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                appProvider.updateOrderStatus(order.id, 'In Progress');
                              },
                              icon: const Icon(Icons.check, size: 16),
                              label: const Text('Accept'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                appProvider.updateOrderStatus(order.id, 'Cancelled');
                              },
                              icon: const Icon(Icons.close, size: 16),
                              label: const Text('Reject'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    else if (order.status.toLowerCase() == 'in progress')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            appProvider.updateOrderStatus(order.id, 'Completed');
                          },
                          icon: const Icon(Icons.done_all, size: 16),
                          label: const Text('Mark Complete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement view details
                          },
                          icon: const Icon(Icons.visibility, size: 16),
                          label: const Text('View Details'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[600],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

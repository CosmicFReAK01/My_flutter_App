import 'package:flutter/material.dart';
import '../../services/cart_manager.dart';

class ConsumerPage extends StatefulWidget {
  const ConsumerPage({Key? key}) : super(key: key);

  @override
  State<ConsumerPage> createState() => _ConsumerPageState();
}

class _ConsumerPageState extends State<ConsumerPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = false;
  String _selectedFilter = 'All';

  // Demo consumer data
  final List<Map<String, dynamic>> _consumers = [
    {
      'name': 'FreshClean Laundry',
      'rating': 4.8,
      'distance': '1.2 km',
      'services': ['Wash & Dry', 'Ironing', 'Express Service'],
      'assetImage': 'assets/images/shop 1.jpg',
      'price': '₹199',
      'deliveryTime': '24 hours',
    },
    {
      'name': 'Premium Wash Hub',
      'rating': 4.9,
      'distance': '2.5 km',
      'services': ['Dry Clean Only', 'Premium Service', 'Stain Removal'],
      'assetImage': 'assets/images/shop 2.jpg',
      'price': '₹299',
      'deliveryTime': '48 hours',
    },
    {
      'name': 'Quick Iron Masters',
      'rating': 4.5,
      'distance': '0.8 km',
      'services': ['Ironing Only', 'Express Service'],
      'assetImage': 'assets/images/shop 3.jpg',
      'price': '₹149',
      'deliveryTime': '12 hours',
    },
    {
      'name': 'Eco Dry Cleaners',
      'rating': 4.7,
      'distance': '3.1 km',
      'services': ['Dry Clean Only', 'Eco-Friendly', 'Premium Service'],
      'assetImage': 'assets/images/shop 4.jpg',
      'price': '₹349',
      'deliveryTime': '36 hours',
    },
    {
      'name': 'Wash & Fold Express',
      'rating': 4.6,
      'distance': '1.7 km',
      'services': ['Wash & Dry', 'Folding', 'Express Service'],
      'assetImage': 'assets/images/shop 5.jpg',
      'price': '₹249',
      'deliveryTime': '18 hours',
    },
    {
      'name': 'Deluxe Garment Care',
      'rating': 4.9,
      'distance': '2.2 km',
      'services': ['Premium Service', 'Dry Clean Only', 'Special Garments'],
      'assetImage': 'assets/images/shop 6.jpg',
      'price': '₹399',
      'deliveryTime': '48 hours',
    },
  ];

  // Service types for filtering
  final List<String> _serviceTypes = [
    'All',
    'Wash & Dry',
    'Ironing',
    'Dry Clean Only',
    'Premium Service',
    'Express Service'
  ];

  List<Map<String, dynamic>> get _filteredConsumers {
    if (_selectedFilter == 'All') return _consumers;

    return _consumers.where((consumer) {
      return consumer['services'].contains(_selectedFilter);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with a subtle pattern
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black12,
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // App Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Back Button
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      // Title or Search Bar
                      Expanded(
                        child: _isSearchVisible
                            ? TextField(
                          controller: _searchController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Search consumers...',
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _isSearchVisible = false;
                                  _searchController.clear();
                                });
                              },
                            ),
                          ),
                        )
                            : const Text(
                          'Service Providers',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Search and Cart Icons
                      if (!_isSearchVisible) ...[
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              _isSearchVisible = true;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.shopping_cart),
                          onPressed: () {
                            Navigator.pushNamed(context, '/cart' );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                // Service Filter Chips
                SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: _serviceTypes.map((service) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(service),
                          selected: _selectedFilter == service,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = selected ? service : 'All';
                            });
                          },
                          backgroundColor: Colors.white.withOpacity(0.8),
                          selectedColor: Colors.blue.withOpacity(0.8),
                          labelStyle: TextStyle(
                            color: _selectedFilter == service
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Consumer List
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                    child: Column(
                      children: _filteredConsumers.map((consumer) {
                        return ConsumerCard(consumer: consumer);
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ConsumerCard extends StatelessWidget {
  final Map<String, dynamic> consumer;

  const ConsumerCard({Key? key, required this.consumer}) : super(key: key);

  // Helper method to get service icon
  IconData _getServiceIcon(String service) {
    switch (service) {
      case 'Wash & Dry':
        return Icons.local_laundry_service;
      case 'Ironing':
        return Icons.iron;
      case 'Dry Clean Only':
        return Icons.clean_hands;
      case 'Premium Service':
        return Icons.workspace_premium;
      case 'Express Service':
        return Icons.flash_on;
      case 'Stain Removal':
        return Icons.cleaning_services;
      case 'Folding':
        return Icons.view_array;
      case 'Eco-Friendly':
        return Icons.eco;
      case 'Special Garments':
        return Icons.checkroom;
      default:
        return Icons.build;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Consumer Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    consumer['assetImage'] ?? 'assets/images/laundry_background.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF9E9494),
                        child: const Icon(Icons.store, color: Colors.white),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Consumer Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        consumer['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${consumer['rating']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.location_on, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            consumer['distance'],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      consumer['price'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      'Starting price',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Services
            Text(
              'Services Offered:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: consumer['services'].map<Widget>((service) {
                return Chip(
                  label: Text(service),
                  avatar: Icon(_getServiceIcon(service), size: 18),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  labelStyle: const TextStyle(fontSize: 12),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Delivery Time and Action Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Delivery in ${consumer['deliveryTime']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    final cartManager = CartManager();
                    cartManager.addItem(
                      title: 'Booking',
                      providerName: consumer['name'],
                      services: List<String>.from(consumer['services']),
                      price: consumer['price'],
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added ${consumer['name']} to cart')),
                    );
                    Navigator.pushNamed(context, '/cart');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
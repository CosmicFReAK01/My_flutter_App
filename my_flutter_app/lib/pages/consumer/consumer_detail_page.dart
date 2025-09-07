import 'package:flutter/material.dart';
import '../../services/cart_manager.dart';

class ConsumerDetailPage extends StatelessWidget {
  final Map<String, dynamic> consumer;
  final VoidCallback? onBack;

  const ConsumerDetailPage({Key? key, required this.consumer, this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String name = consumer['name'] ?? 'Service Provider';
    final String price = consumer['price'] ?? '';
    final double rating = (consumer['rating'] ?? 0).toDouble();
    final List<String> services = List<String>.from(consumer['services'] ?? const []);
    final String? assetImage = consumer['assetImage'];
    final String about = (consumer['about'] as String?) ?? 'Trusted local laundry expert focused on quality and timely delivery.';
    final String specialties = (consumer['specialties'] as String?) ?? 'Wash & Dry, Dry Cleaning, Ironing, Express Service';
    final int years = (consumer['years'] as int?) ?? 3;

    // New fields for consumer-provided shop description
    final String shopDescription = (consumer['shopDescription'] as String?) ?? '';
    final String businessSince = (consumer['businessSince'] as String?) ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack ?? () => Navigator.of(context).pop(),
        ),
        title: const Text('Shop Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/laundry_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      clipBehavior: Clip.antiAlias,
                      child: assetImage != null
                          ? Image.asset(
                        assetImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFF9E9494),
                          child: const Icon(Icons.store, color: Colors.white),
                        ),
                      )
                          : Container(
                        color: const Color(0xFF9E9494),
                        child: const Icon(Icons.store, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                rating.toStringAsFixed(1),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          price,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const Text(
                          'Starting price',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Services
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Services Offered',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: services
                          .map((s) => Chip(
                        label: Text(s),
                        backgroundColor: const Color(0xE8515050),
                        labelStyle: const TextStyle(color: Colors.white),
                      ))
                          .toList(),
                    ),

                    // Consumer-provided shop description section
                    if (shopDescription.isNotEmpty || businessSince.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Text(
                        'About Our Shop',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0x80515050),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0x40FFFFFF)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (shopDescription.isNotEmpty) ...[
                              Text(
                                shopDescription,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            if (businessSince.isNotEmpty) ...[
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      color: Colors.white70, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Serving customers since: $businessSince',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),
                    // About shop section (provider-controlled details)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0x80515050),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0x40FFFFFF)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About This Shop',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            about,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.workspace_premium, color: Colors.white70, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Specialties: $specialties',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.history, color: Colors.white70, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Experience: $years years',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final cartManager = CartManager();
                      cartManager.addItem(
                        title: 'Booking',
                        providerName: name,
                        services: services,
                        price: price,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added $name to cart')),
                      );
                      Navigator.pushNamed(context, '/cart');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A62FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Book Now'),
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
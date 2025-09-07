import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../widgets/add_to_cart_button.dart';
import '../../services/cart_service.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample services that can be added to cart
    final services = [
      {
        'id': 'wash_fold_basic',
        'name': 'Basic Wash & Fold',
        'price': 99.0,
        'icon': Iconsax.lamp_on,
        'color': const Color(0xFF6366F1),
        'description': 'Regular wash and fold service for everyday clothes',
        'category': 'Laundry',
      },
      {
        'id': 'wash_fold_premium',
        'name': 'Premium Wash & Fold',
        'price': 199.0,
        'icon': Iconsax.lamp_on,
        'color': const Color(0xFF8B5CF6),
        'description': 'Premium wash with fabric softener and special care',
        'category': 'Laundry',
      },
      {
        'id': 'dry_clean_regular',
        'name': 'Regular Dry Cleaning',
        'price': 299.0,
        'icon': Iconsax.broom,
        'color': const Color(0xFF10B981),
        'description': 'Professional dry cleaning for delicate fabrics',
        'category': 'Cleaning',
      },
      {
        'id': 'dry_clean_express',
        'name': 'Express Dry Cleaning',
        'price': 449.0,
        'icon': Iconsax.broom,
        'color': const Color(0xFF059669),
        'description': 'Same day dry cleaning service',
        'category': 'Cleaning',
      },
      {
        'id': 'iron_regular',
        'name': 'Regular Ironing',
        'price': 79.0,
        'icon': Iconsax.icon,
        'color': const Color(0xFFF59E0B),
        'description': 'Steam ironing for wrinkle-free clothes',
        'category': 'Ironing',
      },
      {
        'id': 'iron_premium',
        'name': 'Premium Ironing',
        'price': 129.0,
        'icon': Iconsax.icon,
        'color': const Color(0xFFEA580C),
        'description': 'Professional pressing with starch',
        'category': 'Ironing',
      },
      {
        'id': 'stain_removal',
        'name': 'Stain Removal',
        'price': 199.0,
        'icon': Iconsax.magic_star,
        'color': const Color(0xFFEF4444),
        'description': 'Specialized stain removal treatment',
        'category': 'Special',
      },
      {
        'id': 'shoe_cleaning',
        'name': 'Shoe Cleaning',
        'price': 249.0,
        'icon': Iconsax.box,
        'color': const Color(0xFF6B7280),
        'description': 'Professional shoe cleaning and polishing',
        'category': 'Special',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Our Services',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Cart icon with badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Iconsax.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: StreamBuilder(
                  stream: Stream.periodic(const Duration(milliseconds: 100)),
                  builder: (context, snapshot) {
                    final cartService = CartService();
                    final itemCount = cartService.itemCount;
                    if (itemCount == 0) return const SizedBox();
                    return Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$itemCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF4F46E5).withOpacity(0.1),
              const Color(0xFFE5E7EB).withOpacity(0.8),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Choose Your Service',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select from our wide range of laundry services',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),
            // Service cards grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return _buildServiceCard(service);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and price
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (service['color'] as Color).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  service['icon'] as IconData,
                  color: service['color'] as Color,
                  size: 32,
                ),
                Text(
                  '₹${service['price']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: service['color'] as Color,
                  ),
                ),
              ],
            ),
          ),
          // Service details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['name'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  service['description'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Add to cart button
                SizedBox(
                  width: double.infinity,
                  child: AddToCartButton(
                    itemId: service['id'] as String,
                    itemName: service['name'] as String,
                    price: service['price'] as double,
                    icon: service['icon'] as IconData,
                    color: service['color'] as Color,
                    description: service['description'] as String?,
                    category: service['category'] as String?,
                    showQuantityControls: false,
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

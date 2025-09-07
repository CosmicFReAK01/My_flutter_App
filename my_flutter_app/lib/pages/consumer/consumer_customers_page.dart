import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ConsumerCustomersPage extends StatefulWidget {
  final VoidCallback? onBack;
  const ConsumerCustomersPage({Key? key, this.onBack}) : super(key: key);

  @override
  State<ConsumerCustomersPage> createState() => _ConsumerCustomersPageState();
}

class _ConsumerCustomersPageState extends State<ConsumerCustomersPage> {
  String searchTerm = '';
  String filterStatus = 'all'; // 'all', 'active', 'inactive'

  final List<Map<String, dynamic>> customers = [
    {
      'id': 1,
      'name': 'John Smith',
      'email': 'john.smith@email.com',
      'phone': '+1 234-567-8901',
      'address': '123 Main St, City, State',
      'totalOrders': 24,
      'totalSpent': 456.78,
      'lastOrder': '2024-01-15',
      'status': 'active',
      'joinDate': '2023-06-15'
    },
    {
      'id': 2,
      'name': 'Sarah Johnson',
      'email': 'sarah.johnson@email.com',
      'phone': '+1 234-567-8902',
      'address': '456 Oak Ave, City, State',
      'totalOrders': 18,
      'totalSpent': 389.45,
      'lastOrder': '2024-01-14',
      'status': 'active',
      'joinDate': '2023-08-22'
    },
    {
      'id': 3,
      'name': 'Mike Davis',
      'email': 'mike.davis@email.com',
      'phone': '+1 234-567-8903',
      'address': '789 Pine Rd, City, State',
      'totalOrders': 16,
      'totalSpent': 324.90,
      'lastOrder': '2024-01-13',
      'status': 'active',
      'joinDate': '2023-09-10'
    },
    {
      'id': 4,
      'name': 'Lisa Brown',
      'email': 'lisa.brown@email.com',
      'phone': '+1 234-567-8904',
      'address': '321 Elm St, City, State',
      'totalOrders': 14,
      'totalSpent': 298.65,
      'lastOrder': '2024-01-12',
      'status': 'inactive',
      'joinDate': '2023-07-05'
    },
  ];

  List<Map<String, dynamic>> get filteredCustomers {
    return customers.where((customer) {
      final matchesSearch = customer['name']
          .toString()
          .toLowerCase()
          .contains(searchTerm.toLowerCase()) ||
          customer['email']
              .toString()
              .toLowerCase()
              .contains(searchTerm.toLowerCase());

      final matchesFilter = filterStatus == 'all' ||
          customer['status'] == filterStatus;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customers',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage your customer relationships and track their activity',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Iconsax.user_add, size: 18),
                  label: const Text('Add Customer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search and Filter Row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            onChanged: (value) => setState(() => searchTerm = value),
                            decoration: InputDecoration(
                              hintText: 'Search customers by name or email...',
                              prefixIcon: const Icon(Iconsax.search_normal, size: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          setState(() {
                            filterStatus = value;
                          });
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(
                            value: 'all',
                            child: Text('All Customers'),
                          ),
                          const PopupMenuItem(
                            value: 'active',
                            child: Text('Active Only'),
                          ),
                          const PopupMenuItem(
                            value: 'inactive',
                            child: Text('Inactive Only'),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(Iconsax.filter, size: 18),
                              SizedBox(width: 8),
                              Text('Filter'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Stats Cards
                  SizedBox(
                    height: isMobile ? null : 120,
                    child: isMobile
                        ? Column(
                      children: [
                        _buildStatCard(
                          'Total Customers',
                          '${customers.length}',
                          Iconsax.people,
                          const Color(0xFF6366F1),
                        ),
                        const SizedBox(height: 16),
                        _buildStatCard(
                          'Active Customers',
                          '${customers.where((c) => c['status'] == 'active').length}',
                          Iconsax.user_tick,
                          const Color(0xFF10B981),
                        ),
                        const SizedBox(height: 16),
                        _buildStatCard(
                          'Avg. Orders',
                          '${(customers.map((c) => c['totalOrders'] as int).reduce((a, b) => a + b) / customers.length).toStringAsFixed(1)}',
                          Iconsax.shopping_bag,
                          const Color(0xFFF59E0B),
                        ),
                      ],
                    )
                        : Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Customers',
                            '${customers.length}',
                            Iconsax.people,
                            const Color(0xFF6366F1),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'Active Customers',
                            '${customers.where((c) => c['status'] == 'active').length}',
                            Iconsax.user_tick,
                            const Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'Avg. Orders',
                            '${(customers.map((c) => c['totalOrders'] as int).reduce((a, b) => a + b) / customers.length).toStringAsFixed(1)}',
                            Iconsax.shopping_bag,
                            const Color(0xFFF59E0B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Customers List Header
                  Row(
                    children: [
                      Text(
                        'All Customers',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${filteredCustomers.length}',
                          style: const TextStyle(
                            color: Color(0xFF2563EB),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Sort: Newest',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Iconsax.arrow_down_1, size: 16, color: Colors.grey),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Customers List
                  if (filteredCustomers.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.people,
                              size: 64,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No customers found',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your search or filter criteria.',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  searchTerm = '';
                                  filterStatus = 'all';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4F46E5),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              child: const Text('Clear Filters'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredCustomers.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (BuildContext context, int index) {
                          final customer = filteredCustomers[index];
                          return _buildCustomerCard(customer, isMobile);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(Map<String, dynamic> customer, bool isMobile) {
    final statusColor = customer['status'] == 'active'
        ? const Color(0xFF10B981)
        : const Color(0xFFEF4444);

    final avatarColor = customer['status'] == 'active'
        ? const Color(0xFFD1FAE5)
        : const Color(0xFFFEE2E2);

    final avatarTextColor = customer['status'] == 'active'
        ? const Color(0xFF065F46)
        : const Color(0xFF991B1B);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isMobile
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mobile layout
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: avatarColor,
                child: Text(
                  customer['name'].toString().substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: avatarTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      customer['email'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  customer['status'] as String,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMobileStatItem('Orders', '${customer['totalOrders']}'),
              _buildMobileStatItem('Spent', '\$${(customer['totalSpent'] as double).toStringAsFixed(2)}'),
              _buildMobileStatItem('Last Order', _formatDate(customer['lastOrder'] as String)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Iconsax.eye, size: 16),
                  label: const Text('View'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4F46E5),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Iconsax.message, size: 16),
                  label: const Text('Message'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      )
          : Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: avatarColor,
            child: Text(
              customer['name'].toString().substring(0, 1).toUpperCase(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: avatarTextColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      customer['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        customer['status'] as String,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  customer['email'] as String,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Iconsax.call, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      customer['phone'] as String,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCustomerStat('Total Orders', '${customer['totalOrders']}'),
                _buildCustomerStat('Total Spent', '\$${(customer['totalSpent'] as double).toStringAsFixed(2)}'),
                _buildCustomerStat('Last Order', _formatDate(customer['lastOrder'] as String)),
                _buildCustomerStat('Member Since', _formatDate(customer['joinDate'] as String)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Row(
                  children: [
                    Icon(Iconsax.eye, size: 16),
                    SizedBox(width: 8),
                    Text('View'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF4F46E5),
                  side: const BorderSide(color: Color(0xFF4F46E5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Row(
                  children: [
                    Icon(Iconsax.message, size: 16),
                    SizedBox(width: 8),
                    Text('Message'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  }
}
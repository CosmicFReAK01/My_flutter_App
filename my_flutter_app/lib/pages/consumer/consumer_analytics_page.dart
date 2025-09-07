import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  final VoidCallback? onBack;
  const AnalyticsPage({Key? key, this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final monthlyData = [
      {'month': 'Jan', 'revenue': 8500, 'orders': 142, 'customers': 89},
      {'month': 'Feb', 'revenue': 9200, 'orders': 156, 'customers': 94},
      {'month': 'Mar', 'revenue': 10800, 'orders': 178, 'customers': 112},
      {'month': 'Apr', 'revenue': 11500, 'orders': 189, 'customers': 118},
      {'month': 'May', 'revenue': 12100, 'orders': 201, 'customers': 125},
      {'month': 'Jun', 'revenue': 12486, 'orders': 215, 'customers': 132},
    ];

    final servicePerformance = [
      {'service': 'Wash & Fold', 'orders': 485, 'revenue': 3420, 'percentage': 45},
      {'service': 'Dry Cleaning', 'orders': 234, 'revenue': 4680, 'percentage': 25},
      {'service': 'Wash & Iron', 'orders': 312, 'revenue': 2856, 'percentage': 20},
      {'service': 'Express Wash', 'orders': 156, 'revenue': 1530, 'percentage': 10},
    ];

    final topCustomers = [
      {'name': 'John Smith', 'orders': 24, 'spent': 456.78, 'lastOrder': '2024-01-15'},
      {'name': 'Sarah Johnson', 'orders': 18, 'spent': 389.45, 'lastOrder': '2024-01-14'},
      {'name': 'Mike Davis', 'orders': 16, 'spent': 324.90, 'lastOrder': '2024-01-13'},
      {'name': 'Lisa Brown', 'orders': 14, 'spent': 298.65, 'lastOrder': '2024-01-12'},
      {'name': 'Tom Wilson', 'orders': 12, 'spent': 245.30, 'lastOrder': '2024-01-11'},
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with back button
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/consumer-home');
                },
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back to Dashboard',
              ),
              const Text(
                'Analytics',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Track your business performance and growth metrics.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 24),

          // KPI Cards
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth < 600 ? 1 : 2;
              double childAspectRatio = constraints.maxWidth < 600 ? 2.5 : 1.5;
              
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: childAspectRatio,
            children: [
              _buildKPICard(
                'Monthly Revenue',
                '₹12,486',
                '+12.3% from last month',
                Icons.attach_money,
                Colors.green,
                true,
              ),
              _buildKPICard(
                'Total Orders',
                '215',
                '+8.2% from last month',
                Icons.inventory,
                Colors.blue,
                true,
              ),
              _buildKPICard(
                'New Customers',
                '132',
                '+15.1% from last month',
                Icons.people,
                Colors.purple,
                true,
              ),
              _buildKPICard(
                'Avg. Order Value',
                '₹58.11',
                '-2.4% from last month',
                Icons.calendar_today,
                Colors.orange,
                false,
              ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // Charts Row
          Row(
            children: [
              // Revenue Chart
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Monthly Revenue',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 24),
                      ...monthlyData.map((data) {
                        final maxRevenue = monthlyData
                            .map((d) => d['revenue'] as int)
                            .reduce((a, b) => a > b ? a : b);
                        final percentage = (data['revenue'] as int) / maxRevenue;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 32,
                                child: Text(
                                  data['month'] as String,
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: percentage,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 60,
                                child: Text(
                                  '₹${(data['revenue'] as int).toString()}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Orders Chart
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Monthly Orders',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 24),
                      ...monthlyData.map((data) {
                        final maxOrders = monthlyData
                            .map((d) => d['orders'] as int)
                            .reduce((a, b) => a > b ? a : b);
                        final percentage = (data['orders'] as int) / maxOrders;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 32,
                                child: Text(
                                  data['month'] as String,
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: percentage,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 40,
                                child: Text(
                                  '${data['orders']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Service Performance
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Service Performance',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),
                ...servicePerformance.map((service) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service['service'] as String,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${service['orders']} orders',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₹${(service['revenue'] as int).toString()}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${service['percentage']}% share',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Top Customers
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Top Customers',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),
                Table(
                  children: [
                    const TableRow(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey)),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('Customer', style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('Orders', style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('Total Spent', style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('Last Order', style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    ...topCustomers.map((customer) {
                      return TableRow(
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(customer['name'] as String),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text('${customer['orders']}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text('₹${(customer['spent'] as double).toStringAsFixed(2)}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(customer['lastOrder'] as String),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(
      String title,
      String value,
      String change,
      IconData icon,
      Color color,
      bool isPositive,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          isPositive ? Icons.trending_up : Icons.trending_down,
                          size: 16,
                          color: isPositive ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          change,
                          style: TextStyle(
                            fontSize: 12,
                            color: isPositive ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:laundry_mate/pages/consumer/consumer_customers_page.dart';
import 'consumer_order_page.dart';
import 'consumer_services_page.dart';
import 'consumer_notifications_page.dart';
import 'consumer_settings_page.dart';
import 'consumer_shop_details_page.dart';
import 'consumer_analytics_page.dart' show AnalyticsPage;

class DashboardPage extends StatefulWidget {
  final bool isGuest;
  const DashboardPage({Key? key, this.isGuest = false}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}


class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin {
  int selectedIndex = 0;
  bool showMenu = false;
  late AnimationController _animationController;
  late AnimationController _cardAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Color scheme for the app
  final Color primaryColor = const Color(0xFF4F46E5);
  final Color secondaryColor = const Color(0xFF10B981);
  final Color backgroundColor = const Color(0xFFF9FAFB);
  final Color cardColor = const Color(0xFFFFFFFF);
  final Color textPrimary = const Color(0xFF1F2937);
  final Color textSecondary = const Color(0xFF6B7280);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _cardAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      if (showMenu) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
      showMenu = !showMenu;
    });
  }

  late final List<Map<String, dynamic>> menuItems = [
    {'title': 'Dashboard', 'icon': Iconsax.category, 'gradient': [primaryColor, primaryColor.withOpacity(0.8)], 'isLogout': false},
    {'title': 'Orders', 'icon': Iconsax.shopping_bag, 'gradient': [const Color(0xFF10B981), const Color(0xFF059669)], 'isLogout': false},
    {'title': 'Services', 'icon': Iconsax.convert_3d_cube, 'gradient': [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)], 'isLogout': false},
    {'title': 'Customers', 'icon': Iconsax.profile_2user, 'gradient': [const Color(0xFFF59E0B), const Color(0xFFD97706)], 'isLogout': false},
    {'title': 'Analytics', 'icon': Iconsax.chart_2, 'gradient': [const Color(0xFFEC4899), const Color(0xFFDB2777)], 'isLogout': false},
    {'title': 'Notifications', 'icon': Iconsax.notification, 'gradient': [const Color(0xFFF97316), const Color(0xFFEA580C)], 'isLogout': false},
    {'title': 'Settings', 'icon': Iconsax.setting_2, 'gradient': [const Color(0xFF6B7280), const Color(0xFF4B5563)], 'isLogout': false},
    {'title': 'Shop Details', 'icon': Iconsax.shop, 'gradient': [const Color(0xFF06B6D4), const Color(0xFF0891B2)], 'isLogout': false},
    {'title': 'Logout', 'icon': Iconsax.logout, 'gradient': [const Color(0xFFEF4444), const Color(0xFFDC2626)], 'isLogout': true},
  ];

  Widget _buildContent() {
    switch (selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return ConsumerOrderPage(onBack: () => setState(() => selectedIndex = 0));
      case 2:
        return ConsumerServicesPage(onBack: () => setState(() => selectedIndex = 0));
      case 3:
        return ConsumerCustomersPage(onBack: () => setState(() => selectedIndex = 0)); // Placeholder for Customers page
      case 4:
        return AnalyticsPage(onBack: () => setState(() => selectedIndex = 0));
      case 5:
        return ConsumerNotificationsPage(onBack: () => setState(() => selectedIndex = 0));
      case 6:
        return ConsumerSettingsPage(onBack: () => setState(() => selectedIndex = 0));
      case 7:
        return ConsumerShopDetailsPage(onBack: () => setState(() => selectedIndex = 0));
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    final stats = [
      {
        'title': 'Total Revenue',
        'value': '₹12,486',
        'change': '+12.3%',
        'icon': Iconsax.wallet_3,
        'gradient': [secondaryColor, secondaryColor.withOpacity(0.8)],
        'shadowColor': secondaryColor.withOpacity(0.2),
      },
      {
        'title': 'Total Orders',
        'value': '1,247',
        'change': '+8.2%',
        'icon': Iconsax.shopping_bag,
        'gradient': [primaryColor, primaryColor.withOpacity(0.8)],
        'shadowColor': primaryColor.withOpacity(0.2),
      },
      {
        'title': 'Active Customers',
        'value': '892',
        'change': '+15.1%',
        'icon': Iconsax.profile_2user,
        'gradient': [const Color(0xFF8B5CF6), const Color(0xFF8B5CF6).withOpacity(0.8)],
        'shadowColor': const Color(0xFF8B5CF6).withOpacity(0.2),
      },
      {
        'title': 'Growth Rate',
        'value': '23.4%',
        'change': '+5.7%',
        'icon': Iconsax.trend_up,
        'gradient': [const Color(0xFFF59E0B), const Color(0xFFF59E0B).withOpacity(0.8)],
        'shadowColor': const Color(0xFFF59E0B).withOpacity(0.2),
      },
    ];

    final recentOrders = [
      {
        'id': '001',
        'customer': 'John Smith',
        'service': 'Wash & Fold',
        'status': 'completed',
        'amount': '₹15.99',
        'time': '2 hrs ago'
      },
      {
        'id': '002',
        'customer': 'Sarah Johnson',
        'service': 'Dry Cleaning',
        'status': 'in-progress',
        'amount': '₹32.50',
        'time': '45 mins ago'
      },
      {
        'id': '003',
        'customer': 'Mike Davis',
        'service': 'Wash & Iron',
        'status': 'pending',
        'amount': '₹22.75',
        'time': 'Just now'
      },
      {
        'id': '004',
        'customer': 'Lisa Brown',
        'service': 'Express Wash',
        'status': 'completed',
        'amount': '₹18.99',
        'time': '5 hrs ago'
      },
    ];

    return Container(
      color: backgroundColor,
      child: CustomScrollView(
        slivers: [
          // App Bar Section - Fixed the overlap issue
          SliverAppBar(
            backgroundColor: primaryColor,
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            leading: Container(), // Remove default leading
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor, primaryColor.withOpacity(0.7)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top row with title and menu button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Dashboard',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Iconsax.menu_1, color: Colors.white),
                              onPressed: _toggleMenu,
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Welcome section at the bottom
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome back, Owner!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              'Fresh & Clean Laundry',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            if (widget.isGuest)
                              Container(
                                margin: const EdgeInsets.only(top: 12.0),
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(color: Colors.orange.shade300),
                                ),
                                child: const Text(
                                  'Guest Mode',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Stats Grid Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: stats.length,
                    itemBuilder: (context, index) {
                      final stat = stats[index];
                      return _buildStatCard(stat, index);
                    },
                  ),
                ),
              ),
            ),
          ),

          // Quick Actions Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildQuickActionGrid(),
                ],
              ),
            ),
          ),

          // Recent Orders Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Orders',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() => selectedIndex = 1);
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          for (int i = 0; i < recentOrders.length; i++)
                            _buildOrderItem(recentOrders[i], i),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Schedule Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Schedule",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildScheduleList(),
                ],
              ),
            ),
          ),

          // Insights Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Business Insights',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildInsightsGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(Map<String, dynamic> stat, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: stat['gradient'] as List<Color>,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          stat['icon'] as IconData,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ),
                      Text(
                        stat['change'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    stat['value'] as String,
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    stat['title'] as String,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionGrid() {
    final quickActions = [
      {
        'title': 'New Order',
        'icon': Iconsax.add_circle,
        'color': primaryColor,
        'index': 1,
      },
      {
        'title': 'Add Service',
        'icon': Iconsax.convert_3d_cube,
        'color': secondaryColor,
        'index': 2,
      },
      {
        'title': 'Shop Details',
        'icon': Iconsax.shop,
        'color': const Color(0xFF8B5CF6),
        'index': 7,
      },
      {
        'title': 'Notifications',
        'icon': Iconsax.notification,
        'color': const Color(0xFFF59E0B),
        'index': 5,
      },
      {
        'title': 'Settings',
        'icon': Iconsax.setting_2,
        'color': const Color(0xFF6B7280),
        'index': 6,
      },
      {
        'title': 'Analytics',
        'icon': Iconsax.chart_2,
        'color': const Color(0xFFEC4899),
        'index': 4,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 0.9,
      ),
      itemCount: quickActions.length,
      itemBuilder: (context, index) {
        final action = quickActions[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 500 + (index * 50)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: () {
                    setState(() {
                      selectedIndex = action['index'] as int;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: (action['color'] as Color).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            action['icon'] as IconData,
                            color: action['color'] as Color,
                            size: 24.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          action['title'] as String,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(50 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: index < 3
                      ? BorderSide(color: Colors.grey.shade200)
                      : BorderSide.none,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        '#${order['id']}',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['customer'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          order['service'] as String,
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 12.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          order['time'] as String,
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        order['amount'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order['status'] as String)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          (order['status'] as String).replaceAll('-', ' '),
                          style: TextStyle(
                            fontSize: 10.0,
                            color: _getStatusColor(order['status'] as String),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScheduleList() {
    final scheduleItems = [
      {
        'icon': Iconsax.clock,
        'title': 'Pickup - Order #045',
        'time': '2:00 PM - 3:00 PM',
        'color': const Color(0xFFF59E0B),
      },
      {
        'icon': Iconsax.truck,
        'title': 'Delivery - Order #032',
        'time': '4:30 PM - 5:30 PM',
        'color': secondaryColor,
      },
      {
        'icon': Iconsax.message,
        'title': 'Follow-up - Customer Review',
        'time': '6:00 PM',
        'color': primaryColor,
      },
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            for (int i = 0; i < scheduleItems.length; i++)
              _buildScheduleItem(scheduleItems[i], i),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(Map<String, dynamic> item, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 150)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(bottom: 12.0),
              decoration: BoxDecoration(
                color: (item['color'] as Color).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: (item['color'] as Color).withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: item['color'] as Color,
                      size: 20.0,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          item['time'] as String,
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Iconsax.arrow_right_3,
                    color: textSecondary,
                    size: 20.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInsightsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.2,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        final insights = [
          {
            'title': 'Peak Hours',
            'value': '2-4 PM',
            'icon': Iconsax.clock,
            'color': const Color(0xFFF59E0B),
          },
          {
            'title': 'Top Service',
            'value': 'Wash & Fold',
            'icon': Iconsax.convert_3d_cube,
            'color': primaryColor,
          },
          {
            'title': 'Avg. Order Value',
            'value': '₹24.50',
            'icon': Iconsax.wallet_3,
            'color': secondaryColor,
          },
          {
            'title': 'Customer Satisfaction',
            'value': '94%',
            'icon': Iconsax.like_1,
            'color': const Color(0xFFEC4899),
          },
        ];

        final insight = insights[index];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: (insight['color'] as Color).withOpacity(0.05),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: (insight['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    insight['icon'] as IconData,
                    color: insight['color'] as Color,
                    size: 24.0,
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  insight['value'] as String,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  insight['title'] as String,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return secondaryColor;
      case 'in-progress':
        return primaryColor;
      case 'pending':
        return const Color(0xFFF59E0B);
      default:
        return textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          _buildContent(),
          // Side menu with backdrop filter
          if (showMenu)
            GestureDetector(
              onTap: _toggleMenu,
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          SlideTransition(
            position: _slideAnimation,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    bottomLeft: Radius.circular(24.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20.0,
                      offset: const Offset(-5, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Menu header
                    Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Iconsax.shop, color: Colors.white, size: 28.0),
                          const SizedBox(width: 12.0),
                          const Expanded(
                            child: Text(
                              'LaundryMate',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Iconsax.close_circle, color: Colors.white),
                            onPressed: _toggleMenu,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: menuItems.length,
                        itemBuilder: (context, index) {
                          final item = menuItems[index];
                          final isSelected = selectedIndex == index;

                          return TweenAnimationBuilder<double>(
                            duration: Duration(milliseconds: 300 + (index * 50)),
                            tween: Tween(begin: 0.0, end: 1.0),
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(50 * (1 - value), 0),
                                child: Opacity(
                                  opacity: value,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8.0),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? primaryColor.withOpacity(0.1)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: ListTile(
                                      leading: Icon(
                                        item['icon'] as IconData,
                                        color: isSelected
                                            ? primaryColor
                                            : textSecondary,
                                        size: 24.0,
                                      ),
                                      title: Text(
                                        item['title'] as String,
                                        style: TextStyle(
                                          color: isSelected
                                              ? primaryColor
                                              : textPrimary,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      trailing: isSelected
                                          ? Icon(
                                        Iconsax.arrow_right_2,
                                        color: primaryColor,
                                        size: 20.0,
                                      )
                                          : null,
                                      onTap: () async {
                                        await _animationController.reverse();
                                        setState(() => showMenu = false);

                                        await Future.delayed(
                                            const Duration(milliseconds: 200));

                                        if (item['isLogout'] == true) {
                                          final shouldLogout =
                                          await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              backgroundColor: cardColor,
                                              title: Text(
                                                'Logout',
                                                style: TextStyle(
                                                    color: textPrimary),
                                              ),
                                              content: Text(
                                                'Are you sure you want to logout?',
                                                style: TextStyle(
                                                    color: textSecondary),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: textSecondary),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, true),
                                                  style: TextButton.styleFrom(
                                                      backgroundColor:
                                                      const Color(
                                                          0xFFEF4444)),
                                                  child: const Text(
                                                    'Logout',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (shouldLogout == true) {
                                            if (mounted) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/login',
                                                    (route) => false,
                                              );
                                            }
                                          } else {
                                            if (mounted) {
                                              setState(() => showMenu = true);
                                              _animationController.forward();
                                            }
                                          }
                                        } else {
                                          setState(() => selectedIndex = index);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
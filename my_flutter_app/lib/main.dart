import 'package:flutter/material.dart';
import 'pages/customer/customer_address_page.dart';
import 'pages/customer/customer_orders_page.dart';
import 'pages/customer/cart_page.dart';
import 'pages/customer/customer_profile_page.dart';
import 'pages/payment_page.dart';
import 'pages/consumer/consumer_order_page.dart';
import 'pages/consumer/consumer_profile_page.dart';
import 'pages/consumer/consumer_address_page.dart';
import 'pages/customer/customer_settings_page.dart';
import 'pages/consumer/consumer_settings_page.dart';
import 'pages/customer/customers_edit_profile_page.dart';
import 'pages/consumer/consumer_dashboard_page.dart';
import 'pages/consumer/consumer_shop_details_page.dart';
import 'pages/consumer/consumer_services_page.dart';
import 'pages/consumer/consumer_notifications_page.dart';
import 'pages/consumer/consumer_detail_page.dart';
import 'pages/consumer/consumer_page.dart';
import 'role_selection_screen.dart';
import 'pages/consumer/consumer_analytics_page.dart';
import 'pages/customer/customers_page.dart';
import 'pages/customer/customers_notifications_page.dart';
import 'pages/shop_registration_page.dart';
import 'pages/customer/customers_home_page.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'pages/consumer/service_provider.dart';
import 'pages/customer/services_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider()),
        ChangeNotifierProvider(create: (context) => ServiceProvider()),
      ],
      child: const LaundryVendorApp(),
    ),
  );
}

class LaundryVendorApp extends StatelessWidget {
  const LaundryVendorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LaundryMate Vendor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainApp(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const RoleSelectionScreen(),
        '/role-selection': (context) => const RoleSelectionScreen(),
        '/home': (context) => const HomePage(),
        '/customer-role': (context) => const RoleSelectionScreen(),
        '/orders': (context) => const OrdersPage(),
        '/cart': (context) => const CartPage(),
        '/services': (context) => const ServicesPage(),
        '/profile': (context) => const ProfilePage(),
        '/edit_profile': (context) => const EditProfilePage(),
        '/addresses': (context) => const CustomerAddressPage(),
        '/notifications': (context) => const NotificationsPage(),
        '/payment': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as List<Map<String, dynamic>>? ?? [];
          return PaymentPage(cartItems: args);
        },
        '/consumer-orders': (context) => ConsumerOrderPage(onBack: () {  },),
        '/consumer-profile': (context) => const ConsumerProfilePage(),
        '/consumer-addresses': (context) => const ConsumerAddressPage(),
        '/customer-settings': (context) => const CustomerSettingsPage(),
        '/consumer-settings-page': (context) => ConsumerSettingsPage(onBack: () {  },),
        '/consumers': (context) => const ConsumerPage(),
        '/consumer-home': (context) => const DashboardPage(),
        '/consumer-shop-details': (context) => const ConsumerShopDetailsPage(),
        '/consumer-services': (context) => const ConsumerServicesPage(),
        '/consumer-notifications': (context) => const ConsumerNotificationsPage(),
        '/consumer-detail': (context) => const ConsumerDetailPage(
          consumer: {
            'name': 'Default Shop',
            'price': '₹50',
            'rating': 4.5,
            'services': ['Wash & Fold', 'Dry Cleaning'],
            'about': 'Default shop description',
            'specialties': 'Default specialties',
            'years': 2,
          },
        ),
      },
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int selectedIndex = 0;
  bool isRegistered = false;
  bool hasSelectedRole = false;
  String? selectedRole;
  bool isGuest = false;

  final List<Map<String, dynamic>> menuItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard, 'page': const DashboardPage()},
    {'title': 'Orders', 'icon': Icons.inventory, 'page': const OrdersPage()},
    {'title': 'Services', 'icon': Icons.room_service, 'page': const ServicesPage()},
    {'title': 'Customers', 'icon': Icons.people, 'page': const CustomersPage()},
    {'title': 'Analytics', 'icon': Icons.analytics, 'page': const AnalyticsPage()},
    {'title': 'Notifications', 'icon': Icons.notifications, 'page': const NotificationsPage()},
    {'title': 'Settings', 'icon': Icons.settings, 'page': const CustomerSettingsPage()},
  ];

  void handleRoleSelection(String role) {
    setState(() {
      hasSelectedRole = true;
      selectedRole = role;
    });
  }

  void handleRegistrationComplete() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const DashboardPage(isGuest: false),
      ),
    );
  }

  void handleGuestLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const DashboardPage(isGuest: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!hasSelectedRole) {
      return RoleSelectionScreen(onRoleSelected: handleRoleSelection);
    }

    if (selectedRole == 'customer') {
      return const HomePage();
    } else if (selectedRole == 'consumer') {
      if (!isRegistered) {
        return ShopRegistrationPage(
          onComplete: handleRegistrationComplete,
          onGuest: handleGuestLogin,
        );
      }
      return DashboardPage(isGuest: isGuest);
    }

    // Fallback for unexpected cases
    return const Scaffold(
      body: Center(
        child: Text('Unexpected role selection'),
      ),
    );
  }
}
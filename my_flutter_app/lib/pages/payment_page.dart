import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

void main() {
  runApp(const LaundryApp());
}

class LaundryApp extends StatelessWidget {
  const LaundryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PaymentPage(cartItems: [
        {'name': 'Wash & Fold', 'price': 15.99, 'quantity': 1},
        {'name': 'Dry Cleaning', 'price': 25.99, 'quantity': 2},
      ]),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PaymentPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const PaymentPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final bool _deliverySelected = false;
  String _selectedPaymentMethod = 'upi';
  bool _showOrderSummary = false;
  String? _selectedUpiApp;

  List<Map<String, dynamic>> upiApps = [
    {'id': 'google_pay', 'name': 'Google Pay', 'icon': Iconsax.mobile, 'color': Colors.blue},
    {'id': 'phonepe', 'name': 'PhonePe', 'icon': Iconsax.mobile, 'color': Colors.purple},
    {'id': 'paytm', 'name': 'Paytm', 'icon': Iconsax.mobile, 'color': Colors.blueAccent},
    {'id': 'amazon_pay', 'name': 'Amazon Pay', 'icon': Iconsax.mobile, 'color': Colors.blue[900]},
  ];

  List<Map<String, dynamic>> paymentMethods = [
    {'id': 'upi', 'name': 'UPI', 'icon': Iconsax.mobile},
    {'id': 'card', 'name': 'Credit/Debit Card', 'icon': Iconsax.card},
    {'id': 'netbanking', 'name': 'Net Banking', 'icon': Iconsax.bank},
    {'id': 'cod', 'name': 'Cash on Delivery', 'icon': Iconsax.money},
  ];

  double getTotal() {
    double total = 0.0;
    for (var item in widget.cartItems) {
      total += item['price'] * item['quantity'];
    }
    if (_deliverySelected) total += 5.99;
    return total;
  }

  @override
  Widget build(BuildContext context) {
    double total = getTotal();
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry Payment'),
        backgroundColor: Colors.blue[700],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.receipt),
            onPressed: () {
              setState(() {
                _showOrderSummary = !_showOrderSummary;
              });
            },
          ),
        ],
      ),
      body: _showOrderSummary
          ? _buildOrderSummary(total, isSmallScreen)
          : _buildPaymentMethods(total, isSmallScreen),
    );
  }

  Widget _buildOrderSummary(double total, bool isSmallScreen) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              child: Column(
                children: [
                  Column(
                    children: widget.cartItems.map((item) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(item['name']),
                        subtitle: Text('Quantity: ${item['quantity']}'),
                        trailing: Text('₹${(item['price'] * item['quantity']).toStringAsFixed(2)}'),
                      );
                    }).toList(),
                  ),
                  const Divider(),
                  _buildSummaryRow('Subtotal', '₹${total.toStringAsFixed(2)}', isSmallScreen),
                  _buildSummaryRow('Delivery Fee', '₹${_deliverySelected ? 5.99 : 0.0}', isSmallScreen),
                  _buildSummaryRow('Tax (8%)', '₹${(total * 0.08).toStringAsFixed(2)}', isSmallScreen),
                  const Divider(),
                  _buildSummaryRow(
                    'Total Amount',
                    '₹${(total + (total * 0.08) + (_deliverySelected ? 5.99 : 0.0)).toStringAsFixed(2)}',
                    isSmallScreen,
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Payment Method',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  paymentMethods.firstWhere((method) => method['id'] == _selectedPaymentMethod)['icon'],
                  color: Colors.blue[700],
                  size: isSmallScreen ? 18 : 24,
                ),
                SizedBox(width: isSmallScreen ? 8 : 12),
                Expanded(
                  child: Text(
                    paymentMethods.firstWhere((method) => method['id'] == _selectedPaymentMethod)['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                ),
                if (_selectedPaymentMethod == 'upi' && _selectedUpiApp != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      upiApps.firstWhere((app) => app['id'] == _selectedUpiApp)['name'],
                      style: TextStyle(
                        fontSize: isSmallScreen ? 10 : 12,
                        color: Colors.blue[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: isSmallScreen ? 20 : 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                setState(() {
                  _showOrderSummary = false;
                });
              },
              child: Text(
                'Change Payment Method',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                _showPaymentSuccessDialog(total);
              },
              child: Text(
                'Confirm and Pay',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isSmallScreen, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? (isSmallScreen ? 14 : 16) : (isSmallScreen ? 12 : 14),
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? (isSmallScreen ? 16 : 18) : (isSmallScreen ? 12 : 14),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.blue[700] : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods(double total, bool isSmallScreen) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Amount Section
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[100]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${total.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 18 : 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.check_circle, color: Colors.green, size: isSmallScreen ? 24 : 30),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Cashback Offer
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[100]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.local_offer, color: Colors.orange[700], size: isSmallScreen ? 16 : 20),
                      SizedBox(width: isSmallScreen ? 6 : 8),
                      Expanded(
                        child: Text(
                          '5% Cashback - Claim now with payment offers',
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontWeight: FontWeight.w500,
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isSmallScreen ? 16 : 24),

                // Payment Methods Title
                Text(
                  'Choose Payment Method',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // UPI Payment Method
                _buildPaymentMethodCard(
                  'upi',
                  'UPI',
                  Iconsax.mobile,
                  isSelected: _selectedPaymentMethod == 'upi',
                  isSmallScreen: isSmallScreen,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pay using UPI',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // UPI Apps Selection
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = constraints.maxWidth > 400 ? 2 : 1;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: isSmallScreen ? 2.5 : 3,
                            ),
                            itemCount: upiApps.length,
                            itemBuilder: (context, index) {
                              final app = upiApps[index];
                              final isSelected = _selectedUpiApp == app['id'];

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedPaymentMethod = 'upi';
                                    _selectedUpiApp = app['id'];
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 8 : 12,
                                    vertical: isSmallScreen ? 6 : 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? (app['color'] as Color).withOpacity(0.2)
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? app['color'] as Color
                                          : Colors.grey[300]!,
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        app['icon'],
                                        size: isSmallScreen ? 16 : 20,
                                        color: isSelected
                                            ? app['color'] as Color
                                            : Colors.grey[700],
                                      ),
                                      SizedBox(width: isSmallScreen ? 6 : 8),
                                      Expanded(
                                        child: Text(
                                          app['name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: isSelected
                                                ? app['color'] as Color
                                                : Colors.black,
                                            fontSize: isSmallScreen ? 12 : 14,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle,
                                          color: app['color'] as Color,
                                          size: isSmallScreen ? 14 : 16,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      // Add new UPI ID option
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = 'upi';
                            _selectedUpiApp = 'custom';
                          });
                          _showAddUpiIdDialog(isSmallScreen);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: _selectedUpiApp == 'custom'
                                    ? Colors.blue
                                    : Colors.blue.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add,
                                size: isSmallScreen ? 14 : 16,
                                color: _selectedUpiApp == 'custom'
                                    ? Colors.blue
                                    : Colors.blue[700],
                              ),
                              SizedBox(width: isSmallScreen ? 4 : 6),
                              Text(
                                'Add new UPI ID',
                                style: TextStyle(
                                  color: _selectedUpiApp == 'custom'
                                      ? Colors.blue
                                      : Colors.blue[700],
                                  fontWeight: _selectedUpiApp == 'custom'
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  fontSize: isSmallScreen ? 12 : 14,
                                ),
                              ),
                              if (_selectedUpiApp == 'custom')
                                Icon(Icons.check, size: isSmallScreen ? 14 : 16, color: Colors.blue),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Card Payment Method
                _buildPaymentMethodCard(
                  'card',
                  'Credit / Debit / ATM Card',
                  Iconsax.card,
                  isSelected: _selectedPaymentMethod == 'card',
                  isSmallScreen: isSmallScreen,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add and secure cards as per RBI guidelines',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Get upto 5% cashback* • 2 offers available',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Net Banking Payment Method
                _buildPaymentMethodCard(
                  'netbanking',
                  'Net Banking',
                  Iconsax.bank,
                  isSelected: _selectedPaymentMethod == 'netbanking',
                  isSmallScreen: isSmallScreen,
                  child: Text(
                    'Pay using net banking',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Cash on Delivery Payment Method
                _buildPaymentMethodCard(
                  'cod',
                  'Cash on Delivery',
                  Iconsax.money,
                  isSelected: _selectedPaymentMethod == 'cod',
                  isSmallScreen: isSmallScreen,
                  child: Text(
                    'Pay when your order is delivered',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Gift Card Option
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.gift, color: Colors.blue[700], size: isSmallScreen ? 18 : 24),
                      SizedBox(width: isSmallScreen ? 8 : 12),
                      Expanded(
                        child: Text(
                          'Have a CleanSuds Gift Card?',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                        ),
                      ),
                      Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Pay Now Button
        Container(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey[200]!)),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                setState(() {
                  _showOrderSummary = true;
                });
              },
              child: Text(
                'Review Order',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard(String id, String title, IconData icon,
      {required bool isSelected, required bool isSmallScreen, required Widget child}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = id;
          if (id != 'upi') {
            _selectedUpiApp = null;
          }
        });
      },
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue[200]! : Colors.grey[300]!,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[700] : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: isSmallScreen ? 16 : 20,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.blue[700] : Colors.black,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 4 : 6),
                  child,
                ],
              ),
            ),
            SizedBox(width: isSmallScreen ? 4 : 8),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.blue[700], size: isSmallScreen ? 18 : 20),
          ],
        ),
      ),
    );
  }

  void _showAddUpiIdDialog(bool isSmallScreen) {
    TextEditingController upiIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            width: isSmallScreen ? MediaQuery.of(context).size.width * 0.8 : 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add UPI ID',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: upiIdController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your UPI ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (upiIdController.text.isNotEmpty) {
                          setState(() {
                            // Add the custom UPI ID to the list
                            upiApps.add({
                              'id': 'custom_${upiIdController.text}',
                              'name': upiIdController.text,
                              'icon': Iconsax.user,
                              'color': Colors.blue,
                            });
                            _selectedUpiApp = 'custom_${upiIdController.text}';
                          });
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPaymentSuccessDialog(double total) {
    String paymentMethod = paymentMethods.firstWhere((method) => method['id'] == _selectedPaymentMethod)['name'];

    if (_selectedPaymentMethod == 'upi' && _selectedUpiApp != null) {
      final selectedApp = upiApps.firstWhere(
            (app) => app['id'] == _selectedUpiApp,
        orElse: () => {'name': 'UPI'},
      );
      paymentMethod = '${selectedApp['name']} (UPI)';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 28),
                    SizedBox(width: 10),
                    Text(
                      'Payment Successful',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Your payment of ₹${total.toStringAsFixed(2)} has been processed successfully via $paymentMethod. Your laundry will be ${_deliverySelected ? 'delivered' : 'ready for pickup'} on time.',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigate to home or order tracking page
                    },
                    child: const Text('OK'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';

class ShopRegistrationPage extends StatefulWidget {
  final VoidCallback onComplete;
  final VoidCallback? onGuest;

  const ShopRegistrationPage({Key? key, required this.onComplete, this.onGuest}) : super(key: key);

  @override
  State<ShopRegistrationPage> createState() => _ShopRegistrationPageState();
}

class _ShopRegistrationPageState extends State<ShopRegistrationPage> {
  int currentStep = 0;
  final PageController _pageController = PageController();

  // Form controllers
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController ownerEmailController = TextEditingController();
  final TextEditingController ownerPhoneController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController shopAddressController = TextEditingController();
  final TextEditingController shopPhoneController = TextEditingController();
  final TextEditingController shopEmailController = TextEditingController();
  final TextEditingController shopDescriptionController = TextEditingController();

  String businessType = 'individual';
  String yearsInBusiness = '';
  List<String> servicesOffered = [];

  final List<String> serviceOptions = [
    'Wash & Fold',
    'Dry Cleaning',
    'Wash & Iron',
    'Express Wash',
    'Pickup & Delivery',
    'Alterations',
    'Shoe Cleaning',
    'Bedding & Linens'
  ];

  bool isStepValid() {
    switch (currentStep) {
      case 0:
        return ownerNameController.text.isNotEmpty &&
            ownerEmailController.text.isNotEmpty &&
            ownerPhoneController.text.isNotEmpty;
      case 1:
        return shopNameController.text.isNotEmpty &&
            shopAddressController.text.isNotEmpty &&
            shopPhoneController.text.isNotEmpty;
      case 2:
        return businessType.isNotEmpty && servicesOffered.isNotEmpty;
      case 3:
        return true;
      default:
        return true;
    }
  }

  void nextStep() {
    if (currentStep < 3) {
      setState(() {
        currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Final completion: validate required fields from previous steps
      if (ownerNameController.text.isEmpty ||
          ownerEmailController.text.isEmpty ||
          ownerPhoneController.text.isEmpty ||
          shopNameController.text.isEmpty ||
          shopAddressController.text.isEmpty ||
          shopPhoneController.text.isEmpty ||
          servicesOffered.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please complete all required fields before finishing.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      widget.onComplete();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index <= currentStep ? Colors.blue : Colors.grey[300],
              ),
              child: Center(
                child: index < currentStep
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: index <= currentStep ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (index < 3)
              Container(
                width: 40,
                height: 2,
                color: index < currentStep ? Colors.blue : Colors.grey[300],
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
          ],
        );
      }),
    );
  }

  Widget buildOwnerInfoStep() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.blue, size: 32),
          ),
          const SizedBox(height: 16),
          const Text(
            'Owner Information',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Let\'s start with your personal details',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: ownerNameController,
            decoration: const InputDecoration(
              labelText: 'Full Name *',
              hintText: 'Enter your full name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: ownerEmailController,
            decoration: const InputDecoration(
              labelText: 'Email Address *',
              hintText: 'your@email.com',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: ownerPhoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number *',
              hintText: '+1 (555) 123-4567',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget buildShopInfoStep() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.store, color: Colors.blue, size: 32),
          ),
          const SizedBox(height: 16),
          const Text(
            'Shop Information',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tell us about your laundry business',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: shopNameController,
            decoration: const InputDecoration(
              labelText: 'Shop Name *',
              hintText: 'Fresh & Clean Laundry',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: shopAddressController,
            decoration: const InputDecoration(
              labelText: 'Shop Address *',
              hintText: '123 Main Street, City, State 12345',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: shopPhoneController,
            decoration: const InputDecoration(
              labelText: 'Shop Phone *',
              hintText: '+1 (555) 123-4567',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: shopEmailController,
            decoration: const InputDecoration(
              labelText: 'Shop Email',
              hintText: 'contact@yourshop.com',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: shopDescriptionController,
            decoration: const InputDecoration(
              labelText: 'Shop Description',
              hintText: 'Tell customers about your shop...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget buildBusinessDetailsStep() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.business, color: Colors.blue, size: 32),
          ),
          const SizedBox(height: 16),
          const Text(
            'Business Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Help us understand your business better',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Business Type *',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: [
              RadioListTile<String>(
                title: const Text('Individual/Sole Proprietor'),
                subtitle: const Text('Single owner business'),
                value: 'individual',
                groupValue: businessType,
                onChanged: (value) => setState(() => businessType = value!),
              ),
              RadioListTile<String>(
                title: const Text('Company/Corporation'),
                subtitle: const Text('Business entity'),
                value: 'company',
                groupValue: businessType,
                onChanged: (value) => setState(() => businessType = value!),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Years in Business',
              border: OutlineInputBorder(),
            ),
            value: yearsInBusiness.isEmpty ? null : yearsInBusiness,
            items: const [
              DropdownMenuItem(value: 'new', child: Text('New Business (Less than 1 year)')),
              DropdownMenuItem(value: '1-2', child: Text('1-2 years')),
              DropdownMenuItem(value: '3-5', child: Text('3-5 years')),
              DropdownMenuItem(value: '6-10', child: Text('6-10 years')),
              DropdownMenuItem(value: '10+', child: Text('More than 10 years')),
            ],
            onChanged: (value) => setState(() => yearsInBusiness = value ?? ''),
          ),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Services Offered *',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: serviceOptions.map((service) {
              final isSelected = servicesOffered.contains(service);
              return FilterChip(
                label: Text(service),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      servicesOffered.add(service);
                    } else {
                      servicesOffered.remove(service);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildCompletionStep() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.green[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.green, size: 32),
          ),
          const SizedBox(height: 16),
          const Text(
            'Registration Complete!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Review your information and complete registration',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Owner Information', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(ownerNameController.text),
                Text(ownerEmailController.text),
                Text(ownerPhoneController.text),
                const SizedBox(height: 16),
                const Text('Shop Information', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(shopNameController.text),
                Text(shopAddressController.text),
                Text(shopPhoneController.text),
                const SizedBox(height: 16),
                const Text('Services', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(servicesOffered.join(', ')),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              border: Border.all(color: Colors.blue[200]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What\'s Next?',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Access your vendor dashboard\n'
                      '• Set up your service pricing\n'
                      '• Start receiving orders from customers\n'
                      '• Manage your business operations',
                  style: TextStyle(color: Colors.blue[800]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    buildStepIndicator(),
                    const SizedBox(height: 32),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          buildOwnerInfoStep(),
                          buildShopInfoStep(),
                          buildBusinessDetailsStep(),
                          buildCompletionStep(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: currentStep == 0 ? null : previousStep,
                          child: const Text('Back'),
                        ),
                        ElevatedButton(
                          onPressed: nextStep,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(currentStep == 3 ? 'Complete Registration' : 'Next'),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: widget.onGuest,
                      child: const Text('Continue as Guest'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    ownerNameController.dispose();
    ownerEmailController.dispose();
    ownerPhoneController.dispose();
    shopNameController.dispose();
    shopAddressController.dispose();
    shopPhoneController.dispose();
    shopEmailController.dispose();
    shopDescriptionController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
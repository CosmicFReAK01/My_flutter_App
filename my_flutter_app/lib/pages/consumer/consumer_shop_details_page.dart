import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConsumerShopDetailsPage extends StatefulWidget {
  final VoidCallback? onBack;
  const ConsumerShopDetailsPage({Key? key, this.onBack}) : super(key: key);

  @override
  State<ConsumerShopDetailsPage> createState() => _ConsumerShopDetailsPageState();
}

class _ConsumerShopDetailsPageState extends State<ConsumerShopDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _specialtiesController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  final TextEditingController _turnaroundController = TextEditingController();

  List<String> selectedServices = [];
  List<String> selectedSustainability = [];
  bool _hasSubscription = false;
  bool _doorstepService = false;
  bool _expressService = false;

  final List<String> serviceOptions = [
    'Wash & Fold',
    'Dry Cleaning',
    'Ironing',
    'Stain Removal',
    'Express Service',
    'Premium Fabric Care',
    'Specialty Item Cleaning'
  ];

  final List<String> sustainabilityOptions = [
    'Zero-Plastic Packaging',
    'Water Recycling',
    'Electric Delivery Vehicles',
    'Eco-Friendly Detergents',
    'Energy-Efficient Equipment'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/consumer-home');
          },
        ),
        title: const Text('Shop Details'),
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Basic Information'),
                _buildTextField(
                  controller: _shopNameController,
                  label: 'Shop Name *',
                  hint: 'Enter your shop name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your shop name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _addressController,
                  label: 'Full Address *',
                  hint: 'Enter your shop address',
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your shop address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _yearsController,
                  label: 'Years of Experience',
                  hint: 'How many years have you been in business?',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 24),

                _buildSectionHeader('Services Offered'),
                _buildCheckboxList(
                  options: serviceOptions,
                  selected: selectedServices,
                  onChanged: (values) {
                    setState(() {
                      selectedServices = values;
                    });
                  },
                ),
                const SizedBox(height: 24),

                _buildSectionHeader('Service Features'),
                SwitchListTile(
                  title: const Text('Doorstep Pickup & Delivery'),
                  subtitle: const Text('Offer convenient pickup and delivery service'),
                  value: _doorstepService,
                  onChanged: (value) {
                    setState(() {
                      _doorstepService = value;
                    });
                  },
                  activeThumbColor: const Color(0xFF2A62FF),
                ),
                SwitchListTile(
                  title: const Text('24-Hour Turnaround Time'),
                  subtitle: const Text('Guaranteed delivery within 24 hours'),
                  value: _expressService,
                  onChanged: (value) {
                    setState(() {
                      _expressService = value;
                    });
                  },
                  activeThumbColor: const Color(0xFF2A62FF),
                ),
                _buildTextField(
                  controller: _turnaroundController,
                  label: 'Standard Turnaround Time',
                  hint: 'e.g., 48 hours, 3 days, etc.',
                ),
                const SizedBox(height: 24),

                _buildSectionHeader('Shop Description'),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'About Your Shop',
                  hint: 'Describe your shop, your mission, and what makes you special',
                  maxLines: 5,
                ),
                _buildTextField(
                  controller: _specialtiesController,
                  label: 'Specialties',
                  hint: 'What are you best at? (e.g., stain removal, delicate fabrics, etc.)',
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveShopDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A62FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Shop Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2A62FF),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildCheckboxList({
    required List<String> options,
    required List<String> selected,
    required Function(List<String>) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: options.map((option) {
          return CheckboxListTile(
            title: Text(option),
            value: selected.contains(option),
            onChanged: (bool? value) {
              List<String> updated = List.from(selected);
              if (value == true) {
                updated.add(option);
              } else {
                updated.remove(option);
              }
              onChanged(updated);
            },
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ),
    );
  }

  void _saveShopDetails() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically save the data to your backend
      // For now, we'll just show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Shop details saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back or to another screen
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _specialtiesController.dispose();
    _yearsController.dispose();
    _turnaroundController.dispose();
    super.dispose();
  }
}
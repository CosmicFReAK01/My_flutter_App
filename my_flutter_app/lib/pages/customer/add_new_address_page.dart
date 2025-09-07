import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/maps_service.dart';
import '../../widgets/customer_bottom_nav.dart';
import '../../widgets/customer_toggle_menu.dart';

class AddNewAddressPage extends StatefulWidget {
  final Map<String, dynamic>? address;
  
  const AddNewAddressPage({Key? key, this.address}) : super(key: key);

  @override
  State<AddNewAddressPage> createState() => _AddNewAddressPageState();
}

class _AddNewAddressPageState extends State<AddNewAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _altPhoneController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _landmarkController = TextEditingController();
  
  bool _isLoading = false;
  String _selectedAddressType = 'Home';
  
  // Background image asset - developers can change this path manually
  static const String backgroundImageAsset = 'assets/images/laundry_background.png';

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _populateFields();
    }
  }

  void _populateFields() {
    final address = widget.address!;
    _fullNameController.text = address['fullName'] ?? '';
    _phoneController.text = address['phone'] ?? '';
    _altPhoneController.text = address['altPhone'] ?? '';
    _pincodeController.text = address['pincode'] ?? '';
    _stateController.text = address['state'] ?? '';
    _cityController.text = address['city'] ?? '';
    _address1Controller.text = address['address1'] ?? '';
    _address2Controller.text = address['address2'] ?? '';
    _landmarkController.text = address['landmark'] ?? '';
    _selectedAddressType = address['type'] ?? 'Home';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.address != null ? 'Edit Address' : 'Add New Address',
          style: const TextStyle(color: Color(0xB8515050)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
          const CustomerToggleMenu(),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          // Background image - fully visible
          image: DecorationImage(
            image: AssetImage(backgroundImageAsset),
            fit: BoxFit.cover,
            opacity: 1.0,
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 20),
                _buildFormField(
                  controller: _fullNameController,
                  label: 'Full Name',
                  icon: Icons.person,
                  validator: (value) => value?.isEmpty == true ? 'Please enter full name' : null,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value?.isEmpty == true ? 'Please enter phone number' : null,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  controller: _altPhoneController,
                  label: 'Alternative Phone Number (Optional)',
                  icon: Icons.phone_android,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildFormField(
                        controller: _pincodeController,
                        label: 'Pincode',
                        icon: Icons.location_on,
                        keyboardType: TextInputType.number,
                        validator: (value) => value?.isEmpty == true ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xEE4A4A4A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: _useCurrentLocation,
                          child: const Column(
                            children: [
                              Icon(Icons.my_location, color: Colors.white, size: 22),
                              SizedBox(height: 6),
                              Text(
                                'Use Current',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildFormField(
                        controller: _stateController,
                        label: 'State',
                        icon: Icons.map,
                        validator: (value) => value?.isEmpty == true ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFormField(
                        controller: _cityController,
                        label: 'City',
                        icon: Icons.location_city,
                        validator: (value) => value?.isEmpty == true ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  controller: _address1Controller,
                  label: 'Address Line 1 (House No, Building Name)',
                  icon: Icons.home,
                  validator: (value) => value?.isEmpty == true ? 'Please enter address' : null,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  controller: _address2Controller,
                  label: 'Address Line 2 (Road Name, Area, Colony)',
                  icon: Icons.location_on,
                  validator: (value) => value?.isEmpty == true ? 'Please enter area details' : null,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  controller: _landmarkController,
                  label: '+ Add Nearby Famous Shop/Mall/Landmark',
                  icon: Icons.place,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xEE4A4A4A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0x30FFFFFF)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Address Type',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedAddressType = 'Home'),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _selectedAddressType == 'Home'
                                      ? Colors.green
                                      : const Color(0x40FFFFFF),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _selectedAddressType == 'Home'
                                        ? Colors.green
                                        : const Color(0x30FFFFFF),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.home,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Home',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedAddressType = 'Work'),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _selectedAddressType == 'Work'
                                      ? Colors.blue
                                      : const Color(0x40FFFFFF),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _selectedAddressType == 'Work'
                                        ? Colors.blue
                                        : const Color(0x30FFFFFF),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.work,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Work',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A62FF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            widget.address != null ? 'Update Address' : 'Save Address',
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomerBottomNav(
        currentIndex: 0, // Default to home
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/cart');
              break;
            case 2:
              Navigator.pushNamed(context, '/orders');
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int? maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFFC9C9C9),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFFFFFFFF)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0x80FFFFFF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0x80FFFFFF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: const Color(0x99454545),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        errorStyle: const TextStyle(
          color: Colors.orange,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      cursorColor: Colors.white,
      validator: validator,
    );
  }

  void _useCurrentLocation() async {
    setState(() {
    });

    try {
      Position? position = await MapsService.getCurrentLocation();
      if (position != null) {
        // Get address from coordinates using reverse geocoding
        Map<String, String>? addressData = await MapsService.getAddressFromCoordinates(
          latitude: position.latitude,
          longitude: position.longitude,
        );
        
        if (addressData != null) {
          setState(() {
            _address1Controller.text = addressData['address1'] ?? '';
            _address2Controller.text = addressData['address2'] ?? '';
            _cityController.text = addressData['city'] ?? '';
            _stateController.text = addressData['state'] ?? '';
            _pincodeController.text = addressData['pincode'] ?? '';
            _landmarkController.text = addressData['landmark'] ?? '';
          });
          
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Address auto-filled from current location!')),
          );
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unable to get address from location')),
          );
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to get current location')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
        });
      }
    }
  }

  void _saveAddress() {
    if (_formKey.currentState?.validate() == true) {
      setState(() => _isLoading = true);
      
      // Simulate API call
      Future.delayed(const Duration(seconds: 1), () {
        setState(() => _isLoading = false);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.address != null
                  ? 'Address updated successfully!'
                  : 'Address saved successfully!',
            ),
          ),
        );
        
        Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _pincodeController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _landmarkController.dispose();
    super.dispose();
  }
}

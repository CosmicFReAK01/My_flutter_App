import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../services/maps_service.dart';
import 'package:geolocator/geolocator.dart';
import '../customer/add_new_address_page.dart';

class ConsumerAddressPage extends StatefulWidget {
  const ConsumerAddressPage({super.key});

  @override
  State<ConsumerAddressPage> createState() => _ConsumerAddressPageState();
}

class _ConsumerAddressPageState extends State<ConsumerAddressPage> {
  bool _isSearchVisible = false;
  String _currentLocationText = 'Use my current location';
  final TextEditingController _searchController = TextEditingController();
  
  // Background image asset - developers can change this path manually
  static const String backgroundImageAsset = 'assets/images/background_city_view.jpg';

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final addresses = _getDemoAddresses();
        
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: _isSearchVisible
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0x40FFFFFF),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: const Color(0x30FFFFFF)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Search addresses...',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.white70),
                      ),
                    ),
                  )
                : const Text('My Addresses', style: TextStyle(color: Colors.white)),
            actions: [
              if (!_isSearchVisible)
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () => setState(() => _isSearchVisible = true),
                ),
              if (_isSearchVisible)
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => setState(() {
                    _isSearchVisible = false;
                    _searchController.clear();
                  }),
                ),
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              // Background image - developers can enable/disable by commenting/uncommenting
              image: DecorationImage(
                image: AssetImage(backgroundImageAsset),
                fit: BoxFit.cover,
                opacity: 1.0,

              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 100),
                // Add Address Bar
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0x60FFFFFF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x30FFFFFF)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.my_location, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: _useCurrentLocation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentLocationText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text(
                                'Tap to detect your location automatically',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                    ],
                  ),
                ),
                // Address List
                Expanded(
                  child: addresses.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_off_outlined, size: 64, color: Colors.white70),
                            SizedBox(height: 16),
                            Text('No addresses saved', style: TextStyle(fontSize: 18, color: Colors.white)),
                            Text('Add an address to get started', style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: addresses.length,
                        itemBuilder: (context, index) {
                          final address = addresses[index];
                          return _buildAddressCard(context, address, appProvider);
                        },
                      ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _addNewAddress(context, appProvider),
            backgroundColor: const Color(0xFF2A62FF),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Add New Address', style: TextStyle(color: Colors.white)),
          ),
        );
      },
    );
  }

  Widget _buildAddressCard(BuildContext context, Map<String, dynamic> address, AppProvider appProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x60FFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x30FFFFFF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: address['type'] == 'Home' ? Colors.green : Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  address['type'] == 'Home' ? Icons.home : Icons.work,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address['type'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      address['fullName'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white70),
                onSelected: (value) {
                  if (value == 'edit') {
                    _editAddress(context, address, appProvider);
                  } else if (value == 'delete') {
                    _deleteAddress(context, address, appProvider);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.white70),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${address['address1']}, ${address['address2']}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const SizedBox(width: 24),
              Expanded(
                child: Text(
                  '${address['city']}, ${address['state']} ${address['pincode']}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
          if (address['landmark'] != null && address['landmark'].isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.place, size: 16, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Near ${address['landmark']}',
                    style: const TextStyle(color: Colors.orange, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone, size: 16, color: Colors.white70),
              const SizedBox(width: 8),
              Text(
                address['phone'],
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addNewAddress(BuildContext context, AppProvider appProvider) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewAddressPage(),
      ),
    );
  }

  void _editAddress(BuildContext context, Map<String, dynamic> address, AppProvider appProvider) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNewAddressPage(address: address),
      ),
    );
  }

  void _deleteAddress(BuildContext context, Map<String, dynamic> address, AppProvider appProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Address'),
          content: Text('Are you sure you want to delete ${address['type']} address?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Address deleted successfully')),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
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
            _currentLocationText = '${addressData['address1']}, ${addressData['city']}, ${addressData['state']} ${addressData['pincode']}';
          });
          
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Current location address detected!')),
          );
        } else {
          setState(() {
            _currentLocationText = 'Current Location: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
          });
          
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location detected, but unable to get address')),
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

  List<Map<String, dynamic>> _getDemoAddresses() {
    return [
      {
        'fullName': 'Arjun Yadav',
        'phone': '+91 9876543210',
        'altPhone': '+91 9876543211',
        'pincode': '110001',
        'state': 'Delhi',
        'city': 'New Delhi',
        'address1': 'A-123, Green Park',
        'address2': 'Main Market Road',
        'landmark': 'Metro Station',
        'type': 'Home',
      },
      {
        'fullName': 'Arjun Yadav',
        'phone': '+91 9876543210',
        'altPhone': '',
        'pincode': '110016',
        'state': 'Delhi',
        'city': 'New Delhi',
        'address1': 'Tower B, Cyber City',
        'address2': 'DLF Phase 2, Sector 24',
        'landmark': 'DLF Mall',
        'type': 'Work',
      },
      {
        'fullName': 'Arjun Yadav',
        'phone': '+91 9876543210',
        'altPhone': '+91 9876543212',
        'pincode': '110017',
        'state': 'Delhi',
        'city': 'New Delhi',
        'address1': 'C-456, Lajpat Nagar',
        'address2': 'Central Market',
        'landmark': 'Lajpat Nagar Metro',
        'type': 'Home',
      },
      {
        'fullName': 'Arjun Yadav',
        'phone': '+91 9876543210',
        'altPhone': '+91 9876543213',
        'pincode': '110018',
        'state': 'Delhi',
        'city': 'New Delhi',
        'address1': 'D-789, Defence Colony',
        'address2': 'Main Market Road',
        'landmark': 'Defence Colony Market',
        'type': 'Home',
      },
    ];
  }






}

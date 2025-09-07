import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../services/maps_service.dart';
import '../../models/laundry_location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iconsax/iconsax.dart';
import '../../services/cart_service.dart';
import '../../widgets/add_to_cart_button.dart';

void main() {
  runApp(const LaundryMateApp());
}

class LaundryMateApp extends StatelessWidget {
  const LaundryMateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry Mate',
      theme: ThemeData(
        primaryColor: const Color(0x802A62FF),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0x80FF9E1F),
        ),
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/cart': (context) => const Placeholder(),
        '/orders': (context) => const Placeholder(),
        '/profile': (context) => const Placeholder(),
        '/addresses': (context) => const Placeholder(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // Background image asset - developers can change this path manually
  static const String backgroundImageAsset = 'assets/images/laundry_background.png';

  late CartService _cartService;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Map variables
  MapController? mapController;
  LatLng _currentLocation = const LatLng(28.6139, 77.2090); // Delhi coordinates
  bool _mapLoading = true;
  List<LaundryLocation> _laundryServices = [];

  // Bottom navigation
  int _currentIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // List of popular consumers
  final List<Map<String, dynamic>> _popularConsumers = [
    {
      'id': 1,
      'name': 'FreshClean Laundry',
      'rating': 4.8,
      'services': [
        {'name': 'Wash & Fold', 'price': 149.0, 'description': 'Regular wash and careful folding'},
        {'name': 'Dry Cleaning', 'price': 349.0, 'description': 'Professional dry cleaning'},
        {'name': 'Express Service', 'price': 249.0, 'description': 'Next day delivery'},
      ],
    },
    {
      'id': 2,
      'name': 'Premium Wash Hub',
      'rating': 4.9,
      'services': [
        {'name': 'Dry Clean Only', 'price': 299.0, 'description': 'Professional dry cleaning'},
        {'name': 'Premium Service', 'price': 499.0, 'description': 'Premium care for delicate fabrics'},
        {'name': 'Stain Removal', 'price': 199.0, 'description': 'Specialized stain treatment'},
      ],
    },
    {
      'id': 3,
      'name': 'Quick Iron Masters',
      'rating': 4.5,
      'services': [
        {'name': 'Ironing Only', 'price': 99.0, 'description': 'Professional ironing service'},
        {'name': 'Express Service', 'price': 199.0, 'description': 'Same day service'},
      ],
    },
    {
      'id': 4,
      'name': 'Eco Dry Cleaners',
      'rating': 4.7,
      'services': [
        {'name': 'Dry Clean Only', 'price': 349.0, 'description': 'Eco-friendly dry cleaning'},
        {'name': 'Eco-Friendly', 'price': 399.0, 'description': 'Environmentally conscious cleaning'},
        {'name': 'Premium Service', 'price': 449.0, 'description': 'Premium eco-friendly service'},
      ],
    },
    {
      'id': 5,
      'name': 'Wash & Fold Express',
      'rating': 4.6,
      'services': [
        {'name': 'Wash & Dry', 'price': 179.0, 'description': 'Basic wash and dry service'},
        {'name': 'Folding', 'price': 99.0, 'description': 'Professional folding service'},
        {'name': 'Express Service', 'price': 279.0, 'description': 'Fast turnaround service'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _cartService = CartService();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    mapController = MapController();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _mapLoading = false;
        _currentLocation = const LatLng(51.509364, -0.128928);
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _mapLoading = false;
          _currentLocation = const LatLng(51.509364, -0.128928);
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _mapLoading = false;
        _currentLocation = const LatLng(51.509364, -0.128928);
      });
      return;
    }

    try {
      Position? position = await MapsService.getCurrentLocation();
      if (position != null) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });
        await _loadNearbyLaundryServices();
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    } finally {
      setState(() {
        _mapLoading = false;
      });
    }
  }

  Future<void> _loadNearbyLaundryServices() async {
    try {
      List<LaundryLocation> services = await MapsService.getNearbyLaundryServices(
        latitude: _currentLocation.latitude,
        longitude: _currentLocation.longitude,
        radiusKm: 10.0,
      );
      setState(() {
        _laundryServices = services;
      });
    } catch (e) {
      debugPrint('Error loading laundry services: $e');
    }
  }

  List<Marker> _buildOpenStreetMapMarkers() {
    List<Marker> markers = [];

    // Add current location marker
    markers.add(
      Marker(
        point: _currentLocation,
        width: 80,
        height: 80,
        builder: (ctx) => const Icon(
          Icons.location_on,
          color: Colors.blue,
          size: 40,
        ),
      ),
    );

    // Add laundry service markers
    for (LaundryLocation service in _laundryServices) {
      markers.add(
        Marker(
          point: LatLng(service.latitude, service.longitude),
          width: 80,
          height: 80,
          builder: (ctx) => GestureDetector(
            onTap: () => _showLaundryDetails(service),
            child: Container(
              decoration: BoxDecoration(
                color: service.isOpen ? Colors.green : Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_laundry_service,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      );
    }

    return markers;
  }

  void _showLaundryDetails(LaundryLocation service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            service.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: service.isOpen ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            service.isOpen ? 'Open' : 'Closed',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          service.rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.location_on, color: Colors.grey, size: 20),
                        const SizedBox(width: 4),
                        Text('${service.distance.toStringAsFixed(1)} km away'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      service.address,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Opening Hours: ${service.openingHours}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Services:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: service.services.map((serviceType) => Chip(
                        label: Text(serviceType, style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.blue[50],
                      )).toList(),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _callLaundry(service.phone),
                            icon: const Icon(Icons.phone),
                            label: const Text('Call'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _openInMaps(service),
                            icon: const Icon(Icons.directions),
                            label: const Text('Directions'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2A62FF),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _callLaundry(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _openInMaps(LaundryLocation service) async {
    final Uri mapsUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${service.latitude},${service.longitude}'
    );
    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
    }
  }

  // New function to show consumer services
  void _showConsumerServices(Map<String, dynamic> consumer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFF2A62FF),
                    child: Icon(Icons.store, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          consumer['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              consumer['rating'].toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Available Services',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: consumer['services'].length,
                itemBuilder: (context, index) {
                  final service = consumer['services'][index];
                  return _buildServiceCard(service, consumer['name']);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service, String providerName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  service['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '₹${service['price']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2A62FF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            service['description'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: AddToCartButton(
              itemId: '${service['name']}_${providerName}',
              itemName: service['name'],
              price: service['price'],
              icon: Iconsax.shopping_bag,
              color: const Color(0xFF4F46E5),
              description: service['description'],
              showQuantityControls: true,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddToCartSuccess(String serviceName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  '$serviceName Added to Cart!',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Continue Shopping'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/cart');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A62FF),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('View Cart'),
                      ),
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: const BoxDecoration(
          // Background image - fully visible
          image: DecorationImage(
            image: AssetImage(backgroundImageAsset),
            fit: BoxFit.cover,
            opacity: 1.0,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              // Background elements with transparency
              Positioned(
                top: -50,
                right: -30,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0x302A62FF),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x802A62FF).withAlpha(100),
                        blurRadius: 50,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: -80,
                left: -40,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0x30FF9E1F),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x80FF9E1F).withAlpha(100),
                        blurRadius: 50,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App Bar with glass effect
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xC3515050),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0x30FFFFFF)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/profile');
                              },
                              child: const CircleAvatar(
                                backgroundColor: Color(0xC3515050),
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Hello, Arjun!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Cart: ${_cartService.items.length} items',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.notifications, color: Colors.white),
                              onPressed: () => Navigator.pushNamed(context, '/notifications'),
                            ),
                            IconButton(
                              icon: Stack(
                                children: [
                                  const Icon(Icons.shopping_cart, color: Colors.white),
                                  if (_cartService.items.isNotEmpty)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 16,
                                          minHeight: 16,
                                        ),
                                        child: Text(
                                          _cartService.items.length.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/cart');
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Search Bar with glass effect
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF595757),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFFFFFF)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: Colors.white70),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search services...',
                                  hintStyle: TextStyle(color: Color(0xFFFFFFFF)),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(color:Color(0xFFFFFFFF)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Popular Consumers Section
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Popular Consumers',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _popularConsumers.length,
                          itemBuilder: (context, index) {
                            final consumer = _popularConsumers[index];
                            final name = consumer['name'] as String;
                            final rating = (consumer['rating'] as double).toStringAsFixed(1);
                            final services = (consumer['services'] as List<dynamic>);

                            return GestureDetector(
                              onTap: () {
                                _showConsumerServices(consumer);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: index == _popularConsumers.length - 1 ? 0 : 16),
                                child: _buildPopularConsumerCard(name, rating, services),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Map Section
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Nearby Laundry Services',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Container(
                        height: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(50),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _mapLoading
                              ? Container(
                            color: const Color(0xFF515050),
                            child: const Center(child: CircularProgressIndicator()),
                          )
                              : GestureDetector(
                            onTap: () => _openFullScreenMap(),
                            child: AbsorbPointer(
                              child: FlutterMap(
                                mapController: mapController,
                                options: MapOptions(
                                  center: _currentLocation,
                                  zoom: 13.0,
                                  interactiveFlags: InteractiveFlag.none,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.laundry mate.app',
                                  ),
                                  MarkerLayer(markers: _buildOpenStreetMapMarkers()),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Services Section
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Our Services',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            _buildGlassServiceItem('Wash & Fold', Icons.local_laundry_service),
                            const SizedBox(width: 16),
                            _buildGlassServiceItem('Dry Clean', Icons.clean_hands),
                            const SizedBox(width: 16),
                            _buildGlassServiceItem('Ironing', Icons.iron),
                            const SizedBox(width: 16),
                            _buildGlassServiceItem('Premium', Icons.workspace_premium),
                            const SizedBox(width: 16),
                            _buildGlassServiceItem('Express', Icons.flash_on),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Special Offer Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xDB2A62FF),
                                Color(0xCB9C27B0),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x8E2A62FF).withAlpha(60),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '30% OFF',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'On your first order',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'Claim Now',
                                        style: TextStyle(
                                          color: Color(0xFF2A62FF),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.local_offer,
                                color: Colors.white,
                                size: 60,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Recent Orders
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Recent Orders',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xCD5E5C5C),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0x30FFFFFF)),
                        ),
                        child: Column(
                          children: [
                            _buildOrderItem('Wash & Fold', 'Completed', '₹299'),
                            const Divider(color: Color(0xC7FFFFFF), height: 24),
                            _buildOrderItem('Dry Cleaning', 'In Progress', '₹449'),
                            const Divider(color: Color(0xC5FFFFFF), height: 24),
                            _buildOrderItem('Ironing', 'Scheduled', '₹199'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Quick Access Buttons
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Quick Access',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/orders');
                                },
                                icon: const Icon(Icons.inventory),
                                label: const Text('My Orders'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2A62FF),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/cart');
                                },
                                icon: const Icon(Icons.shopping_cart),
                                label: const Text('Cart'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2A62FF),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/profile');
                                },
                                icon: const Icon(Icons.person),
                                label: const Text('Profile'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2A62FF),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/addresses');
                                },
                                icon: const Icon(Icons.location_on),
                                label: const Text('Addresses'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2A62FF),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0x80FFFFFF),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });

              // Navigation logic
              switch (index) {
                case 0:
                // Already on home page
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

              // Reset to home after a short delay
              Future.delayed(const Duration(milliseconds: 100), () {
                setState(() {
                  _currentIndex = 0;
                });
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0x00FFFFFF), // Transparent
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassServiceItem(String title, IconData icon) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xCC2A62FF), // More opaque blue background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: const Color(0xFF2A62FF), size: 22), // Blue icon on white
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black26,
                ),
              ],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPopularConsumerCard(String name, String rating, List<dynamic> services) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xA97C7C7C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFFFFF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
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
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xEA515050),
                child: Icon(Icons.store, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const Icon(Icons.star, color: Color(0x80FF9E1F), size: 16),
              const SizedBox(width: 4),
              Text(rating, style: const TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: services.take(3).map((s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0x40FFFFFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x30FFFFFF)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_laundry_service, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    s['name'],
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  void _openFullScreenMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenMapPage(
          currentLocation: _currentLocation,
          laundryServices: _laundryServices,
        ),
      ),
    );
  }

  Widget _buildOrderItem(String service, String status, String price) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xBE373636),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.local_laundry_service, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Text(
          price,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class FullScreenMapPage extends StatefulWidget {
  final LatLng currentLocation;
  final List<LaundryLocation> laundryServices;

  const FullScreenMapPage({
    Key? key,
    required this.currentLocation,
    required this.laundryServices,
  }) : super(key: key);

  @override
  State<FullScreenMapPage> createState() => _FullScreenMapPageState();
}

class _FullScreenMapPageState extends State<FullScreenMapPage> {
  MapController? mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Laundry Services'),
        backgroundColor: const Color(0xFF2A62FF),
        foregroundColor: Colors.white,
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: widget.currentLocation,
          zoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.laundry mate.app',
          ),
          MarkerLayer(markers: _buildFullScreenMarkers()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mapController?.move(widget.currentLocation, 14.0);
        },
        backgroundColor: const Color(0xFF2A62FF),
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }

  List<Marker> _buildFullScreenMarkers() {
    List<Marker> markers = [];

    // Add current location marker
    markers.add(
      Marker(
        point: widget.currentLocation,
        width: 80,
        height: 80,
        builder: (ctx) => const Icon(
          Icons.location_on,
          color: Colors.blue,
          size: 40,
        ),
      ),
    );

    // Add laundry service markers
    for (LaundryLocation service in widget.laundryServices) {
      markers.add(
        Marker(
          point: LatLng(service.latitude, service.longitude),
          width: 80,
          height: 80,
          builder: (ctx) => GestureDetector(
            onTap: () => _showLaundryDetails(service),
            child: Container(
              decoration: BoxDecoration(
                color: service.isOpen ? Colors.green : Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_laundry_service,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      );
    }

    return markers;
  }

  void _showLaundryDetails(LaundryLocation service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            service.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: service.isOpen ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            service.isOpen ? 'Open' : 'Closed',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          service.rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.location_on, color: Colors.grey, size: 20),
                        const SizedBox(width: 4),
                        Text('${service.distance.toStringAsFixed(1)} km away'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      service.address,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Opening Hours: ${service.openingHours}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Services:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: service.services.map((serviceType) => Chip(
                        label: Text(serviceType, style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.blue[50],
                      )).toList(),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _callLaundry(service.phone),
                            icon: const Icon(Icons.phone),
                            label: const Text('Call'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _openInMaps(service),
                            icon: const Icon(Icons.directions),
                            label: const Text('Directions'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2A62FF),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _callLaundry(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _openInMaps(LaundryLocation service) async {
    final Uri mapsUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${service.latitude},${service.longitude}'
    );
    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/laundry_location.dart';

class MapsService {
  static const String _baseUrl = 'http://localhost:4000';
  
  // Mock laundry services data - in production, this would come from your backend
  static final List<Map<String, dynamic>> _mockLaundryServices = [
    {
      'id': '1',
      'name': 'FreshClean Laundry',
      'location': {'lat': 28.6139, 'lng': 77.2090},
      'address': '123 Main Street, Delhi',
      'rating': 4.8,
      'services': ['Wash & Dry', 'Ironing', 'Express Service'],
      'phone': '+91 98765 43210',
      'imageUrl': null,
      'isOpen': true,
      'openingHours': '8:00 AM - 10:00 PM',
      'distance': 0.5,
    },
    {
      'id': '2',
      'name': 'Premium Wash Hub',
      'location': {'lat': 28.6200, 'lng': 77.2150},
      'address': '456 Park Avenue, Delhi',
      'rating': 4.9,
      'services': ['Dry Clean Only', 'Premium Service', 'Stain Removal'],
      'phone': '+91 98765 43211',
      'imageUrl': null,
      'isOpen': true,
      'openingHours': '9:00 AM - 9:00 PM',
      'distance': 1.2,
    },
    {
      'id': '3',
      'name': 'Quick Iron Masters',
      'location': {'lat': 28.6080, 'lng': 77.2030},
      'address': '789 Commercial Street, Delhi',
      'rating': 4.5,
      'services': ['Ironing Only', 'Express Service'],
      'phone': '+91 98765 43212',
      'imageUrl': null,
      'isOpen': false,
      'openingHours': '10:00 AM - 8:00 PM',
      'distance': 0.8,
    },
    {
      'id': '4',
      'name': 'Eco Dry Cleaners',
      'location': {'lat': 28.6250, 'lng': 77.2200},
      'address': '321 Green Lane, Delhi',
      'rating': 4.7,
      'services': ['Dry Clean Only', 'Eco-Friendly', 'Premium Service'],
      'phone': '+91 98765 43213',
      'imageUrl': null,
      'isOpen': true,
      'openingHours': '8:30 AM - 9:30 PM',
      'distance': 1.8,
    },
    {
      'id': '5',
      'name': 'Wash & Fold Express',
      'location': {'lat': 28.6050, 'lng': 77.1980},
      'address': '654 Express Road, Delhi',
      'rating': 4.6,
      'services': ['Wash & Dry', 'Folding', 'Express Service'],
      'phone': '+91 98765 43214',
      'imageUrl': null,
      'isOpen': true,
      'openingHours': '7:00 AM - 11:00 PM',
      'distance': 1.0,
    },
  ];

  /// Get current user location
  static Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return null;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      print('Current permission status: $permission');
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        print('Permission after request: $permission');
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        return null;
      }

      print('Getting current position...');
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      print('Location obtained: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      print('Error getting location: $e');
      // For macOS testing, return a mock location if real location fails
      if (e.toString().contains('location') || e.toString().contains('permission')) {
        print('Using mock location for testing');
        return Position(
          latitude: 28.6139,
          longitude: 77.2090,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      }
      return null;
    }
  }

  /// Get nearby laundry services
  static Future<List<LaundryLocation>> getNearbyLaundryServices({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
  }) async {
    try {
      // Calculate distances and filter by radius
      List<LaundryLocation> laundryServices = [];
      
      for (var serviceData in _mockLaundryServices) {
        double distance = Geolocator.distanceBetween(
          latitude,
          longitude,
          serviceData['location']['lat'],
          serviceData['location']['lng'],
        ) / 1000; // Convert to kilometers
        
        if (distance <= radiusKm) {
          var updatedData = Map<String, dynamic>.from(serviceData);
          updatedData['distance'] = distance;
          laundryServices.add(LaundryLocation.fromJson(updatedData));
        }
      }
      
      // Sort by distance
      laundryServices.sort((a, b) => a.distance.compareTo(b.distance));
      
      return laundryServices;
    } catch (e) {
      print('Error fetching nearby laundry services: $e');
      return [];
    }
  }

  /// Get all laundry services for map display
  static Future<List<LaundryLocation>> getAllLaundryServices() async {
    try {
      List<LaundryLocation> laundryServices = [];
      
      for (var serviceData in _mockLaundryServices) {
        laundryServices.add(LaundryLocation.fromJson(serviceData));
      }
      
      return laundryServices;
    } catch (e) {
      print('Error fetching all laundry services: $e');
      return [];
    }
  }

  /// Connect to the existing Maps API server for additional data
  static Future<Map<String, dynamic>?> getMapState() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/state'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error connecting to Maps API: $e');
      return null;
    }
  }

  /// Submit a report to the Maps API
  static Future<bool> submitReport({
    required String description,
    required String kind,
    required double latitude,
    required double longitude,
    String? reporterId,
    String? contact,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/reports'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'reporterId': reporterId,
          'contact': contact,
          'description': description,
          'kind': kind,
          'location': {
            'lat': latitude,
            'lng': longitude,
          },
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error submitting report: $e');
      return false;
    }
  }

  /// Reverse geocoding to get address from coordinates
  static Future<Map<String, String>?> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      // In a real app, you would use a geocoding service like Google Maps Geocoding API
      // For demo purposes, we'll simulate the API call and return mock data based on coordinates
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock reverse geocoding based on coordinates
      // In production, replace this with actual API call
      return _getMockAddressFromCoordinates(latitude, longitude);
    } catch (e) {
      print('Error in reverse geocoding: $e');
      return null;
    }
  }
  
  static Map<String, String> _getMockAddressFromCoordinates(double lat, double lng) {
    // Mock data based on common Delhi coordinates
    if (lat >= 28.6 && lat <= 28.7 && lng >= 77.1 && lng <= 77.3) {
      return {
        'address1': 'A-${(lat * 1000).toInt()}, Green Park',
        'address2': 'Main Market Road',
        'city': 'New Delhi',
        'state': 'Delhi',
        'pincode': '110016',
        'landmark': 'Green Park Metro Station',
      };
    } else if (lat >= 28.5 && lat <= 28.6 && lng >= 77.0 && lng <= 77.2) {
      return {
        'address1': 'B-${(lng * 1000).toInt()}, Lajpat Nagar',
        'address2': 'Central Market Area',
        'city': 'New Delhi',
        'state': 'Delhi',
        'pincode': '110024',
        'landmark': 'Lajpat Nagar Metro',
      };
    } else {
      // Default fallback address
      return {
        'address1': 'C-${(lat * 100).toInt()}, Connaught Place',
        'address2': 'Central Delhi',
        'city': 'New Delhi',
        'state': 'Delhi',
        'pincode': '110001',
        'landmark': 'Rajiv Chowk Metro',
      };
    }
  }

  /// Calculate distance between two points
  static double calculateDistance(
    double lat1, double lng1,
    double lat2, double lng2,
  ) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2) / 1000;
  }
}

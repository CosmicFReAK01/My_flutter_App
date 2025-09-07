import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/profile.dart';

class ConsumerProfilePage extends StatelessWidget {
  const ConsumerProfilePage({super.key});
  
  // Background image asset - developers can change this path manually
  static const String backgroundImageAsset = 'assets/images/background_city_view.jpg';

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final Profile? profile = appProvider.currentProfile;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Business Profile'),
            backgroundColor: Colors.green[600],
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editProfile(context, profile),
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
            child: profile == null
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.business_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No business profile', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildBusinessHeader(profile),
                          const SizedBox(height: 24),
                          _buildBusinessDetails(profile),
                          const SizedBox(height: 24),
                          _buildServiceCategories(profile),
                          const SizedBox(height: 24),
                          _buildActionButtons(context),
                        ],
                      ),
                  ),
                ),
            ),
        );
      },
    );
  }

  Widget _buildBusinessHeader(Profile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: profile.profileImageUrl != null
                  ? NetworkImage(profile.profileImageUrl!)
                  : null,
              child: profile.profileImageUrl == null
                  ? const Icon(Icons.business, size: 50)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              profile.businessName ?? profile.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Service Provider',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            if (profile.businessDescription != null) ...[
              const SizedBox(height: 8),
              Text(
                profile.businessDescription!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessDetails(Profile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Business Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.green),
              title: const Text('Owner Name'),
              subtitle: Text(profile.name),
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.green),
              title: const Text('Business Email'),
              subtitle: Text(profile.email),
            ),
            if (profile.phone != null)
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.green),
                title: const Text('Business Phone'),
                subtitle: Text(profile.phone!),
              ),
            ListTile(
              leading: const Icon(Icons.badge, color: Colors.green),
              title: const Text('Business ID'),
              subtitle: Text(profile.userId),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCategories(Profile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Services Offered',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (profile.serviceCategories != null && profile.serviceCategories!.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: profile.serviceCategories!.map((service) => Chip(
                  label: Text(service),
                  backgroundColor: Colors.green[100],
                  labelStyle: TextStyle(color: Colors.green[800]),
                )).toList(),
              )
            else
              Text(
                'No services listed',
                style: TextStyle(color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/shop-addresses'),
            icon: const Icon(Icons.store),
            label: const Text('Manage Shop Locations'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/received-orders'),
            icon: const Icon(Icons.inbox),
            label: const Text('Received Orders'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _manageServices(context),
            icon: const Icon(Icons.settings),
            label: const Text('Manage Services'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _editProfile(BuildContext context, Profile? profile) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit business profile feature coming soon!')),
    );
  }

  void _manageServices(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Manage services feature coming soon!')),
    );
  }
}

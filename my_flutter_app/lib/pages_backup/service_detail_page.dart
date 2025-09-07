import 'package:flutter/material.dart';
import '../widgets/notifications_drawer.dart';

class ServiceDetailPage extends StatelessWidget {
  const ServiceDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const NotificationsEndDrawer(),
      appBar: AppBar(
        title: const Text('Service Details'),
        backgroundColor: const Color(0xFF2A62FF),
        actions: [
          Builder(
            builder: (drawerContext) => IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Scaffold.of(drawerContext).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2A62FF),
              Color(0xFF6C8EFD),
              Color(0xFFF8F9FF),
            ],
          ),
        ),
        child: const Center(
          child: Text(
            'Service details will appear here',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
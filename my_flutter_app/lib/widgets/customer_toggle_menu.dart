import 'package:flutter/material.dart';

class CustomerToggleMenu extends StatefulWidget {
  const CustomerToggleMenu({Key? key}) : super(key: key);

  @override
  State<CustomerToggleMenu> createState() => _CustomerToggleMenuState();
}

class _CustomerToggleMenuState extends State<CustomerToggleMenu>
    with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
    if (_isMenuOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value * 3.14159,
            child: const Icon(Icons.more_vert, color: Colors.white),
          );
        },
      ),
      color: const Color(0x90FFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (String value) {
        switch (value) {
          case 'settings':
            Navigator.pushNamed(context, '/settings');
            break;
          case 'help':
            _showHelpDialog(context);
            break;
          case 'about':
            _showAboutDialog(context);
            break;
          case 'logout':
            _showLogoutDialog(context);
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings, color: Color(0xFF2A62FF)),
              SizedBox(width: 12),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'help',
          child: Row(
            children: [
              Icon(Icons.help_outline, color: Color(0xFF2A62FF)),
              SizedBox(width: 12),
              Text('Help & Support'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'about',
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF2A62FF)),
              SizedBox(width: 12),
              Text('About'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 12),
              Text('Logout', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Help & Support'),
          content: const Text(
            'Need help? Contact our support team:\n\n'
            '📞 Phone: +91 98765 43210\n'
            '📧 Email: support@laundrymate.com\n'
            '💬 Chat: Available 24/7',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About Laundry Mate'),
          content: const Text(
            'Laundry Mate v1.0.0\n\n'
            'Your trusted laundry service partner.\n'
            'Making laundry convenient and hassle-free.\n\n'
            '© 2024 Laundry Mate. All rights reserved.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add logout logic here
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

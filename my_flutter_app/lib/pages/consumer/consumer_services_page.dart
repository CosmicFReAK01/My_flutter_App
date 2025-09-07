import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconsax/iconsax.dart';
import 'service_provider.dart';

class ConsumerServicesPage extends StatefulWidget {
  final VoidCallback? onBack;
  const ConsumerServicesPage({Key? key, this.onBack}) : super(key: key);

  @override
  State<ConsumerServicesPage> createState() => _ConsumerServicesPageState();
}

class _ConsumerServicesPageState extends State<ConsumerServicesPage>
    with SingleTickerProviderStateMixin {
  bool showAddModal = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  String selectedUnit = 'per lb';
  String selectedCategory = 'Regular';

  late AnimationController _modalAnimationController;
  late Animation<Offset> _modalOffsetAnimation;
  late Animation<double> _modalFadeAnimation;

  @override
  void initState() {
    super.initState();
    _modalAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _modalOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _modalAnimationController, curve: Curves.easeOut),
    );
    _modalFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _modalAnimationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    durationController.dispose();
    _modalAnimationController.dispose();
    super.dispose();
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Express':
        return const Color(0xFFFF9E1F);
      case 'Premium':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF2A62FF);
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Express':
        return Iconsax.flash;
      case 'Premium':
        return Iconsax.crown;
      default:
        return Iconsax.shapes;
    }
  }

  void openAddModal() {
    setState(() => showAddModal = true);
    _modalAnimationController.forward();
  }

  void closeAddModal() async {
    await _modalAnimationController.reverse();
    setState(() => showAddModal = false);
    clearForm();
  }

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    durationController.clear();
    selectedUnit = 'per lb';
    selectedCategory = 'Regular';
  }

  void addService() {
    final provider = context.read<ServiceProvider>();
    if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
      final newService = Service(
        id: provider.services.isEmpty ? 1 : provider.services.last.id + 1,
        name: nameController.text,
        description: descriptionController.text,
        price: double.tryParse(priceController.text) ?? 0.0,
        unit: selectedUnit,
        duration: durationController.text,
        category: selectedCategory,
      );
      provider.addService(newService);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Service added successfully!'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      closeAddModal();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter service name and price'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> confirmDelete(int id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Iconsax.warning_2, size: 48, color: Colors.orange),
              const SizedBox(height: 16),
              const Text(
                'Delete Service',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to delete "$name"?',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed == true) {
      context.read<ServiceProvider>().deleteService(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Service deleted'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final services = context.watch<ServiceProvider>().services;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Services',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2A62FF),
        elevation: 2,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: openAddModal,
            icon: const Icon(Iconsax.add),
            tooltip: 'Add Service',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final isMobile = screenWidth < 600;
          final isTablet = screenWidth < 1000;
          final isLargeScreen = screenWidth > 1400;

          return Stack(
            children: [
              // Background with subtle gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF8FAFC),
                      Color(0xFFEFF6FF),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Services & Pricing',
                                style: TextStyle(
                                  fontSize: isMobile ? 24 : 32,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Manage your laundry services and pricing',
                                style: TextStyle(
                                  fontSize: isMobile ? 14 : 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isMobile)
                          ElevatedButton.icon(
                            onPressed: openAddModal,
                            icon: const Icon(Iconsax.add, size: 20),
                            label: const Text('Add Service'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2A62FF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              elevation: 2,
                              shadowColor: const Color(0xFF2A62FF).withOpacity(0.3),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Services grid
                    Expanded(
                      child: services.isEmpty
                          ? Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A62FF).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Iconsax.box,
                                  size: 64,
                                  color: const Color(0xFF2A62FF),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'No Services Yet',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add your first service to get started',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: openAddModal,
                                icon: const Icon(Iconsax.add),
                                label: const Text('Add Service'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2A62FF),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20), // Extra padding for bottom
                            ],
                          ),
                        ),
                      )
                          : AnimationLimiter(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: _getGridColumnCount(screenWidth),
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: _getGridAspectRatio(screenWidth),
                          ),
                          itemCount: services.length,
                          padding: const EdgeInsets.only(bottom: 80), // Added bottom padding
                          itemBuilder: (context, index) {
                            final service = services[index];
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              columnCount: 4,
                              child: ScaleAnimation(
                                scale: 0.9,
                                child: FadeInAnimation(
                                  child: ServiceCard(
                                    service: service,
                                    onDelete: () => confirmDelete(service.id, service.name),
                                    onToggle: () => context
                                        .read<ServiceProvider>()
                                        .toggleServiceStatus(service.id),
                                    getCategoryColor: getCategoryColor,
                                    getCategoryIcon: getCategoryIcon,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Add Service Modal
              if (showAddModal)
                GestureDetector(
                  onTap: closeAddModal,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: SlideTransition(
                      position: _modalOffsetAnimation,
                      child: FadeTransition(
                        opacity: _modalFadeAnimation,
                        child: Align(
                          alignment: isMobile ? Alignment.bottomCenter : Alignment.center,
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height * (isMobile ? 0.85 : 0.9),
                              maxWidth: isMobile
                                  ? double.infinity
                                  : screenWidth * 0.7,
                            ),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: isMobile
                                  ? const BorderRadius.vertical(top: Radius.circular(24))
                                  : BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 16,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min, // Changed to min to avoid overflow
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Add New Service',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: closeAddModal,
                                      icon: const Icon(Iconsax.close_circle, size: 28),
                                      tooltip: 'Close',
                                      color: Colors.grey.shade600,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min, // Changed to min
                                      children: [
                                        TextField(
                                          controller: nameController,
                                          decoration: InputDecoration(
                                            labelText: 'Service Name',
                                            labelStyle: TextStyle(color: Colors.grey.shade700),
                                            hintText: 'e.g., Wash & Fold',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(color: Color(0xFF2A62FF)),
                                            ),
                                            prefixIcon: const Icon(Iconsax.tag, color: Color(0xFF2A62FF)),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextField(
                                          controller: descriptionController,
                                          decoration: InputDecoration(
                                            labelText: 'Description',
                                            labelStyle: TextStyle(color: Colors.grey.shade700),
                                            hintText: 'Brief service description',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: const BorderSide(color: Color(0xFF2A62FF)),
                                            ),
                                            prefixIcon: const Icon(Iconsax.document_text, color: Color(0xFF2A62FF)),
                                          ),
                                          maxLines: 3,
                                        ),
                                        const SizedBox(height: 20),
                                        // Responsive layout for price and unit
                                        if (isMobile) ...[
                                          TextField(
                                            controller: priceController,
                                            decoration: InputDecoration(
                                              labelText: 'Price',
                                              labelStyle: TextStyle(color: Colors.grey.shade700),
                                              hintText: '0.00',
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: const BorderSide(color: Color(0xFF2A62FF)),
                                              ),
                                              prefixIcon: const Icon(Iconsax.dollar_circle, color: Color(0xFF2A62FF)),
                                            ),
                                            keyboardType:
                                            const TextInputType.numberWithOptions(decimal: true),
                                          ),
                                          const SizedBox(height: 20),
                                          DropdownButtonFormField<String>(
                                            value: selectedUnit,
                                            decoration: InputDecoration(
                                              labelText: 'Unit',
                                              labelStyle: TextStyle(color: Colors.grey.shade700),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: const BorderSide(color: Color(0xFF2A62FF)),
                                              ),
                                              prefixIcon: const Icon(Iconsax.ruler, color: Color(0xFF2A62FF)),
                                            ),
                                            items: const [
                                              DropdownMenuItem(
                                                value: 'per lb',
                                                child: Text('per lb'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'per item',
                                                child: Text('per item'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'per load',
                                                child: Text('per load'),
                                              ),
                                            ],
                                            onChanged: (value) => setState(() => selectedUnit = value!),
                                          ),
                                        ] else
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller: priceController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Price',
                                                    labelStyle: TextStyle(color: Colors.grey.shade700),
                                                    hintText: '0.00',
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      borderSide: const BorderSide(color: Color(0xFF2A62FF)),
                                                    ),
                                                    prefixIcon: const Icon(Iconsax.dollar_circle, color: Color(0xFF2A62FF)),
                                                  ),
                                                  keyboardType:
                                                  const TextInputType.numberWithOptions(decimal: true),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: DropdownButtonFormField<String>(
                                                  value: selectedUnit,
                                                  decoration: InputDecoration(
                                                    labelText: 'Unit',
                                                    labelStyle: TextStyle(color: Colors.grey.shade700),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      borderSide: const BorderSide(color: Color(0xFF2A62FF)),
                                                    ),
                                                    prefixIcon: const Icon(Iconsax.ruler, color: Color(0xFF2A62FF)),
                                                  ),
                                                  items: const [
                                                    DropdownMenuItem(
                                                      value: 'per lb',
                                                      child: Text('per lb'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'per item',
                                                      child: Text('per item'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'per load',
                                                      child: Text('per load'),
                                                    ),
                                                  ],
                                                  onChanged: (value) => setState(() => selectedUnit = value!),
                                                ),
                                              ),
                                            ],
                                          ),
                                        const SizedBox(height: 20),
                                        // Responsive layout for duration and category
                                        if (isMobile) ...[
                                          TextField(
                                            controller: durationController,
                                            decoration: InputDecoration(
                                              labelText: 'Duration',
                                              labelStyle: TextStyle(color: Colors.grey.shade700),
                                              hintText: 'e.g., 24 hours',
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: const BorderSide(color: Color(0xFF2A62FF)),
                                              ),
                                              prefixIcon: const Icon(Iconsax.clock, color: Color(0xFF2A62FF)),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          DropdownButtonFormField<String>(
                                            value: selectedCategory,
                                            decoration: InputDecoration(
                                              labelText: 'Category',
                                              labelStyle: TextStyle(color: Colors.grey.shade700),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: const BorderSide(color: Color(0xFF2A62FF)),
                                              ),
                                              prefixIcon: const Icon(Iconsax.category, color: Color(0xFF2A62FF)),
                                            ),
                                            items: const [
                                              DropdownMenuItem(
                                                value: 'Regular',
                                                child: Text('Regular'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'Premium',
                                                child: Text('Premium'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'Express',
                                                child: Text('Express'),
                                              ),
                                            ],
                                            onChanged: (value) => setState(() => selectedCategory = value!),
                                          ),
                                        ] else
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller: durationController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Duration',
                                                    labelStyle: TextStyle(color: Colors.grey.shade700),
                                                    hintText: 'e.g., 24 hours',
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      borderSide: const BorderSide(color: Color(0xFF2A62FF)),
                                                    ),
                                                    prefixIcon: const Icon(Iconsax.clock, color: Color(0xFF2A62FF)),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: DropdownButtonFormField<String>(
                                                  value: selectedCategory,
                                                  decoration: InputDecoration(
                                                    labelText: 'Category',
                                                    labelStyle: TextStyle(color: Colors.grey.shade700),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      borderSide: const BorderSide(color: Color(0xFF2A62FF)),
                                                    ),
                                                    prefixIcon: const Icon(Iconsax.category, color: Color(0xFF2A62FF)),
                                                  ),
                                                  items: const [
                                                    DropdownMenuItem(
                                                      value: 'Regular',
                                                      child: Text('Regular'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'Premium',
                                                      child: Text('Premium'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'Express',
                                                      child: Text('Express'),
                                                    ),
                                                  ],
                                                  onChanged: (value) => setState(() => selectedCategory = value!),
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: closeAddModal,
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          side: const BorderSide(color: Color(0xFF2A62FF)),
                                        ),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Color(0xFF2A62FF)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: addService,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF2A62FF),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: 2,
                                          shadowColor: const Color(0xFF2A62FF).withOpacity(0.3),
                                        ),
                                        child: const Text('Add Service'),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10), // Added extra padding
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (context) {
          final screenWidth = MediaQuery.of(context).size.width;
          final isMobile = screenWidth < 600;

          return isMobile
              ? Padding(
            padding: const EdgeInsets.only(bottom: 16.0), // Added padding for FAB
            child: FloatingActionButton(
              onPressed: openAddModal,
              tooltip: 'Add Service',
              backgroundColor: const Color(0xFF2A62FF),
              child: const Icon(Iconsax.add, color: Colors.white),
            ),
          )
              : const SizedBox.shrink();
        },
      ),
    );
  }

  // Helper function to determine grid column count based on screen width
  int _getGridColumnCount(double screenWidth) {
    if (screenWidth < 600) return 1;
    if (screenWidth < 900) return 2;
    if (screenWidth < 1200) return 3;
    if (screenWidth < 1600) return 4;
    return 5;
  }

  // Helper function to determine grid aspect ratio based on screen width
  double _getGridAspectRatio(double screenWidth) {
    if (screenWidth < 600) return 1.5;
    if (screenWidth < 900) return 1.3;
    if (screenWidth < 1200) return 1.2;
    return 1.1;
  }
}

class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final Color Function(String) getCategoryColor;
  final IconData Function(String) getCategoryIcon;

  const ServiceCard({
    Key? key,
    required this.service,
    required this.onDelete,
    required this.onToggle,
    required this.getCategoryColor,
    required this.getCategoryIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryColor = getCategoryColor(service.category);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with category badge
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  getCategoryIcon(service.category),
                  color: categoryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    service.category,
                    style: TextStyle(
                      color: categoryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Iconsax.more, size: 20),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: const Row(
                        children: [
                          Icon(Iconsax.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      onTap: onDelete,
                      child: const Row(
                        children: [
                          Icon(Iconsax.trash, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Service details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  service.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),

                // Price and duration
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 200;

                    if (isCompact) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCompactInfoItem(
                            icon: Iconsax.dollar_circle,
                            value: '₹${service.price}',
                            subtitle: service.unit,
                            color: categoryColor,
                          ),
                          const SizedBox(height: 8),
                          _buildCompactInfoItem(
                            icon: Iconsax.clock,
                            value: service.duration,
                            subtitle: 'Turnaround',
                            color: categoryColor,
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(
                              icon: Iconsax.dollar_circle,
                              value: '₹${service.price}',
                              subtitle: service.unit,
                              color: categoryColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildInfoItem(
                              icon: Iconsax.clock,
                              value: service.duration,
                              subtitle: 'Turnaround',
                              color: categoryColor,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Status toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status:',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Switch(
                      value: service.active,
                      onChanged: (_) => onToggle(),
                      activeColor: categoryColor,
                      activeTrackColor: categoryColor.withOpacity(0.4),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String value, required String subtitle, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInfoItem({required IconData icon, required String value, required String subtitle, required Color color}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: color.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  bool showAddModal = false;

  List<Map<String, dynamic>> services = [
    {
      'id': 1,
      'name': 'Wash & Fold',
      'description': 'Professional washing and folding service',
      'price': 1.50,
      'unit': 'per lb',
      'duration': '24 hours',
      'category': 'Regular',
      'active': true
    },
    {
      'id': 2,
      'name': 'Dry Cleaning',
      'description': 'Premium dry cleaning for delicate items',
      'price': 8.99,
      'unit': 'per item',
      'duration': '48 hours',
      'category': 'Premium',
      'active': true
    },
    {
      'id': 3,
      'name': 'Wash & Iron',
      'description': 'Washing with professional pressing',
      'price': 2.25,
      'unit': 'per lb',
      'duration': '36 hours',
      'category': 'Regular',
      'active': true
    },
    {
      'id': 4,
      'name': 'Express Wash',
      'description': 'Quick same-day laundry service',
      'price': 2.99,
      'unit': 'per lb',
      'duration': '6 hours',
      'category': 'Express',
      'active': true
    }
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  String selectedUnit = 'per lb';
  String selectedCategory = 'Regular';

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Express':
        return Colors.orange;
      case 'Premium':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  void addService() {
    if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
      setState(() {
        services.add({
          'id': services.length + 1,
          'name': nameController.text,
          'description': descriptionController.text,
          'price': double.tryParse(priceController.text) ?? 0.0,
          'unit': selectedUnit,
          'duration': durationController.text,
          'category': selectedCategory,
          'active': true,
        });
      });

      // Clear form
      nameController.clear();
      descriptionController.clear();
      priceController.clear();
      durationController.clear();
      selectedUnit = 'per lb';
      selectedCategory = 'Regular';

      setState(() {
        showAddModal = false;
      });
    }
  }

  void deleteService(int id) {
    setState(() {
      services.removeWhere((service) => service['id'] == id);
    });
  }

  void toggleServiceStatus(int id) {
    setState(() {
      final index = services.indexWhere((service) => service['id'] == id);
      if (index != -1) {
        services[index]['active'] = !services[index]['active'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Services & Pricing',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Manage your laundry services and pricing structure.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => setState(() => showAddModal = true),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Service'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Services Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  service['description'] as String,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: getCategoryColor(service['category'] as String)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  service['category'] as String,
                                  style: TextStyle(
                                    color: getCategoryColor(service['category'] as String),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              PopupMenuButton(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 16),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, size: 16, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Delete', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    deleteService(service['id'] as int);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            '₹${service['price']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            service['unit'] as String,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            service['duration'] as String,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Status:', style: TextStyle(color: Colors.grey)),
                          GestureDetector(
                            onTap: () => toggleServiceStatus(service['id'] as int),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: service['active'] as bool
                                    ? Colors.green.withValues(alpha: 0.1)
                                    : Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                service['active'] as bool ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  color: service['active'] as bool ? Colors.green : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: showAddModal
          ? null
          : FloatingActionButton(
              onPressed: () => setState(() => showAddModal = true),
              child: const Icon(Icons.add),
            ),
      bottomSheet: showAddModal
          ? Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add New Service',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        onPressed: () => setState(() => showAddModal = false),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Service Name',
                              hintText: 'Enter service name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              hintText: 'Service description',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: priceController,
                                  decoration: const InputDecoration(
                                    labelText: 'Price',
                                    hintText: '0.00',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  initialValue: selectedUnit,
                                  decoration: const InputDecoration(
                                    labelText: 'Unit',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: const [
                                    DropdownMenuItem(value: 'per lb', child: Text('per lb')),
                                    DropdownMenuItem(value: 'per item', child: Text('per item')),
                                    DropdownMenuItem(value: 'per load', child: Text('per load')),
                                  ],
                                  onChanged: (value) => setState(() => selectedUnit = value!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: durationController,
                                  decoration: const InputDecoration(
                                    labelText: 'Duration',
                                    hintText: '24 hours',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  initialValue: selectedCategory,
                                  decoration: const InputDecoration(
                                    labelText: 'Category',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: const [
                                    DropdownMenuItem(value: 'Regular', child: Text('Regular')),
                                    DropdownMenuItem(value: 'Premium', child: Text('Premium')),
                                    DropdownMenuItem(value: 'Express', child: Text('Express')),
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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => setState(() => showAddModal = false),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: addService,
                          child: const Text('Add Service'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : null,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    durationController.dispose();
    super.dispose();
  }
}
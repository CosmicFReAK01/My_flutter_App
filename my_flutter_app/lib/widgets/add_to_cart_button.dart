import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../services/cart_service.dart';

class AddToCartButton extends StatefulWidget {
  final String itemId;
  final String itemName;
  final double price;
  final IconData icon;
  final Color color;
  final String? description;
  final String? category;
  final Widget? child;
  final bool showQuantityControls;

  const AddToCartButton({
    Key? key,
    required this.itemId,
    required this.itemName,
    required this.price,
    required this.icon,
    required this.color,
    this.description,
    this.category,
    this.child,
    this.showQuantityControls = true,
  }) : super(key: key);

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  late CartService _cartService;
  
  @override
  void initState() {
    super.initState();
    _cartService = CartService();
    _cartService.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cartService.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _addToCart() {
    final item = CartItem(
      id: widget.itemId,
      name: widget.itemName,
      price: widget.price,
      icon: widget.icon,
      color: widget.color,
      description: widget.description,
      category: widget.category,
      quantity: 1,
    );
    
    _cartService.addItem(item);
    
    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.itemName} added to cart'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
        backgroundColor: const Color(0xFF4F46E5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isInCart = _cartService.isInCart(widget.itemId);
    final quantity = _cartService.getItemQuantity(widget.itemId);

    if (widget.child != null) {
      return GestureDetector(
        onTap: _addToCart,
        child: widget.child!,
      );
    }

    if (isInCart && widget.showQuantityControls) {
      // Show quantity controls
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF4F46E5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.white, size: 20),
              onPressed: () {
                _cartService.decrementQuantity(widget.itemId);
              },
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 30),
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 20),
              onPressed: () {
                _cartService.incrementQuantity(widget.itemId);
              },
            ),
          ],
        ),
      );
    }

    // Show add to cart button
    return ElevatedButton.icon(
      onPressed: _addToCart,
      icon: Icon(isInCart ? Iconsax.shopping_bag : Iconsax.add_circle),
      label: Text(isInCart ? 'Add More' : 'Add to Cart'),
      style: ElevatedButton.styleFrom(
        backgroundColor: isInCart ? const Color(0xFF10B981) : const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

// Simple Add to Cart Icon Button
class AddToCartIconButton extends StatelessWidget {
  final String itemId;
  final String itemName;
  final double price;
  final IconData icon;
  final Color color;
  final String? description;
  final String? category;

  const AddToCartIconButton({
    Key? key,
    required this.itemId,
    required this.itemName,
    required this.price,
    required this.icon,
    required this.color,
    this.description,
    this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AddToCartButton(
      itemId: itemId,
      itemName: itemName,
      price: price,
      icon: icon,
      color: color,
      description: description,
      category: category,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF4F46E5),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Iconsax.add,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

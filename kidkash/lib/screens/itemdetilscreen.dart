import 'package:flutter/material.dart';
import 'package:kidkash/model/item.dart';
import 'package:kidkash/screens/checkout.dart';

class ItemDetailScreen extends StatefulWidget {
  final Item item;
  final List<Item> cartItems;

  const ItemDetailScreen({
    super.key,
    required this.item,
    required this.cartItems,
  });

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    if (_isItemInCart()) {
      quantity = _getItemQuantityInCart(); // Use existing quantity
    } else {
      quantity = 1; // Start with 1 if not in cart
    }
  }

  bool _isItemInCart() {
    return widget.cartItems.any((cartItem) => cartItem.name == widget.item.name);
  }

  int _getItemQuantityInCart() {
    return widget.cartItems.where((item) => item.name == widget.item.name).length;
  }

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity >= 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _handleCartAction() {
    if (quantity == 0) {
      // Remove item completely from the cart
      widget.cartItems.removeWhere((item) => item.name == widget.item.name);
      print('${widget.item.name} removed from cart');
    } else {
      // Remove all instances of the item and then add the updated quantity
      widget.cartItems.removeWhere((item) => item.name == widget.item.name);
      for (int i = 0; i < quantity; i++) {
        widget.cartItems.add(widget.item);
      }
      print('${widget.item.name} updated in cart with quantity: $quantity');
    }

    setState(() {}); // Refresh UI
  }

  @override
  Widget build(BuildContext context) {
    final bool isInCart = _isItemInCart();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                iconSize: 30,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(cartItems: widget.cartItems),
                    ),
                  );
                },
              ),
              if (widget.cartItems.isNotEmpty)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      widget.cartItems.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              // Image section
              Center(
                child: Image.network(
                  widget.item.imageUrl,
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              // Item name and price
              Text(
                widget.item.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '\$${widget.item.price}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Item Description
              Text(
                'This is a delicious and fresh ${widget.item.name}. It is carefully selected to ensure the highest quality. Perfect for your daily diet or as a snack.',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Quantity selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: _decrementQuantity,
                    color: Colors.green,
                    iconSize: 30,
                  ),
                  Text(
                    'x $quantity ct',
                    style: const TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _incrementQuantity,
                    color: Colors.green,
                    iconSize: 30,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Add to Cart / Remove Button
              ElevatedButton(
                onPressed: _handleCartAction,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.2),
                ),
                child: Text(
                  isInCart && quantity == 0
                      ? 'Remove'
                      : isInCart
                          ? 'Change Quantity'
                          : 'Add to Cart',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}










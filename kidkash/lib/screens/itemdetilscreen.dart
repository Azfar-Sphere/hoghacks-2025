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
    if (_isItemInCart()) {
      // Allow quantity to go down to 0 if item is already in cart
      if (quantity > 0) {
        setState(() {
          quantity--;
        });
      }
    } else {
      // Don't allow going below 1 if item not in cart
      if (quantity > 1) {
        setState(() {
          quantity--;
        });
      }
    }
  }

  void _handleCartAction() {
  if (quantity == 0) {
    widget.cartItems.removeWhere((item) => item.name == widget.item.name);
    print('${widget.item.name} removed from cart');
  } else {
    widget.cartItems.removeWhere((item) => item.name == widget.item.name);
    for (int i = 0; i < quantity; i++) {
      widget.cartItems.add(widget.item);
    }
    print('${widget.item.name} updated in cart with quantity: $quantity');
  }

  // Don't navigate away — just refresh the state
  setState(() {}); // Optional: triggers UI update if needed
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              widget.item.imageUrl,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              widget.item.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('\$${widget.item.price}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),

            // Quantity selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _decrementQuantity,
                ),
                Text(
                  'x $quantity ct',
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _incrementQuantity,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action button
            ElevatedButton(
              onPressed: _handleCartAction,
              child: Text(
                isInCart
                    ? (quantity == 0 ? 'Remove' : 'Change Quantity')
                    : 'Add to Cart',
              ),
            ),
          ],
        ),
      ),
    );
  }
}





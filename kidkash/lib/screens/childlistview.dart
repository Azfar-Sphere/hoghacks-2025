import 'package:flutter/material.dart';
import 'package:kidkash/model/item.dart'; // Import the Item model

class ListViewScreen extends StatelessWidget {
  final List<Item> cartItems; // List of items passed from CheckoutPage

  // Constructor to accept cartItems
const ListViewScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requested Items'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length, // Display number of cart items
        itemBuilder: (context, index) {
          Item item = cartItems[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 3,
            child: ListTile(
              leading: Image.network(
                item.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(item.name), // Display item name
              subtitle: Text('Price: \$${item.price.toStringAsFixed(2)}'), // Display item price
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('You tapped ${item.name}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


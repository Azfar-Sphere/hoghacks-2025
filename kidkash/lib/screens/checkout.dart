import 'package:flutter/material.dart';
import 'package:kidkash/model/item.dart'; // Import the Item model

class CheckoutPage extends StatelessWidget {
  final List<Item> cartItems; // List of items in the cart

  CheckoutPage({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    // Group items by name
    Map<String, List<Item>> groupedItems = {};
    
    for (var item in cartItems) {
      if (groupedItems.containsKey(item.name)) {
        groupedItems[item.name]?.add(item);
      } else {
        groupedItems[item.name] = [item];
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SafeArea(
        child: ListView(
          children: groupedItems.entries.map((entry) {
            String itemName = entry.key;
            List<Item> items = entry.value;

            // Calculate quantity and total price
            int quantity = items.length;
            double totalPrice = (items[0].price * quantity).toDouble(); // Cast to double

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              child: ListTile(
                leading: Image.network(
                  items[0].imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(itemName),
                subtitle: Text('Quantity: x$quantity'),
                trailing: Text('\$${totalPrice.toStringAsFixed(2)}'),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}



void main() {
  runApp(MaterialApp(
    home: CheckoutPage(cartItems: []), // Empty cart for now
  ));
}

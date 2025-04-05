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

    final bool isCartEmpty = cartItems.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          Expanded(
            child: isCartEmpty
                ? const Center(
                    child: Text(
                      'Your cart is empty.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(10),
                    children: groupedItems.entries.map((entry) {
                      String itemName = entry.key;
                      List<Item> items = entry.value;

                      int quantity = items.length;
                      double totalPrice = items[0].price * quantity.toDouble();

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 3,
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                if (isCartEmpty) {
                  Navigator.pop(context);
                } else {
                  // Show a SnackBar or any confirmation without navigation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Purchase requested!'),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  // Optional: Perform any additional action here
                  // For example, you could update Firestore or make an API request
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isCartEmpty ? Colors.red : Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isCartEmpty ? 'Close Cart' : 'Request Purchase',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



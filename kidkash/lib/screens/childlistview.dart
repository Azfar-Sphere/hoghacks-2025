import 'package:flutter/material.dart';
import 'package:kidkash/model/item.dart'; // Import the Item model
import 'package:kidkash/screens/video_capture_screen.dart'; // Import VideoCaptureScreen

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
      // Bottom button to navigate to VideoCaptureScreen
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VideoCaptureScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Go to Video Capture',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

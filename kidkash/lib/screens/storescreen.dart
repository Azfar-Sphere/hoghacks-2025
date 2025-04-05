import 'package:flutter/material.dart';
import 'package:kidkash/model/item.dart';
import 'package:kidkash/screens/itemdetilscreen.dart' show ItemDetailScreen;
import 'package:kidkash/screens/checkout.dart' show CheckoutPage;

// Dummy data for groceries
final List<Item> dummyItems = [
  Item(name: 'Apple', imageUrl: 'https://img.freepik.com/free-psd/close-up-delicious-apple_23-2151868338.jpg?t=st=1743840562~exp=1743844162~hmac=d63d02e2207b10bee84b54ef5a5321534ddc3c5ef10f173b79ade03d8a189a5b&w=740', price: 100),
  Item(name: 'Banana', imageUrl: 'https://media.istockphoto.com/id/173242750/photo/banana-bunch.jpg?s=612x612&w=0&k=20&c=MAc8AXVz5KxwWeEmh75WwH6j_HouRczBFAhulLAtRUU=', price: 120),
  Item(name: 'Orange', imageUrl: 'https://img.freepik.com/free-photo/orange-fruit-isolated-white-background_1203-6782.jpg?t=st=1743843300~exp=1743846900~hmac=e3bae841da750fab353650ba399d73ff9235a9504807efdd9cbb694c60c154a1&w=740', price: 150),
  Item(name: 'Grapes', imageUrl: 'https://img.freepik.com/premium-photo/grapes-white-background_181303-4423.jpg?w=996', price: 200),
  Item(name: 'Carrot', imageUrl: 'https://img.freepik.com/premium-photo/carrot-isolated-white-background-heap-sweet-carrots_362171-901.jpg?w=826', price: 80),
  Item(name: 'Tomato', imageUrl: 'https://static4.depositphotos.com/1017505/320/i/600/depositphotos_3201839-stock-photo-three-tomatoes.jpg', price: 90),
  Item(name: 'Cucumber', imageUrl: 'https://static4.depositphotos.com/1006650/292/i/600/depositphotos_2928714-stock-photo-fresh-green-cucumber.jpg', price: 110),
  Item(name: 'Lettuce', imageUrl: 'https://img.freepik.com/premium-photo/head-iceberg-lettuce-isolated-white_696657-9073.jpg?w=740', price: 130),
  Item(name: 'Potato', imageUrl: 'https://img.freepik.com/free-photo/autumn-potatoes-nutrition-nature-diet_1203-6025.jpg?t=st=1743843526~exp=1743847126~hmac=a4bfa6f54c434043e474ff0da14f99567544e7339929baae860a37d35df31496&w=996', price: 70),
  Item(name: 'Onion', imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Onion_white_background.jpg/960px-Onion_white_background.jpg', price: 60),
];

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  // List to keep track of the cart
  List<Item> cartItems = [];

  // Function to add item to cart
  void _addToCart(Item item) {
    setState(() {
      cartItems.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Grocery Store';

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
        actions: [
          Stack(
            clipBehavior: Clip.none, // Allows the badge to extend outside the stack
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                iconSize: 35.0, // Adjust the size of the cart icon
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(cartItems: cartItems),
                    ),
                  );
                },
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      cartItems.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(5),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two items per row
            crossAxisSpacing: 2,
            mainAxisSpacing: 10,
          ),
          itemCount: dummyItems.length,
          itemBuilder: (context, index) {
            return _buildItemCard(context, dummyItems[index]);
          },
        ),
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, Item item) {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailScreen(
              item: item,
              cartItems: cartItems, // passing cart items by reference
            ),
          ),
        );
        setState(() {}); // Refresh UI after coming back from item details
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50, // Adjust the height of the image container
            width: 50, // Full width
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(height: 1),
          Text(item.name,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 1),
          Text('\$${item.price}',
              style: const TextStyle(fontSize: 14, color: Colors.green)),
          const SizedBox(height: 1),
          Text('16 oz', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 1),
          Padding(
            padding: const EdgeInsets.only(bottom: 1), // Add some padding at the bottom
            child: IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.green),
              iconSize: 30.0,
              onPressed: () {
                _addToCart(item);
                print('${item.name} added to cart');
              },
            ),
          ),
        ],
      ),
    ),
  );
}

}

void main() {
  runApp(MaterialApp(
    home: StoreScreen(),
  ));
}

import 'package:flutter/material.dart';
import 'package:kidkash/screens/itemdetilscreen.dart';

class Item {
  final String name;
  final String imageUrl;
  final int price;

  const Item({required this.name, required this.imageUrl, required this.price});
}

final List<Item> dummyItems = [
  Item(name: 'Hat', imageUrl: 'https://via.placeholder.com/150', price: 100),
  Item(name: 'Shoes', imageUrl: 'https://via.placeholder.com/150', price: 200),
];

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Grid List';

    return Scaffold(
      appBar: AppBar(title: const Text(title)),
      body: SafeArea(
        child: GridView.count(
          crossAxisCount: 2,
          children:
              dummyItems.map((item) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailScreen(item: item),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          item.imageUrl,
                          height: 80,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                        ),
                        Text(item.name),
                        Text('${item.price} coins'),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}

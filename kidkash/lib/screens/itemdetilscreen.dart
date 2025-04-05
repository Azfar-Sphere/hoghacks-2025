import 'package:flutter/material.dart';
import 'storescreen.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              item.imageUrl,
              height: 150,
              errorBuilder:
                  (context, error, stackTrace) => const Icon(Icons.error),
            ),
            const SizedBox(height: 16),
            Text(item.name, style: const TextStyle(fontSize: 24)),
            Text('${item.price} coins', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Camera or Firestore logic here
              },
              child: const Text('Buy'),
            ),
          ],
        ),
      ),
    );
  }
}

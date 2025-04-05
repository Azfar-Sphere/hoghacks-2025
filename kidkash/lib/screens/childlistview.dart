import 'package:flutter/material.dart';

class ListViewScreen extends StatelessWidget {
  const ListViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Item 5',
      'Item 6',
      'Item 7',
      'Item 8',
      'Item 9',
      'Item 10',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Request List'),
      ),
      body: ListView.builder(
        itemCount: items.length, // Number of items in the list
        itemBuilder: (context, index) {
          // Building each list item
          return ListTile(
            leading: Icon(Icons.camera_alt), // Icon at the beginning of each item

            title: Text(items[index]), // The text of the list item
            subtitle: Text('Subtitle for ${items[index]}'), // Optional subtitle
            onTap: () {
              // Action when the list item is tapped
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('You tapped ${items[index]}')),
              );
            },
          );
        },
      ),
    );
  }
}

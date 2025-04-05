import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestTriggerScreen extends StatelessWidget {
  const RequestTriggerScreen({super.key});

  Future<void> sendPurchaseRequest() async {
    final parentId = 'parent123'; // replace with real UID
    final kidId = 'kid456'; // replace with real UID

    final item = {'name': 'Hat', 'price': 100};

    await FirebaseFirestore.instance.collection('purchase_requests').add({
      'parentId': parentId,
      'kidId': kidId,
      'item': item, // 👈 now just a single item
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trigger Purchase')),
      body: Center(
        child: ElevatedButton(
          onPressed: sendPurchaseRequest,
          child: const Text('Send Purchase Request'),
        ),
      ),
    );
  }
}

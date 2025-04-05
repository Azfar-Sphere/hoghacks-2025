import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kidkash/screens/video_capture_screen.dart';

class KidListenerScreen extends StatelessWidget {
  final String kidId = 'kid456'; // Replace with actual kid's session ID

  const KidListenerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Approvals')),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('purchase_requests')
                .where('kidId', isEqualTo: kidId)
                .where('status', isEqualTo: 'pending')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading requests'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No pending requests'));
          }

          final doc = snapshot.data!.docs.first;
          final data = doc.data() as Map<String, dynamic>;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Item: ${data['item']['name']}'),
                Text('Price: ${data['item']['price']} coins'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VideoCaptureScreen(),
                      ),
                    );
                  },
                  child: const Text('Approve with Nod'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

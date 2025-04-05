import 'package:flutter/material.dart';
import 'package:kidkash/screens/childlistview.dart';
import 'package:kidkash/screens/itemdetilscreen.dart';
import 'package:kidkash/screens/storescreen.dart' show StoreScreen;

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light background
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertically centered content
          children: [
            // Green header with title
            Container(
              width: double.infinity,
              height: 120,
              color: const Color(0xFF43A047),
              child: const Center(
                child: Text(
                  'KidKash',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),

            // Large logo
            const SizedBox(height: 40),
            Image.asset(
              'images/kidKash.png',
              height: 180, // Increased logo size
            ),
            const SizedBox(height: 40),

            // Welcome message
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Start your journey with KidKash.\nChoose your login type:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Login Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  _buildLoginButton(
                    label: 'I am a Parent',
                    icon: Icons.person_outline,
                    onPressed: () {
                      print(" adult button pressed");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoreScreen(),
                        ),
                      );
                 },

                  ),
                  const SizedBox(height: 16),
                  _buildLoginButton(
                    label: 'I am a Kid',
                    icon: Icons.child_care,
                    onPressed: () {
                      print("Kid Button pressed");
                      Navigator.push(
                      context,
                      MaterialPageRoute(
        builder: (context) => ListViewScreen(cartItems: []),  // Pass an empty list as dummy value
                      ),
                    );
                  },

                  ),
                ],
              ),
            ),

            const Spacer(),

            // Footer
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(
                '© 2025 KidKash Inc.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable login button builder with styling
  static Widget _buildLoginButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 24),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF43A047),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        elevation: 6,
        shadowColor: Colors.black26,
      ),
    );
  }
}




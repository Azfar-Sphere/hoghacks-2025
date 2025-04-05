// start_screen.dart

import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo image
            Image.asset('images/kidKash.png', height: 150, width: 150),
            SizedBox(height: 20),
            Text(
              'Welcome to KidKash!\nYour new way of buying!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 132, 173, 243),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            // Buttons for "Adult" and "Child" login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Use backgroundColor instead of primary
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/adultLogin');
                  },
                  child: Text('Adult'),
                ),
                SizedBox(width: 20), // Space between the buttons
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Use backgroundColor instead of primary
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/childlistview.dart');
                  },
                  child: Text('Child'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

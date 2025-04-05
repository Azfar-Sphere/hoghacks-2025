import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:kidkash/screens/storescreen.dart'; // Ensure this import is correct
import 'package:kidkash/screens/requestTrigger.dart';
import 'package:kidkash/screens/kid_listener_screen.dart';
import 'package:kidkash/screens/childlistview.dart';
import 'package:kidkash/screens/startscreen.dart';
import 'package:kidkash/screens/video_capture_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KidKash',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const StartScreen(), // Changed this to StoreScreen
    );
  }
}

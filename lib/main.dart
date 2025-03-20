import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shop_easee/firebase_options.dart';
import 'package:shop_easee/screens/splash_screen.dart'; // Import SplashScreen

void  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop-easee',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 159, 218, 120),
          brightness: Brightness.dark,
          surface: const Color.fromARGB(239, 81, 162, 6),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 241, 241, 239),

        iconTheme: const IconThemeData(
          color: Colors.green,  
          size: 28, 
        ),
      ),
      home: SplashScreen(), // Show splash screen first
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/splash_screen.dart';
import 'services/hive_service.dart';

void main() async {
  // this line - entry point of the app, initializes Hive and runs the app
  WidgetsFlutterBinding.ensureInitialized(); // ensures Flutter bindings are initialized before any async operations
  await Hive.initFlutter(); // initializes Hive for Flutter
  await HiveService.init(); // initializes the HiveService which opens the scores box -> this line- redirects to HiveService.init() in lib/services/hive_service.dart
  runApp(const QuizApp()); // calls quiz app which is the root widget of the app
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
          titleTextStyle: TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 4,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // calls the splash screen which is the first screen of the app -> this line - redirects to SplashScreen in lib/screens/splash_screen.dart
    );
  }
}

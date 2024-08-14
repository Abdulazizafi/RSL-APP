import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:football_app/constants.dart';
import 'package:football_app/screens/main_screen.dart';
import 'dart:async';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "TitilliumWeb",
        scaffoldBackgroundColor: kbackgroundColor,
        appBarTheme: const AppBarTheme(color: kbackgroundColor),
        colorScheme: ColorScheme.fromSeed(
          seedColor: kprimaryColor,
          background: kbackgroundColor,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/file_0bfae61b-c268-48f2-9476-268a438e946c.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

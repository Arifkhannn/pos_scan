import 'package:flutter/material.dart';
import 'package:pos_scan/API/product_details_api.dart';
import 'package:pos_scan/screens/home_screen.dart';
import 'package:pos_scan/screens/register_screen.dart';
import 'package:pos_scan/services/getAppKey.dart';
import 'package:pos_scan/services/unique_code_generator.dart';

import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  String uniqueCode =await getAppKey();


  
  
  print("Unique Code: $uniqueCode");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // instance of api class
  final apiRegister = ProductDetailsApi();

  @override
  void initState() {
    super.initState();
   

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration of the animation
    );

    // Define fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Define scale animation
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Start the animation
    _controller.forward();

    // Redirect to HomeScreen after the animation is complete
    Future.delayed(const Duration(seconds: 3), ()async {
     
      int? loginValue = await getLoginValue();
    if (loginValue == 0 || loginValue == null) {
      // Navigate to Register Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      // Navigate to Login Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  });
    }
  
  
  

  

  Future<int?> getLoginValue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int? loginValue = pref.getInt('login_value');
    return loginValue;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset('assets/Auctech-logo.png')),
            const SizedBox(height: 0),
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Text(
                "Ⓐⓤⓒⓣⓔⓒⓗ",
                style: TextStyle(fontSize: 34, color: Colors.yellowAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}


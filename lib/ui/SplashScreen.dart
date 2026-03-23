import 'package:flutter/material.dart';
import 'package:project/data/DataManager.dart';
import 'package:project/ui/homme_screen/HomeScreen.dart';

// Initial loading screen displayed during app startup, used to pre-load API data before transitioning to the Home screen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _loadAndNavigate();
  }

  // Handles data initialization and introduces a brief artificial delay before navigating to the main app interface.
  Future<void> _loadAndNavigate() async {
    await DataManager().loadPokemonList(151, 0);

    if (!mounted) return;

    await Future.delayed(const Duration(seconds: 3));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Homescreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3B4CCA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/pokeball.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
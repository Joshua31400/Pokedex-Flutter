import 'package:flutter/material.dart';
import '../../data/DataManager.dart';
import 'responsive/MobileContent_Home.dart';
import 'responsive/TabletteContent_Home.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3350D),
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/pokeball.png', width: 32, height: 32),
            const SizedBox(width: 12),
            const Text(
              "Poké Tracker",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/images/pokeball.png',
                width: 250,
                height: 250,
              ),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 767) {
                  return MobileContentHome(pokemons: DataManager().pokemonList);
                } else {
                  return TabletteContentHome(pokemons: DataManager().pokemonList);
                }
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: const Color(0xFF313131),
        child: const Text(
          "© Realised by Pedro MARTINS & Joshua BUDGEN",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ),
    );
  }
}
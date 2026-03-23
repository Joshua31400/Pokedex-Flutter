import 'package:flutter/material.dart';
import '../../data/DataManager.dart';
import 'responsive/MobileContent_Home.dart';
import 'responsive/TabletteContent_Home.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B4CCA),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/pokeball.png', width: 36, height: 36),
            const SizedBox(width: 8),
            Text(
              "Poke Tracker",
              style: const TextStyle(color: Colors.white, fontSize: 40),
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 767) {
            return MobileContentHome(pokemons: DataManager().pokemonList);
          } else {
            return TabletteContentHome(pokemons: DataManager().pokemonList);
          }
        },
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        color: const Color(0xFF3B4CCA),
        child: Text(
          "Realised by Pedro MARTINS & Joshua BUDGEN",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }
}

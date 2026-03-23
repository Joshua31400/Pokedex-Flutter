import 'package:flutter/material.dart';
import 'package:project/models/Pokemon.dart';
import 'responsive/MobileContent_Pokemon.dart';
import 'responsive/TabletteContent_Pokemon.dart';

class PokemonScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonScreen({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B4CCA),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/pokeball.png'),
        ),
        title: Text(
          pokemon.name,
          style: const TextStyle(color: Colors.white, fontSize: 40),
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 767) {
            return MobileContentPokemon(pokemon: pokemon);
          } else {
            return TabletteContentPokemon(pokemon: pokemon);
          }
        },
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        color: const Color(0xFF3B4CCA),
        child: const Text(
          "Realised by Pedro MARTINS & Joshua BUDGEN",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }
}
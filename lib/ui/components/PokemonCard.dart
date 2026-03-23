import 'package:flutter/material.dart';
import 'package:project/models/Pokemon.dart';

import '../pokemon_screen/PokemonScreen.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Image.network(
          pokemon.imageUrl,
          width: 56,
          height: 56,
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.catching_pokemon, size: 40),
        ),
        title: Text(
          pokemon.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text("# ${pokemon.id.toString().padLeft(3, '0')}"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PokemonScreen(pokemon: pokemon),
            ),
          );
        },
      ),
    );
  }
}
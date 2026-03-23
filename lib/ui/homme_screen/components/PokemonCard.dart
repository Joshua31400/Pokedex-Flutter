import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PokemonCard extends StatelessWidget {
  final dynamic pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(pokemon.name),
        subtitle: Text("Pokemon ID: ${pokemon.id}"),
        leading: Image.network(pokemon.imageUrl),
      ),
    );
  }
}
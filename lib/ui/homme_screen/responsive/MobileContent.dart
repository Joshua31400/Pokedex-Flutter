import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/PokemonCard.dart';

class MobileContent extends StatelessWidget {
  final List<dynamic> pokemons;

  const MobileContent({super.key, required this.pokemons});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 20),

          const Text(
            "Welcome to our App You can see here all infos about Pokemon. \n"
            "Good navigation !",
            style: TextStyle(
              color: const Color(0xFFFFCB05),
              fontSize: 20,
            ),
          ),

          SizedBox(height: 20),

          TextField(
            decoration: InputDecoration(hintText: "Search for a Pokemon ..."),
          ),

          SizedBox(height: 20),

          ListView.builder(
            itemCount: pokemons.length,
            itemBuilder: (context, index) {
              return PokemonCard(pokemon: pokemons[index]);
            }
          ),
        ],
      ),
    );
  }
}

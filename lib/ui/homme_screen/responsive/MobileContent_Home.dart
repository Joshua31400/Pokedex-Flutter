import 'package:flutter/material.dart';
import 'package:project/models/Pokemon.dart';

import '../../components/PokemonCard.dart';

class MobileContentHome extends StatefulWidget {
  final List<Pokemon> pokemons;

  const MobileContentHome({super.key, required this.pokemons});

  @override
  State<MobileContentHome> createState() => _MobileContentState();
}

class _MobileContentState extends State<MobileContentHome> {
  String _searchQuery = '';

  List<Pokemon> get _filteredPokemons {
    if (_searchQuery.isEmpty) return widget.pokemons;
    return widget.pokemons
        .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Search for a Pokemon...",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                  });
                },
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),

        // Pokemon list
        Expanded(
          child: _filteredPokemons.isEmpty
              ? const Center(
            child: Text(
              "No Pokemon found",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: _filteredPokemons.length,
            itemBuilder: (context, index) {
              return PokemonCard(pokemon: _filteredPokemons[index]);
            },
          ),
        ),
      ],
    );
  }
}
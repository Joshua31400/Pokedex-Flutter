import 'package:flutter/material.dart';
import 'package:project/models/Pokemon.dart';

import '../../components/PokemonCard.dart';

class TabletteContentHome extends StatefulWidget {
  final List<Pokemon> pokemons;

  const TabletteContentHome({super.key, required this.pokemons});

  @override
  State<TabletteContentHome> createState() => _TabletteContentState();
}

class _TabletteContentState extends State<TabletteContentHome> {
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
        // Header
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "Welcome to our App! You can see here all infos about Pokemon.\nGood navigation!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFFFCB05),
              fontSize: 20,
            ),
          ),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
          child: TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: "Search for a Pokemon...",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => setState(() => _searchQuery = ''),
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

        // Pokemon grid
        Expanded(
          child: _filteredPokemons.isEmpty
              ? const Center(
            child: Text(
              "No Pokemon found",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
              : GridView.builder(
            padding: const EdgeInsets.all(24.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3,
            ),
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
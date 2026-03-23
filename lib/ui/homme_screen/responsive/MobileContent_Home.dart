import 'package:flutter/material.dart';
import 'package:project/models/Pokemon.dart';
import '../../components/PokemonCard.dart';

// Mobile-specific home view featuring a searchable vertical list of Pokémon.
class MobileContentHome extends StatefulWidget {
  final List<Pokemon> pokemons;

  const MobileContentHome({super.key, required this.pokemons});

  @override
  State<MobileContentHome> createState() => _MobileContentState();
}

class _MobileContentState extends State<MobileContentHome> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<Pokemon> get _filteredPokemons {
    if (_searchQuery.isEmpty) return widget.pokemons;
    return widget.pokemons
        .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Search for a Pokemon...",
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: const Icon(Icons.search, color: Color(0xFFE3350D)),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
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
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: _filteredPokemons.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: PokemonCard(pokemon: _filteredPokemons[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
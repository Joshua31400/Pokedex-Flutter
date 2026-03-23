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
          padding: const EdgeInsets.fromLTRB(32.0, 24.0, 32.0, 8.0),
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
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(32.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.5,
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
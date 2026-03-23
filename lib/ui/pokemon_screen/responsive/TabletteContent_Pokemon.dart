import 'package:flutter/material.dart';
import 'package:project/models/Pokemon.dart';
import 'package:audioplayers/audioplayers.dart';

class TabletteContentPokemon extends StatefulWidget {
  final Pokemon pokemon;

  const TabletteContentPokemon({super.key, required this.pokemon});

  @override
  State<TabletteContentPokemon> createState() => _TabletteContentPokemonState();
}

class _TabletteContentPokemonState extends State<TabletteContentPokemon>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() => _playingIndex = null);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleCry(int index, String url) async {
    if (_playingIndex == index) {
      await _audioPlayer.stop();
      setState(() => _playingIndex = null);
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(url));
      setState(() => _playingIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pokemon = widget.pokemon;

    return Column(
      children: [
        // TabBar
        TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF3B4CCA),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF3B4CCA),
          labelStyle:
          const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: "Info"),
            Tab(text: "Abilities"),
            Tab(text: "Cries"),
          ],
        ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // ── Onglet Info ──────────────────────────────────────
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 48.0, vertical: 24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Colonne gauche : image + types + weight/height
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Image.network(
                            pokemon.imageUrl,
                            height: 220,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.catching_pokemon,
                                size: 140),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            pokemon.name,
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "# ${pokemon.id.toString().padLeft(3, '0')}",
                            style: const TextStyle(
                                fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),

                          // Types
                          if (pokemon.types != null &&
                              pokemon.types!.isNotEmpty) ...[
                            const Text("Types",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: pokemon.types!
                                  .map((t) => Image.network(t.imageUrl,
                                  height: 48,
                                  errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.help_outline)))
                                  .toList(),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Weight & Height
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              _infoChip(Icons.monitor_weight, "Weight",
                                  "${pokemon.weight ?? 'N/A'} kg"),
                              _infoChip(Icons.height, "Height",
                                  "${pokemon.height ?? 'N/A'} m"),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 32),

                    // Colonne droite : stats + évolutions
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Stats",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          _statBar("HP", pokemon.hp, Colors.green),
                          _statBar(
                              "Attack", pokemon.attack, Colors.red),
                          _statBar(
                              "Defense", pokemon.defense, Colors.blue),
                          _statBar(
                              "Speed", pokemon.speed, Colors.orange),
                          const SizedBox(height: 28),

                          // Evolutions
                          if (pokemon.evolutions != null &&
                              pokemon.evolutions!.isNotEmpty) ...[
                            const Text("Evolutions",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            _evolutionChain(pokemon.evolutions!),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Onglet Abilities ─────────────────────────────────
              pokemon.abilities == null || pokemon.abilities!.isEmpty
                  ? const Center(
                  child: Text("No abilities available",
                      style: TextStyle(
                          fontSize: 18, color: Colors.grey)))
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 48.0, vertical: 16.0),
                itemCount: pokemon.abilities!.length,
                itemBuilder: (context, index) {
                  final ability = pokemon.abilities![index];
                  return Card(
                    margin:
                    const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      leading: const Icon(Icons.bolt,
                          color: Color(0xFF3B4CCA), size: 32),
                      title: Text(ability.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      subtitle: Text(ability.description,
                          style: const TextStyle(fontSize: 15)),
                    ),
                  );
                },
              ),

              // ── Onglet Cries ─────────────────────────────────────
              pokemon.cries == null || pokemon.cries!.isEmpty
                  ? const Center(
                  child: Text("No cries available",
                      style: TextStyle(
                          fontSize: 18, color: Colors.grey)))
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 48.0, vertical: 16.0),
                itemCount: pokemon.cries!.length,
                itemBuilder: (context, index) {
                  final isPlaying = _playingIndex == index;
                  return Card(
                    margin:
                    const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      leading: Icon(
                        isPlaying
                            ? Icons.stop_circle
                            : Icons.play_circle,
                        color: const Color(0xFF3B4CCA),
                        size: 48,
                      ),
                      title: Text("Cry ${index + 1}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      subtitle: Text(
                        isPlaying ? "Playing..." : "Tap to play",
                        style: TextStyle(
                            fontSize: 14,
                            color: isPlaying
                                ? const Color(0xFF3B4CCA)
                                : Colors.grey),
                      ),
                      onTap: () => _toggleCry(
                          index, pokemon.cries![index]),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoChip(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF3B4CCA), size: 36),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(fontSize: 14, color: Colors.grey)),
        Text(value,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _statBar(String label, int? value, Color color) {
    final double percent =
    value != null ? (value / 255).clamp(0.0, 1.0) : 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15)),
          ),
          SizedBox(
            width: 42,
            child: Text(
              value?.toString() ?? 'N/A',
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 14,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _evolutionChain(List<Pokemon> evolutions) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: evolutions.asMap().entries.map((entry) {
          final index = entry.key;
          final evo = entry.value;
          return Row(
            children: [
              if (index > 0)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward,
                      color: Colors.grey, size: 28),
                ),
              Column(
                children: [
                  Image.network(
                    evo.imageUrl,
                    height: 90,
                    errorBuilder: (_, __, ___) => const Icon(
                        Icons.catching_pokemon,
                        size: 70),
                  ),
                  Text(evo.name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  Text(
                    "# ${evo.id.toString().padLeft(3, '0')}",
                    style: const TextStyle(
                        fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

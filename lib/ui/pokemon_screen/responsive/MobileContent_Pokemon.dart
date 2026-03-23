import 'package:flutter/material.dart';
import 'package:project/models/Pokemon.dart';
import 'package:audioplayers/audioplayers.dart';

class MobileContentPokemon extends StatefulWidget {
  final Pokemon pokemon;

  const MobileContentPokemon({super.key, required this.pokemon});

  @override
  State<MobileContentPokemon> createState() => _MobileContentPokemonState();
}

class _MobileContentPokemonState extends State<MobileContentPokemon>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Reset l'index quand l'audio se termine
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image
                    Image.network(
                      pokemon.imageUrl,
                      height: 250,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.catching_pokemon, size: 100),
                    ),
                    const SizedBox(height: 12),

                    // Nom + ID
                    Text(
                      pokemon.name,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "# ${pokemon.id.toString().padLeft(3, '0')}",
                      style:
                      const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),

                    // Types
                    if (pokemon.types != null && pokemon.types!.isNotEmpty) ...[
                      const Text("Types",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: pokemon.types!
                            .map((t) => Image.network(t.imageUrl,
                            height: 40,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.help_outline)))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Weight & Height
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _infoChip(
                            Icons.monitor_weight, "Weight",
                            "${pokemon.weight ?? 'N/A'} hectograms"),
                        _infoChip(
                            Icons.height, "Height",
                            "${pokemon.height ?? 'N/A'} decimeters"),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Stats
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Stats",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    _statBar("HP", pokemon.hp, Colors.green),
                    _statBar("Attack", pokemon.attack, Colors.red),
                    _statBar("Defense", pokemon.defense, Colors.blue),
                    _statBar("Speed", pokemon.speed, Colors.orange),
                    const SizedBox(height: 20),

                    // Evolutions
                    if (pokemon.evolutions != null &&
                        pokemon.evolutions!.isNotEmpty) ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Evolutions",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      _evolutionChain(pokemon.evolutions!),
                    ],
                  ],
                ),
              ),

              // ── Onglet Abilities ─────────────────────────────────
              pokemon.abilities == null || pokemon.abilities!.isEmpty
                  ? const Center(
                  child: Text("No abilities available",
                      style:
                      TextStyle(fontSize: 16, color: Colors.grey)))
                  : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: pokemon.abilities!.length,
                itemBuilder: (context, index) {
                  final ability = pokemon.abilities![index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: const Icon(Icons.bolt,
                          color: Color(0xFF3B4CCA)),
                      title: Text(ability.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      subtitle: Text(ability.description),
                    ),
                  );
                },
              ),

              // ── Onglet Cries ─────────────────────────────────────
              pokemon.cries == null || pokemon.cries!.isEmpty
                  ? const Center(
                  child: Text("No cries available",
                      style:
                      TextStyle(fontSize: 16, color: Colors.grey)))
                  : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: pokemon.cries!.length,
                itemBuilder: (context, index) {
                  final isPlaying = _playingIndex == index;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: Icon(
                        isPlaying
                            ? Icons.stop_circle
                            : Icons.play_circle,
                        color: const Color(0xFF3B4CCA),
                        size: 40,
                      ),
                      title: Text("Cry ${index + 1}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      subtitle: Text(
                        isPlaying ? "Playing..." : "Tap to play",
                        style: TextStyle(
                            color: isPlaying
                                ? const Color(0xFF3B4CCA)
                                : Colors.grey),
                      ),
                      onTap: () =>
                          _toggleCry(index, pokemon.cries![index]),
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
        Icon(icon, color: const Color(0xFF3B4CCA), size: 28),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _statBar(String label, int? value, Color color) {
    final double percent = value != null ? (value / 255).clamp(0.0, 1.0) : 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          SizedBox(
            width: 36,
            child: Text(
              value?.toString() ?? 'N/A',
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 10,
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
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.arrow_forward,
                      color: Colors.grey, size: 20),
                ),
              Column(
                children: [
                  Image.network(
                    evo.imageUrl,
                    height: 70,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.catching_pokemon, size: 50),
                  ),
                  Text(evo.name,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  Text(
                    "# ${evo.id.toString().padLeft(3, '0')}",
                    style: const TextStyle(
                        fontSize: 11, color: Colors.grey),
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
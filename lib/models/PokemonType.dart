// Data model representing a Pokémon type, including its icon URL and lists of its damage relations (strengths and weaknesses).

class PokemonType {
  final String imageUrl;
  List<PokemonType>? weaknesses;
  List<PokemonType>? strengths;

  PokemonType({
    required this.imageUrl,
    this.weaknesses,
    this.strengths,
  });

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'weaknesses': weaknesses?.map((w) => w.toJson()).toList(),
      'strengths': strengths?.map((s) => s.toJson()).toList(),
    };
  }

  factory PokemonType.fromJson(Map<String, dynamic> json) {
    return PokemonType(
      imageUrl: json['imageUrl'],
      weaknesses: json['weaknesses'] != null
          ? (json['weaknesses'] as List).map((w) => PokemonType.fromJson(w)).toList()
          : null,
      strengths: json['strengths'] != null
          ? (json['strengths'] as List).map((s) => PokemonType.fromJson(s)).toList()
          : null,
    );
  }

}
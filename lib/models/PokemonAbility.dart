// Data model representing a specific Pokémon ability and its text description.

class PokemonAbility {
  final String name;
  final String description;

  PokemonAbility({
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    return PokemonAbility(
      name: json['name'],
      description: json['description'],
    );
  }

}
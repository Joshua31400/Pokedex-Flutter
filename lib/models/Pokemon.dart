import 'package:project/models/PokemonAbility.dart';
import 'package:project/models/PokemonType.dart';

// Core data model representing a Pokémon, including its stats, types, abilities, and evolution chain.
// Includes JSON serialization for caching.
class Pokemon {
  final int id;
  final String imageUrl;

  final String name;
  List<PokemonType>? types;

  final int? weight;
  final int? height;

  List<String>? cries;
  List<PokemonAbility>? abilities;
  List<Pokemon>? evolutions;

  final int? hp;
  final int? attack;
  final int? defense;
  final int? speed;

  Pokemon({
    required this.id,
    required this.imageUrl,

    required this.name,
    this.types,

    this.weight,
    this.height,

    this.cries,
    this.abilities,
    this.evolutions,

    this.hp,
    this.attack,
    this.defense,
    this.speed,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'types': types?.map((t) => t.toJson()).toList(),
      'weight': weight,
      'height': height,
      'cries': cries,
      'abilities': abilities?.map((a) => a.toJson()).toList(),
      'evolutions': evolutions?.map((e) => e.toJson()).toList(),
      'hp': hp,
      'attack': attack,
      'defense': defense,
      'speed': speed,
    };
  }

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      imageUrl: json['imageUrl'],
      name: json['name'],
      types: json['types'] != null
          ? (json['types'] as List).map((t) => PokemonType.fromJson(t)).toList()
          : null,
      weight: json['weight'],
      height: json['height'],
      cries: json['cries'] != null ? List<String>.from(json['cries']) : null,
      abilities: json['abilities'] != null
          ? (json['abilities'] as List).map((a) => PokemonAbility.fromJson(a)).toList()
          : null,
      evolutions: json['evolutions'] != null
          ? (json['evolutions'] as List).map((e) => Pokemon.fromJson(e)).toList()
          : null,
      hp: json['hp'],
      attack: json['attack'],
      defense: json['defense'],
      speed: json['speed'],
    );
  }

  void printDetails() {
    print('================================================================');
    print('POKEMON #$id: ${name.toUpperCase()}');
    print('================================================================');

    print('📸 Image URL: $imageUrl');
    print('⚖️  Weight: ${weight ?? "N/A"} kg');
    print('📏 Height: ${height ?? "N/A"} m');

    print('\n--- STATS ---');
    print('❤️  HP: ${hp ?? "N/A"}');
    print('⚔️  Attack: ${attack ?? "N/A"}');
    print('🛡️  Defense: ${defense ?? "N/A"}');
    print('⚡ Speed: ${speed ?? "N/A"}');

    print('\n--- TYPES (${types?.length ?? 0}) ---');
    if (types != null && types!.isNotEmpty) {
      for (int i = 0; i < types!.length; i++) {
        final type = types![i];
        print('Type ${i + 1}:');
        print('  Image: ${type.imageUrl}');
        print('  Weaknesses: ${type.weaknesses?.length ?? 0}');
        if (type.weaknesses != null && type.weaknesses!.isNotEmpty) {
          for (int j = 0; j < type.weaknesses!.length; j++) {
            print('    ${j + 1}. ${type.weaknesses![j].imageUrl}');
          }
        }
        print('  Strengths: ${type.strengths?.length ?? 0}');
        if (type.strengths != null && type.strengths!.isNotEmpty) {
          for (int j = 0; j < type.strengths!.length; j++) {
            print('    ${j + 1}. ${type.strengths![j].imageUrl}');
          }
        }
      }
    } else {
      print('No types available');
    }

    print('\n--- ABILITIES (${abilities?.length ?? 0}) ---');
    if (abilities != null && abilities!.isNotEmpty) {
      for (int i = 0; i < abilities!.length; i++) {
        final ability = abilities![i];
        print('${i + 1}. ${ability.name}');
        print('   Description: ${ability.description}');
      }
    } else {
      print('No abilities available');
    }

    print('\n--- CRIES (${cries?.length ?? 0}) ---');
    if (cries != null && cries!.isNotEmpty) {
      for (int i = 0; i < cries!.length; i++) {
        print('${i + 1}. ${cries![i]}');
      }
    } else {
      print('No cries available');
    }

    print('\n--- EVOLUTIONS (${evolutions?.length ?? 0}) ---');
    if (evolutions != null && evolutions!.isNotEmpty) {
      for (int i = 0; i < evolutions!.length; i++) {
        final evo = evolutions![i];
        print('${i + 1}. #${evo.id} - ${evo.name}');
        print('   Image: ${evo.imageUrl}');
      }
    } else {
      print('No evolutions available');
    }

    print('\n================================================================\n');
  }
}
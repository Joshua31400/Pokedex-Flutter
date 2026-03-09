import 'package:project/models/PokemonAbility.dart';
import 'package:project/models/PokemonType.dart';

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
}
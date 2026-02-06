import 'package:project/models/PokemonAbility.dart';
import 'package:project/models/PokemonType.dart';

class Pokemon {
  final int id;
  final String imageUrl;

  final String name;
  final PokemonType type;

  final double weight;
  final double height;

  final List<String> cries;
  final List<PokemonAbility> abilities;

  final int hp;
  final int attack;
  final int defense;
  final int speed;



  Pokemon({
    required this.id,
    required this.imageUrl,

    required this.name,
    required this.type,

    required this.weight,
    required this.height,

    required this.cries,
    required this.abilities,

    required this.hp,
    required this.attack,
    required this.defense,
    required this.speed,
  });


}
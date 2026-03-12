import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/models/PokemonAbility.dart';
import '../models/Pokemon.dart';
import '../models/PokemonType.dart';

class ApiService {
  final String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> fetchPokemonList(int limit, int offset) async {
    List<Pokemon> pokemonList = [];

    final response = await http.get(
      Uri.parse('$baseUrl/pokemon?limit=$limit&offset=$offset'),
    );
    final data = json.decode(response.body);
    final List results = data['results'];

    for (var result in results) {
      try {
        final pokemonResponse = await http.get(Uri.parse(result['url']));
        final pokemonData = json.decode(pokemonResponse.body);

        Pokemon pokemon = Pokemon(
          id: pokemonData['id'],
          name: pokemonData['name'] ?? 'Unknown',
          imageUrl: pokemonData['sprites']['front_default'] ?? '',
          weight: pokemonData['weight'],
          height: pokemonData['height'],
          cries: [
            pokemonData['cries']?['legacy'] ?? '',
            pokemonData['cries']?['latest'] ?? ''
          ],
          hp: pokemonData['stats'][0]['base_stat'],
          attack: pokemonData['stats'][1]['base_stat'],
          defense: pokemonData['stats'][2]['base_stat'],
          speed: pokemonData['stats'][5]['base_stat'],
        );

        pokemon.types = await _extractTypes(pokemonData['types']);
        pokemon.abilities = await _extractAbilities(pokemonData['abilities']);
        pokemon.evolutions = await _extractEvolutions(pokemonData['species']['url']);

        pokemonList.add(pokemon);
      } catch (e) {
        print('Error fetching pokemon: $e');
      }
    }
    return pokemonList;
  }

  Future<List<PokemonType>> _extractTypes(List types) async {
    List<PokemonType> pokemonTypes = [];
    for (var type in types) {
      List<PokemonType> weaknesses = [];
      List<PokemonType> strengths = [];
      final typeResponse = await http.get(Uri.parse(type['type']['url']));
      final typeData = json.decode(typeResponse.body);

      PokemonType pokemonType = PokemonType(
        imageUrl: typeData['sprites']['generation-viii']['legends-arceus']['name_icon'],
        weaknesses: [],
        strengths: [],
      );

      for (var doubleDamageFrom in typeData['damage_relations']['double_damage_from']) {
        final damageFromResponse = await http.get(Uri.parse(doubleDamageFrom['url']));
        final damageFromData = json.decode(damageFromResponse.body);
        weaknesses.add(PokemonType(
          imageUrl: damageFromData['sprites']['generation-viii']['legends-arceus']['name_icon'],
        ));
      }

      for (var doubleDamageTo in typeData['damage_relations']['double_damage_to']) {
        final damageToResponse = await http.get(Uri.parse(doubleDamageTo['url']));
        final damageToData = json.decode(damageToResponse.body);
        strengths.add(PokemonType(
          imageUrl: damageToData['sprites']['generation-viii']['legends-arceus']['name_icon'],
        ));
      }

      for (var halfDamageFrom in typeData['damage_relations']['half_damage_from']) {
        final damageFromResponse = await http.get(Uri.parse(halfDamageFrom['url']));
        final damageFromData = json.decode(damageFromResponse.body);
        strengths.add(PokemonType(
          imageUrl: damageFromData['sprites']['generation-viii']['legends-arceus']['name_icon'],
        ));
      }

      for (var halfDamageTo in typeData['damage_relations']['half_damage_to']) {
        final damageToResponse = await http.get(Uri.parse(halfDamageTo['url']));
        final damageToData = json.decode(damageToResponse.body);
        weaknesses.add(PokemonType(
          imageUrl: damageToData['sprites']['generation-viii']['legends-arceus']['name_icon'],
        ));
      }

      for (var noDamageFrom in typeData['damage_relations']['no_damage_from']) {
        final damageFromResponse = await http.get(Uri.parse(noDamageFrom['url']));
        final damageFromData = json.decode(damageFromResponse.body);
        strengths.add(PokemonType(
          imageUrl: damageFromData['sprites']['generation-viii']['legends-arceus']['name_icon'],
        ));
      }

      for (var noDamageTo in typeData['damage_relations']['no_damage_to']) {
        final damageToResponse = await http.get(Uri.parse(noDamageTo['url']));
        final damageToData = json.decode(damageToResponse.body);
        weaknesses.add(PokemonType(
          imageUrl: damageToData['sprites']['generation-viii']['legends-arceus']['name_icon'],
        ));
      }

      pokemonType.weaknesses = weaknesses;
      pokemonType.strengths = strengths;
      pokemonTypes.add(pokemonType);
    }
    return pokemonTypes;
  }

  Future<List<PokemonAbility>> _extractAbilities(List abilities) async {
    List<PokemonAbility> pokemonAbilities = [];
    for (var ability in abilities) {
      final abilityResponse = await http.get(Uri.parse(ability['ability']['url']));
      final abilityData = json.decode(abilityResponse.body);
      pokemonAbilities.add(PokemonAbility(
        name: abilityData['name'],
        description: abilityData['effect_entries'][2]['effect'],
      ));
    }
    return pokemonAbilities;
  }

  Future<List<Pokemon>> _extractEvolutions(String speciesUrl) async {
    List<Pokemon> evolutions = [];

    final speciesResponse = await http.get(Uri.parse(speciesUrl));
    final speciesData = json.decode(speciesResponse.body);

    final evolutionChainUrl = speciesData['evolution_chain']['url'];
    final evolutionResponse = await http.get(Uri.parse(evolutionChainUrl));
    final evolutionData = json.decode(evolutionResponse.body);

    final evolutionIds = _extractEvolutionIds(evolutionData['chain']);

    for (var id in evolutionIds) {
      final pokemonResponse = await http.get(Uri.parse('$baseUrl/pokemon/$id'));
      final pokemonData = json.decode(pokemonResponse.body);

      evolutions.add(Pokemon(
        id: pokemonData['id'],
        name: pokemonData['name'],
        imageUrl: pokemonData['sprites']['front_default'],
      ));
    }

    return evolutions;
  }

  List<int> _extractEvolutionIds(Map<String, dynamic> chain) {
    List<int> ids = [];

    final speciesUrl = chain['species']['url'] as String;
    final id = int.parse(speciesUrl.split('/')[speciesUrl.split('/').length - 2]);
    ids.add(id);

    final evolvesTo = chain['evolves_to'] as List;
    for (var evolution in evolvesTo) {
      ids.addAll(_extractEvolutionIds(evolution));
    }
    return ids;
  }
}

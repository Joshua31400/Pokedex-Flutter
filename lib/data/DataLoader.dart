import 'package:project/data/CacheService.dart';
import 'package:project/models/Pokemon.dart';
import 'ApiService.dart';

class DataLoader {

  List<Pokemon> pokemonList = [];

  Future<void> loadPokemonList() async {
    CacheService cache = CacheService();
    await cache.init();

    bool isCacheValid = await cache.isValid();

    if (isCacheValid) {
      List<Pokemon> pokemonList = await cache.loadPokemonList() ?? [];
      this.pokemonList = pokemonList;
    } else {
      List<Pokemon> pokemonList = await ApiService().fetchPokemonList(151, 0);
      await cache.clearCache();
      await cache.savePokemonList(pokemonList);
      this.pokemonList = pokemonList;
    }
  }

  Pokemon getPokemonById(int id) {
    return pokemonList.firstWhere((pokemon) => pokemon.id == id);
  }
}
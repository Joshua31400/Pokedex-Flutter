import 'package:project/data/CacheService.dart';
import 'package:project/models/Pokemon.dart';
import 'ApiService.dart';

class DataLoader {
  Future<List<Pokemon>> loadPokemonList() async {
    CacheService cache = CacheService();
    await cache.init();

    bool isCacheValid = await cache.isValid();

    if (isCacheValid) {
      List<Pokemon> pokemonList = await cache.loadPokemonList() ?? [];
      return pokemonList;
    } else {
      List<Pokemon> pokemonList = await ApiService().fetchPokemonList(151, 0);
      await cache.clearCache();
      await cache.savePokemonList(pokemonList);
      return pokemonList;
    }
  }
}
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:project/models/Pokemon.dart';

class CacheService {
  String _cacheFilePath = '';
  File _cacheFile = File('');

  final Duration _cacheExpiration = Duration(days: 3);

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final dataDir = Directory('${directory.path}/data');

    if (!await dataDir.exists()) {
      await dataDir.create(recursive: true);
    }

    _cacheFilePath = '${dataDir.path}/pokemon_cache.json';
    _cacheFile = File(_cacheFilePath);

    if (!await _cacheFile.exists()) {
      await _cacheFile.create();
      print('Cache file created!');
    }
  }

  Future<void> savePokemonList(List<Pokemon> pokemonList) async {
    try {
      final pokemonMaps = pokemonList.map((p) => p.toJson()).toList();

      final cacheData = {
        'timestamp': DateTime.now().toIso8601String(),
        'data': pokemonMaps,
      };

      await _cacheFile.writeAsString(json.encode(cacheData));
      print('Cache saved successfully!');
    } catch (e) {
      print('Error saving cache: $e');
    }
  }

  Future<List<Pokemon>?> loadPokemonList() async {
    try {
      final contents = await _cacheFile.readAsString();
      final cacheData = json.decode(contents);

      final pokemonMaps = cacheData['data'] as List;
      final pokemonList = pokemonMaps.map((map) => Pokemon.fromJson(map)).toList();

      print('Cache loaded successfully!');
      return pokemonList;
    } catch (e) {
      print('Error loading cache: $e');
      return null;
    }
  }

  Future<void> clearCache() async {
    try {
      await _cacheFile.writeAsString('');
      print('Cache clean!');
    } catch (e) {
      print('Error cleaning cache: $e');
    }
  }

  Future<bool> isValid() async {
    try {
      final contents = await _cacheFile.readAsString();
      final cacheData = json.decode(contents);

      if (cacheData.isEmpty || cacheData['timestamp'] == null) {
        return false;
      }

      final timestamp = DateTime.parse(cacheData['timestamp']);

      return DateTime.now().difference(timestamp) <= _cacheExpiration;
    } catch (e) {
      return false;
    }
  }
}
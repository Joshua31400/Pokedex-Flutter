class PokemonType {
  final String name;
  final List<PokemonType> weaknesses;
  final List<PokemonType> strengths;

  PokemonType({
    required this.name,
    required this.weaknesses,
    required this.strengths,
  });
}
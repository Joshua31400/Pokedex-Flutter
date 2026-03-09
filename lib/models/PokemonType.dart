class PokemonType {
  final String imageUrl;
  List<PokemonType>? weaknesses;
  List<PokemonType>? strengths;

  PokemonType({
    required this.imageUrl,
    this.weaknesses,
    this.strengths,
  });
}
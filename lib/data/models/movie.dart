import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie {
  final int id;
  final String title;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  final String overview;
  @JsonKey(name: 'release_date')
  final String releaseDate;
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  @JsonKey(name: 'vote_count')
  final int voteCount;
  @JsonKey(name: 'genre_ids')
  final List<int> genreIds;
  final double popularity;
  @JsonKey(name: 'original_language')
  final String originalLanguage;
  @JsonKey(name: 'original_title')
  final String originalTitle;
  final bool adult;
  final bool video;

  Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds,
    required this.popularity,
    required this.originalLanguage,
    required this.originalTitle,
    required this.adult,
    required this.video,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'overview': overview,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'genre_ids': genreIds.join(','),
      'popularity': popularity,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'adult': adult ? 1 : 0,
      'video': video ? 1 : 0,
    };
  }

  factory Movie.fromDatabase(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      posterPath: map['poster_path'],
      backdropPath: map['backdrop_path'],
      overview: map['overview'],
      releaseDate: map['release_date'],
      voteAverage: map['vote_average'],
      voteCount: map['vote_count'],
      genreIds: (map['genre_ids'] as String).split(',').map(int.parse).toList(),
      popularity: map['popularity'],
      originalLanguage: map['original_language'],
      originalTitle: map['original_title'],
      adult: map['adult'] == 1,
      video: map['video'] == 1,
    );
  }
}

@JsonSerializable()
class MovieResponse {
  final int page;
  final List<Movie> results;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_results')
  final int totalResults;

  MovieResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}
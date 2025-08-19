import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../core/constants/api_constants.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';
part 'api_service.g.dart';

@RestApi(baseUrl: 'https://api.themoviedb.org/3')
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET(ApiConstants.trending)
  Future<MovieResponse> getTrendingMovies(
      @Query('api_key') String apiKey,
      @Query('page') int page);

  @GET(ApiConstants.nowPlaying)
  Future<MovieResponse> getNowPlayingMovies(
      @Query('api_key') String apiKey,
      @Query('page') int page);

  @GET(ApiConstants.searchMovies)
  Future<MovieResponse> searchMovies(
      @Query('api_key') String apiKey,
      @Query('query') String query,
      @Query('page') int page);

  @GET(ApiConstants.movieDetails)
  Future<MovieDetail> getMovieDetail(
      @Path('id') int id,
      @Query('api_key') String apiKey);
}
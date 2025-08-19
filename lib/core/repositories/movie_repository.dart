import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/network/api_service.dart';
import '../../data/models/movie.dart';
import '../../data/models/movie_detail.dart';
import '../../data/network/retry_interceptor.dart';
import '../database/database_helper.dart';
import '../constants/api_constants.dart';

class MovieRepository {
  late final ApiService _apiService;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final Connectivity _connectivity = Connectivity();

  MovieRepository() {
    final dio = Dio();
    dio.interceptors.add(RetryOnConnectionChangeInterceptor(dio));
    _apiService = ApiService(dio);
  }

  Future<bool> _hasInternetConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    final hasInternet = connectivityResult != ConnectivityResult.none;
    print('Connectivity check → $connectivityResult (hasInternet: $hasInternet)');
    return hasInternet;
  }

  Future<List<Movie>> getTrendingMovies() async {
    print('Fetching trending movies...');
    try {
      if (await _hasInternetConnection()) {
        print('Online: fetching trending movies from API');
        final response = await _apiService.getTrendingMovies(
          ApiConstants.apiKey,
          1,
        );
        for (final movie in response.results) {
          await _databaseHelper.insertMovie(movie, 'trending');
        }
        print('Fetched ${response.results.length} trending movies from API');
        return response.results;
      } else {
        print('Offline: fetching trending movies from local DB');
        return await _databaseHelper.getMoviesByCategory('trending');
      }
    } catch (e) {
      print('Error fetching trending movies: $e → fallback to local DB');
      return await _databaseHelper.getMoviesByCategory('trending');
    }
  }

  Future<List<Movie>> getNowPlayingMovies() async {
    print('Fetching now playing movies...');
    try {
      if (await _hasInternetConnection()) {
        print('Online: fetching now playing movies from API');
        final response = await _apiService.getNowPlayingMovies(
          ApiConstants.apiKey,
          1,
        );
        for (final movie in response.results) {
          await _databaseHelper.insertMovie(movie, 'now_playing');
        }
        print('Fetched ${response.results.length} now playing movies from API');
        return response.results;
      } else {
        print('Offline: fetching now playing movies from local DB');
        return await _databaseHelper.getMoviesByCategory('now_playing');
      }
    } catch (e) {
      print('Error fetching now playing movies: $e → fallback to local DB');
      return await _databaseHelper.getMoviesByCategory('now_playing');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    print('Searching movies for query: "$query"');
    try {
      if (await _hasInternetConnection()) {
        print('Online: searching movies from API');
        final response = await _apiService.searchMovies(
          ApiConstants.apiKey,
          query,
          1,
        );

        for (final movie in response.results) {
          await _databaseHelper.insertMovie(movie, 'search');
        }

        print('Found ${response.results.length} movies for query "$query"');
        return response.results;
      } else {
        print('Offline: cannot search, returning empty list');
        return [];
      }
    } catch (e) {
      print('Error searching movies: $e → returning empty list');
      return [];
    }
  }

  Future<MovieDetail?> getMovieDetail(int id) async {
    try {
      if (await _hasInternetConnection()) {
        return await _apiService.getMovieDetail(id, ApiConstants.apiKey);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> addBookmark(int movieId) async {
    try {
      await _databaseHelper.addBookmark(movieId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeBookmark(int movieId) async {
    print('Removing bookmark for movieId=$movieId');
    try {
      await _databaseHelper.removeBookmark(movieId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isBookmarked(int movieId) async {
    final bookmarked = await _databaseHelper.isBookmarked(movieId);
    return bookmarked;
  }

  Future<List<Movie>> getBookmarkedMovies() async {
    final bookmarks = await _databaseHelper.getBookmarkedMovies();
    return bookmarks;
  }
}

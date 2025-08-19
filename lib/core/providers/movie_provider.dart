import 'package:flutter/material.dart';

import '../../data/models/movie.dart';
import '../repositories/movie_repository.dart';

class MovieProvider extends ChangeNotifier {
  final MovieRepository _repository = MovieRepository();

  List<Movie> _trendingMovies = [];
  List<Movie> _nowPlayingMovies = [];
  bool _isLoading = true;
  String? _error;

  List<Movie> get trendingMovies => _trendingMovies;
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTrendingMovies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _trendingMovies = await _repository.getTrendingMovies();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNowPlayingMovies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _nowPlayingMovies = await _repository.getNowPlayingMovies();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    await Future.wait([
      loadTrendingMovies(),
      loadNowPlayingMovies(),
    ]);
  }
}
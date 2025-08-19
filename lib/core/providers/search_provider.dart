import 'dart:async';

import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../repositories/movie_repository.dart';

class SearchProvider extends ChangeNotifier {
  final MovieRepository _repository = MovieRepository();
  List<Movie> _searchResults = [];
  bool _isLoading = false;
  String _currentQuery = '';
  Timer? _debounceTimer;
  List<Movie> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get currentQuery => _currentQuery;

  void searchMovies(String query) {
    _currentQuery = query;

    if (query.isEmpty) {
      _searchResults.clear();
      notifyListeners();
      return;
    }
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 1000), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    _isLoading = true;
    print(query);
    notifyListeners();
    try {
      _searchResults = await _repository.searchMovies(query);
      print("Success $_searchResults");
    } catch (e) {
      _searchResults = [];
      print("Catch $e");
    } finally {
      print("Finally");
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults.clear();
    _currentQuery = '';
    _debounceTimer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

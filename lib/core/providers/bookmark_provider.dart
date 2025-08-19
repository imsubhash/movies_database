import 'package:flutter/foundation.dart';
import '../repositories/movie_repository.dart';
import '../../data/models/movie.dart';

class BookmarkProvider extends ChangeNotifier {
  final MovieRepository _repository = MovieRepository();

  List<Movie> _bookmarkedMovies = [];
  bool _isLoading = false;
  List<Movie> get bookmarkedMovies => _bookmarkedMovies;
  bool get isLoading => _isLoading;

  Future<void> loadBookmarkedMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      _bookmarkedMovies = await _repository.getBookmarkedMovies();
    } catch (e, stack) {
      if (kDebugMode) {
        print('Failed to load bookmarked movies: $e');
        print(stack);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleBookmark(int movieId) async {
    try {
      final isBookmarked = await _repository.isBookmarked(movieId);

      if (isBookmarked) {
        await _repository.removeBookmark(movieId);
      } else {
        await _repository.addBookmark(movieId);
      }
      await loadBookmarkedMovies();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isBookmarked(int movieId) async {
    return await _repository.isBookmarked(movieId);
  }
}

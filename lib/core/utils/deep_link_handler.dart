import 'package:flutter/material.dart';
import '../../core/repositories/movie_repository.dart';
import '../../presentation/pages/movie_detail_page.dart';
import '../database/database_helper.dart';

class DeepLinkHandler {

  static Future<void> handleMovieLink(BuildContext context, String movieId) async {
    try {
      final repository = MovieRepository();
      final id = int.parse(movieId);

      final movie = await DatabaseHelper.instance.getMovieById(id);

      if (movie != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(movie: movie),
          ),
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Loading movie...'),
              ],
            ),
          ),
        );
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Movie not found in local database'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid movie link'),
        ),
      );
    }
  }
}
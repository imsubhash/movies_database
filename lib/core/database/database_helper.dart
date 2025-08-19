import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../data/models/movie.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('movies.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE movies (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        poster_path TEXT,
        backdrop_path TEXT,
        overview TEXT NOT NULL,
        release_date TEXT NOT NULL,
        vote_average REAL NOT NULL,
        vote_count INTEGER NOT NULL,
        genre_ids TEXT NOT NULL,
        popularity REAL NOT NULL,
        original_language TEXT NOT NULL,
        original_title TEXT NOT NULL,
        adult INTEGER NOT NULL,
        video INTEGER NOT NULL,
        category TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY,
        movie_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (movie_id) REFERENCES movies (id)
      )
    ''');
  }

  Future<int> insertMovie(Movie movie, String category) async {
    final db = await instance.database;
    final movieData = movie.toDatabase();
    movieData['category'] = category;

    return await db.insert(
      'movies',
      movieData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Movie>> getMoviesByCategory(String category) async {
    final db = await instance.database;
    final result = await db.query(
      'movies',
      where: 'category = ?',
      whereArgs: [category],
    );

    return result.map((json) => Movie.fromDatabase(json)).toList();
  }

  Future<Movie?> getMovieById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'movies',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Movie.fromDatabase(result.first);
    }
    return null;
  }

  Future<int> addBookmark(int movieId) async {
    final db = await instance.database;
    return await db.insert('bookmarks', {
      'movie_id': movieId,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<int> removeBookmark(int movieId) async {
    final db = await instance.database;
    return await db.delete(
      'bookmarks',
      where: 'movie_id = ?',
      whereArgs: [movieId],
    );
  }

  Future<bool> isBookmarked(int movieId) async {
    final db = await instance.database;
    final result = await db.query(
      'bookmarks',
      where: 'movie_id = ?',
      whereArgs: [movieId],
    );
    return result.isNotEmpty;
  }

  Future<List<Movie>> getBookmarkedMovies() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT m.* FROM movies m
      INNER JOIN bookmarks b ON m.id = b.movie_id
      ORDER BY b.created_at DESC
    ''');

    return result.map((json) => Movie.fromDatabase(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

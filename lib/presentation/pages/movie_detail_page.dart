import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/movie.dart';
import '../../data/models/movie_detail.dart';
import '../../core/repositories/movie_repository.dart';
import '../../core/providers/bookmark_provider.dart';
import '../../core/constants/api_constants.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final MovieRepository _repository = MovieRepository();
  MovieDetail? _movieDetail;
  bool _isLoading = true;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _loadMovieDetail();
    _checkBookmarkStatus();
  }

  Future<void> _loadMovieDetail() async {
    try {
      final detail = await _repository.getMovieDetail(widget.movie.id);
      setState(() {
        _movieDetail = detail;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkBookmarkStatus() async {
    final isBookmarked = await _repository.isBookmarked(widget.movie.id);
    setState(() {
      _isBookmarked = isBookmarked;
    });
  }

  Future<void> _toggleBookmark() async {
    final success = await context
        .read<BookmarkProvider>()
        .toggleBookmark(widget.movie.id);

    if (success) {
      setState(() {
        _isBookmarked = !_isBookmarked;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isBookmarked
                ? 'Added to bookmarks'
                : 'Removed from bookmarks',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _shareMovie() {
    final movieUrl = 'moviesapp://movie/${widget.movie.id}';
    Share.share(
      'Check out this movie: ${widget.movie.title}\n\n${widget.movie.overview}\n\n$movieUrl',
      subject: 'Movie Recommendation: ${widget.movie.title}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.movie.backdropPath != null
                  ? CachedNetworkImage(
                imageUrl: ApiConstants.originalImageBaseUrl +
                    widget.movie.backdropPath!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[800],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[800],
                  child: const Icon(Icons.error),
                ),
              )
                  : Container(
                color: Colors.grey[800],
                child: const Icon(
                  Icons.movie,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                onPressed: _toggleBookmark,
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: _shareMovie,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.movie.voteAverage.toStringAsFixed(1)}/10',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.movie.releaseDate,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  if (_movieDetail != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_movieDetail!.runtime} min',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (_movieDetail?.tagline.isNotEmpty == true) ...[
                    Text(
                      _movieDetail!.tagline,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    'Overview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.movie.overview,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.justify,
                  ),
                  if (_movieDetail != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Genres',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _movieDetail!.genres.map((genre) {
                        return Chip(
                          label: Text(genre.name),
                          backgroundColor: Theme.of(context).colorScheme.surface,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Production Companies',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._movieDetail!.productionCompanies.map((company) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '• ${company.name}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }).toList(),
                  ],
                  if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
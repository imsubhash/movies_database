import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/movie_provider.dart';
import '../widgets/movie_section.dart';
import '../widgets/app_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Movies'),
      body: RefreshIndicator(
        onRefresh: () => context.read<MovieProvider>().refreshData(),
        child: Consumer<MovieProvider>(
          builder: (context, movieProvider, child) {
            if (movieProvider.isLoading &&
                movieProvider.trendingMovies.isEmpty &&
                movieProvider.nowPlayingMovies.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MovieSection(
                    title: 'Trending Now',
                    movies: movieProvider.trendingMovies,
                  ),
                  const SizedBox(height: 24),
                  MovieSection(
                    title: 'Now Playing',
                    movies: movieProvider.nowPlayingMovies,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
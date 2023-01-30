import 'package:flutter/material.dart';
import 'package:movies_research/providers/movies_services.dart';
import 'package:movies_research/search/search_delegate.dart';
import 'package:movies_research/widgets/widgets_export.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Variables

  @override
  Widget build(BuildContext context) {
    // Variables
    final moviesProvider = Provider.of<MoviesServices>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas en cine'),
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context,
              delegate: MovieSearchDelegate(),
            ),
            icon: const Icon(Icons.search_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            CardSwiperCustom(movies: moviesProvider.onMoviePlaying),
            const SizedBox(height: 20),
            MovieSliderWidget(
              movies: moviesProvider.onMoviePopular,
              onNextPage: moviesProvider.getPopular,
              title: 'Populares',
            ),
          ],
        ),
      ),
    );
  }
}

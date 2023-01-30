import 'package:flutter/material.dart';
import 'package:movies_research/models/_export_models.dart';
// import 'package:provider/provider.dart';

import 'package:movies_research/themes/app_theme.dart';

// import 'package:movies_research/providers/movies_services.dart';
import 'package:movies_research/widgets/widgets_export.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  // Variables

  @override
  Widget build(BuildContext context) {
    // variables
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    // final int movieId = ModalRoute.of(context)!.settings.arguments as int;
    // final moviesProvider = Provider.of<MoviesServices>(context);
    // MovieDetailResponse movieDetails = moviesProvider.getMovieDetails(movieId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(title: movie.title, img: movie.fullBackdropImg),
          SliverList(
              delegate: SliverChildListDelegate([
            _PosterAndTitle(movie: movie),
            const SizedBox(height: 15),
            _Overview(overview: movie.overview),
            const SizedBox(height: 15),
            CastingCards(movieId: movie.id),
          ]))
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final String title;
  final String img;

  const _CustomAppBar({
    required this.title,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppTheme.primary,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(0),
        centerTitle: true,
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 12, left: 10, right: 10),
          color: Colors.black12,
          child: Text(
            title,
            style: const TextStyle(fontSize: 18),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          image: NetworkImage(img),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;

  const _PosterAndTitle({required this.movie});

  @override
  Widget build(BuildContext context) {
    // Variables
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg),
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: textTheme.headlineSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  movie.originalTitle,
                  style: textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Row(
                  children: [
                    const Icon(Icons.star_border_outlined, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      '${movie.voteAverage}',
                      style: textTheme.bodySmall,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final String overview;

  const _Overview({
    required this.overview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        overview,
        style: Theme.of(context).textTheme.titleMedium,
        textAlign: TextAlign.justify,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movies_research/providers/movies_services.dart';
import 'package:movies_research/models/_export_models.dart';

class MovieSearchDelegate extends SearchDelegate {
  // Sobrescribir el label por default
  @override
  String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    query = '';
    return _emptyContainer();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesServices>(context, listen: false);
    moviesProvider.getSuggestionsByQuery(query);

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (_, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _emptyContainer('No encontrado');
        }

        final List<Movie> movies = snapshot.data!;
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (_, int i) => _MovieItem(movie: movies[i]),
        );
      },
    );
  }
}

Widget _emptyContainer([String? title]) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.movie_creation_outlined,
          color: Colors.black38,
          size: 150,
        ),
        if (title != null) Text(title, style: const TextStyle(fontSize: 28)),
      ],
    ),
  );
}

class _MovieItem extends StatelessWidget {
  const _MovieItem({
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    // Theme
    final TextTheme textTheme = Theme.of(context).textTheme;
    movie.heroId = 'movieItem-${movie.id}';

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        'details',
        arguments: movie,
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(movie.fullBackdropImg),
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
        ),
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
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 250,
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
                  const SizedBox(height: 10),
                  Text(
                    movie.overview,
                    style: textTheme.titleMedium,
                    textAlign: TextAlign.justify,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

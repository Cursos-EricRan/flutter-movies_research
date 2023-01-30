import 'package:flutter/material.dart';
import 'package:movies_research/models/_export_models.dart';

class MovieSliderWidget extends StatefulWidget {
  final List<Movie> movies;
  final Function onNextPage;
  final String? title;

  const MovieSliderWidget({
    super.key,
    required this.movies,
    required this.onNextPage,
    this.title,
  });

  @override
  State<MovieSliderWidget> createState() => _MovieSliderWidgetState();
}

class _MovieSliderWidgetState extends State<MovieSliderWidget> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      final position = scrollController.position.pixels;
      final maxPosition = scrollController.position.maxScrollExtent;

      if (position + 500 <= maxPosition) return;

      widget.onNextPage();
      scrollController.animateTo(
        scrollController.position.pixels + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        height: 280,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (widget.title != null)
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Text('Populares',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      )),
                )
              : const SizedBox(height: 25),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, index) => _MoviePoster(
                movie: widget.movies[index],
                heroId: '${widget.title}-$index-${widget.movies[index].id}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  // Variables
  final Movie movie;
  final String heroId;

  const _MoviePoster({
    required this.movie,
    required this.heroId,
  });

  @override
  Widget build(BuildContext context) {
    movie.heroId = heroId;

    return Container(
      width: 130,
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              'details',
              arguments: movie,
            ),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

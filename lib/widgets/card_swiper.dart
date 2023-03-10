import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:movies_research/models/_export_models.dart';

class CardSwiperCustom extends StatelessWidget {
  final List<Movie> movies;
  const CardSwiperCustom({Key? key, required this.movies}) : super(key: key);

  // Variables

  @override
  Widget build(BuildContext context) {
    // Variables
    final size = MediaQuery.of(context).size;

    if (movies.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: size.height * 0.5,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.7,
        itemBuilder: (_, index) {
          final movie = movies[index];
          movie.heroId = 'CardSwiperCustom-${movie.id}';

          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              'details',
              arguments: movies[index],
            ),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

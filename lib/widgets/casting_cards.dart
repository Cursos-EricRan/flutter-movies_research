import 'package:flutter/cupertino.dart';
import 'package:movies_research/models/_export_models.dart';
import 'package:movies_research/providers/movies_services.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  final int movieId;
  const CastingCards({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesServices>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getCredits(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        // Validación
        if (!snapshot.hasData) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 150),
            height: 180,
            child: const CupertinoActivityIndicator(),
          );
        }

        final List<Cast> castList = snapshot.data!;

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          width: double.infinity,
          height: 180,
          child: ListView.builder(
            itemCount: castList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, int index) => _CastCard(cast: castList[index]),
          ),
        );
      },
    );
  }
}

class _CastCard extends StatelessWidget {
  final Cast cast;

  const _CastCard({
    required this.cast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 100,
      width: 125,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(cast.fullProfileImg),
              height: 140,
              width: 115,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            cast.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entitites/movie.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_by_movie_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';
import 'package:cinemapedia/presentation/providers/storage/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/providers/storage/local_storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';

  //Received the ID. It is required.
  //We just need the ID since is the only thing we will need with deeplinking to tell the app where to go when the user clicks on a link.
  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    //
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActor(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Scaffold(
      body: _MovieView(
        movie: movie,
      ),
    );
  }
}

//Creating a provider to update the icon on the movie screen.
final isFavoriteProvider =
    FutureProvider.family.autoDispose((ref, int movieID) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  /*  print(localStorageRepository.isMovieFavorite(movieID)); */
  return localStorageRepository.isMovieFavorite(movieID);
});

class _MovieView extends ConsumerWidget {
  final Movie movie;

  const _MovieView({
    required this.movie,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    final size = MediaQuery.of(context).size;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          actions: [
            IconButton(
              onPressed: () async {
                /* await ref
                    .watch(localStorageRepositoryProvider)
                    .toggleFavorite(movie);
                print("click"); */
//Corregido
                await ref
                    .read(favoriteMoviesProvider.notifier)
                    .toggleFavorite(movie);

                //Invalidamos
                ref.invalidate(isFavoriteProvider(movie.id));
              },
              icon: isFavoriteFuture.when(
                data: (isFavorite) {
                  ref.invalidate(isFavoriteProvider(movie.id));

                  if (isFavorite) {
                    return const Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                    );
                  }

                  return const Icon(
                    Icons.favorite_border,
                  );
                },
                error: (_, __) => throw UnimplementedError(),
                loading: () => const CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          ],
          backgroundColor: Colors.black,
          expandedHeight: size.height * 0.7,
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            /* title: Text(
              movie.title,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.left,
            ), */
            background: Stack(
              children: [
                SizedBox.expand(
                  child: Image.network(
                    movie.posterPath,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress != null) return const SizedBox();
                      return FadeIn(
                          duration: const Duration(milliseconds: 1000),
                          child: child);
                    },
                  ),
                ),
                //Sizedbox for the title of the image.
                const SizedBox.expand(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.92, 1.0],
                        colors: [Colors.transparent, Colors.black45],
                      ),
                    ),
                  ),
                ),
                //Sized box for the top right gradient to make sure the "like" icon is visible on white backgrounds.
                const SizedBox.expand(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 0.3],
                        colors: [
                          Colors.black54,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                //Sizedbox for the top left arrow of the image.
                const SizedBox.expand(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        stops: [0.0, 0.25],
                        colors: [
                          Colors.black87,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            final size = MediaQuery.of(context).size;
            final textStyles = Theme.of(context).textTheme;
            //
            //print(movie.id);
            return _SliverBody(
                size: size, movie: movie, textStyles: textStyles);
          },
        ),
      ],
    );
  }
}

class _SliverBody extends StatelessWidget {
  const _SliverBody({
    required this.size,
    required this.movie,
    required this.textStyles,
  });

  final Size size;
  final Movie movie;
  final TextTheme textStyles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: size.width * 0.3,
                  child: Image.network(movie.posterPath),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: textStyles.titleLarge,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      movie.overview,
                      style: textStyles.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(8),
            child: Wrap(
              children: [
                ...movie.genreIds.map(
                  (genre) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Chip(
                      label: Text(genre),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
//Implement actors with a list view.
          _ActorsInfo(movieId: movie.id.toString())
        ],
      ),
    );
  }
}

class _ActorsInfo extends ConsumerWidget {
  final String movieId;

  const _ActorsInfo({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final loadActors = ref.watch(actorsByMovieProvider);
    if (loadActors[movieId] == null) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }

    final actors = loadActors[movieId]!;
    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: actors.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final actor = actors[index];
          return Container(
            padding: const EdgeInsets.all(8),
            // width: 160,
            //color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //actor photo
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(actor.profilePath),
                  ),
                ),
                //actor name
                const SizedBox(height: 10),
                Text(
                  actor.name,
                  maxLines: 2,
                ),
                Text(
                  actor.character!,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                  maxLines: 2,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:cinemapedia/config/routers/app_routers.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:cinemapedia/presentation/providers/search/search_movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entitites/movie.dart';
import '../../delegates/search_movie_delegate.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.titleLarge;

    //
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              const SizedBox(width: 5),
              Text(
                'Cartelera Cinematografica',
                style: textStyle,
              ),
              const Spacer(),
              IconButton.filledTonal(
                onPressed: () {
                  //
                  final searchedMovies = ref.read(searchedMoviesProvider);
                  final searchQuery = ref.read(searchQueryProvider);
                  //
                  showSearch<Movie?>(
                    query: searchQuery,
                    context: context,
                    delegate: SearchMovieDelegate(
                        //We are passing the query values to the provider here. ⬇️
                        initialMovies: searchedMovies,
                        searchmovies: ref
                            .read(searchedMoviesProvider.notifier)
                            .searchMoviesByQuery),
                  ).then((movie) {
                    if (movie == null) return;
                    context.push('/movie/${movie.id}');
                  });
                },
                icon: const Icon(Icons.search),
              ), //
            ],
          ),
        ),
      ),
    );
  }
}

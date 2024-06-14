import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                  final movieRepository = ref.read(movieRepositoryProvider);
                  showSearch(
                    context: context,
                    delegate: SearchMovieDelegate(
                        searchmovies: movieRepository.searchMovies),
                  );
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

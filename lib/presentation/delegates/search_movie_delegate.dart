import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../domain/entitites/movie.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate {
  final SearchMoviesCallback searchmovies;

  SearchMovieDelegate(
      {super.searchFieldLabel,
      super.searchFieldStyle,
      super.searchFieldDecorationTheme,
      super.keyboardType,
      super.textInputAction,
      required this.searchmovies});

  @override
  String get searchFieldLabel => 'Buscar Pelicula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      FadeIn(
        animate: query.isNotEmpty,
        duration: const Duration(milliseconds: 320),
        child: IconButton.filledTonal(
            onPressed: () => query = '', icon: const Icon(Icons.clear_rounded)),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton.filledTonal(
      //We add null in teh close because we assume that the client didnt look for anything there.
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: searchmovies(query),
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) =>
              _MovieSearchItem(movie: movies[index]),
        );
      },
    );
  }
}

class _MovieSearchItem extends StatelessWidget {
  final Movie movie;

  const _MovieSearchItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final textstyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return movie.posterPath !=
            'https://linnea.com.ar/wp-content/uploads/2018/09/404PosterNotFound-400x559.jpg'
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                //Image
//We need to control its size inside a sizedBox.
                SizedBox(
                  width: size.width * 0.2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(movie.posterPath),
                  ),
                ),

                SizedBox(width: 15),
                //Title

                SizedBox(
                  width: size.width * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: textstyle.titleMedium,
                      ),
                      const SizedBox(height: 5),
                      (movie.overview.length > 100)
                          ? Text(
                              '${movie.overview.substring(0, 100)}...',
                            )
                          : Text(movie.overview),
                    ],
                  ),
                ),
              ],
            ))
        : const SizedBox(
            height: 0.00001,
          );
  }
}

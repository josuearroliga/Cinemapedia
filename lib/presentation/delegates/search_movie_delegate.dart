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
          itemBuilder: (context, index) {
            final movie = movies[index];
            return ListTile(
              title: Text(movie.title),
            );
          },
        );
      },
    );
  }
}

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entitites/movie.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(
    String searchBarQuery);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchmovies;
  //A debouncer is used to prevent multiple http requests to be sent to the server and instead to wait a few until the user stops typing to send the request.
  final StreamController<List<Movie>> debounceMovies =
      StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate({required this.searchmovies});

  void _onQueryChanged(String searchBarQuery) {
    print('Query cambio');

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () async {
      print('Buscando pelis');
      //Adding an empty list of the movie is empty.
      if (query.isEmpty) {
        debounceMovies.add([]);
        return;
      }

      //If it is not empty, then:
      //This query is sent form the builder and is basically the text that is in the searchbar.
      final movies = await searchmovies(searchBarQuery);
      //Ypu can also just use the word 'query' which is global in this calss.
      debounceMovies.add(movies);
    });
  }

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
    _onQueryChanged(query);
    return StreamBuilder(
      stream: debounceMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieSearchItem(
            movie: movies[index],
            onSearchedMovie: context.push,
          ),
        );
      },
    );
  }
}

class _MovieSearchItem extends StatelessWidget {
  final Movie movie;
  //Below, we are receiving the close argument from the caller class.
  final Function onSearchedMovie;

  const _MovieSearchItem(
      {super.key, required this.movie, required this.onSearchedMovie});

  @override
  Widget build(BuildContext context) {
    final textstyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return movie.posterPath !=
            'https://linnea.com.ar/wp-content/uploads/2018/09/404PosterNotFound-400x559.jpg'
        ? GestureDetector(
            onTap: () {
              onSearchedMovie('/movie/${movie.id}');
            },
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    //Image
                    //We need to control its size inside a sizedBox.
                    SizedBox(
                      width: size.width * 0.2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          movie.posterPath,
                          loadingBuilder: (context, child, loadingProgress) =>
                              FadeIn(child: child),
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),
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
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_half_rounded,
                                color: Color.fromARGB(255, 246, 194, 37),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                HumanFormats.number(movie.voteAverage, 1),
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 246, 194, 37),
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          )
        : const SizedBox(
            height: 0.00001,
            //This sized box is what it will return if the movie doesnt have a pathimage, basically will never show null movies using this technique.
          );
  }
}

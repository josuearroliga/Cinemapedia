import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entitites/movie.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(
    String searchBarQuery);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  List<Movie> initialMovies;
  final SearchMoviesCallback searchmovies;

  //A debouncer is used to prevent multiple http requests to be sent to the server and instead to wait a few until the user stops typing to send the request.
  final StreamController<List<Movie>> debounceMovies =
      StreamController.broadcast();

  //This is just to set a time that the app will take before performing a search.
  Timer? _debounceTimer;

  SearchMovieDelegate(
      {required this.searchmovies, required this.initialMovies});

//We have to call this method whenever we exit the search box.
  void cleanStreams() {
    debounceMovies.close();
    print('Cleaning streams');
  }

//Method to detect if another key has been pressed.
  void _onQueryChanged(String searchBarQuery) {
    // print('Query cambio');
//Si el contador no esta activo, entonces lo cancelamos y mandamos a mostrar la data.
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

//Seteamos el tiempo que va a tardar en mostrar data despues de presionar una tecla.
    _debounceTimer = Timer(Duration(milliseconds: 500), () async {
      //print('Buscando pelis');
      //Adding an empty list of the movie is empty.
      /*   if (query.isEmpty) {
        debounceMovies.add([]);
        print('Adding empty array');

        return;
      } */

      //If it is not empty, then:
      //This query is sent form the builder and is basically the text that is in the searchbar.
      final movies = await searchmovies(searchBarQuery);
      //Ypu can also just use the word 'query' which is global in this calss.
      debounceMovies.add(movies);
//We do this in order for the movies to be available to access when the user presses enter, we removed the final from the initial movies variable.
      initialMovies = movies;
    });
  }

  @override
  String get searchFieldLabel => 'Buscar Pelicula';

//This is the X button.
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

//Boton izquierdo para regresar.
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton.filledTonal(
      //We add null in teh close because we assume that the client didnt look for anything there.
      onPressed: () {
        cleanStreams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

//Loads the data after pressing "Enter"
  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSugestions();
  }
  //Creating a sepparate class to avoid repeating code in "build suggestions" and "build results"

  Widget buildResultsAndSugestions() {
    return StreamBuilder(
      //Initial data is receiving the already looked up list of movies to pre load it.
      initialData: initialMovies,
      stream: debounceMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieSearchItem(
            movie: movies[index],
            onMovieSelected: (context, movie) {
              cleanStreams();
              close(context, movie);
            },
          ),
        );
      },
    );
  }

//Loads the data after typing
  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return buildResultsAndSugestions();
  }
}

class _MovieSearchItem extends StatelessWidget {
  final Movie movie;
  //Below, we are receiving the close argument from the caller class.
  final Function onMovieSelected;

  const _MovieSearchItem(
      {super.key, required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textstyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return movie.posterPath !=
            'https://linnea.com.ar/wp-content/uploads/2018/09/404PosterNotFound-400x559.jpg'
        ? GestureDetector(
            onTap: () {
              onMovieSelected(context, movie);
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

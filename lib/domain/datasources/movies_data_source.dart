//We create an abstract class, because we do not want to create instances of this class.
//We will define how the data origins will look like, will define what are the methods that we will be calling to get the data from the APIs.

//We will just define the methods in this class but we will not implement them here.

import 'package:cinemapedia/domain/entitites/movie.dart';

abstract class MoviesDataSource {
  Future<List<Movie>> getNowPlaying({int page = 1});

  Future<List<Movie>> getPopular({int page = 1});

  Future<List<Movie>> getUpcoming({int page = 1});

  Future<List<Movie>> getTopRated({int page = 1});

  Future<List<Movie>> searchMovies(String query);

  Future<Movie> getMovieById(String id);
}

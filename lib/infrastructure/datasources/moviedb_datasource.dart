//This will only work to have interactions with The Movie DB

import 'package:cinemapedia/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_data_source.dart';
import 'package:cinemapedia/domain/entitites/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/movie_db/movie_moviedb.dart';
import 'package:cinemapedia/infrastructure/models/movie_db/moviedb_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MovieDbDataSource extends MoviesDataSource {
//Set global clas variable to call the http request
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX',
      },
    ),
  );

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing');

    final movieDbResponse = MovieDbResponse.fromJson(response.data);

    List<Movie> movies = movieDbResponse.results
        .where((movieDb) => movieDb.posterPath != 'no-poster')
        .map((movieDb) => MovieMapper.movieDBToEntity(movieDb))
        .toList();

    return movies;
  }
}

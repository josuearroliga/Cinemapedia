//We will call the repository that is under the domain folder.

import 'package:cinemapedia/domain/datasources/movies_data_source.dart';
import 'package:cinemapedia/domain/entitites/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

class MovieRepositoryImpl extends MoviesRepository {
//We need to call the datasourceso it can call the getnowplaying method.

  final MoviesDataSource datasource;

  MovieRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return this.datasource.getNowPlaying(page: page);
  }
}
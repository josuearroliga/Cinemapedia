import 'package:cinemapedia/domain/entitites/movie.dart';

//The repository will be the one calling the datasource.
//We will not all the methods directly from the data source, the repository will be the one calling them, security measures.
//If we need to change a source of data we will do it from here, it will be easier to change it here and just call the datasource after...

abstract class MovieRepository {
  Future<List<Movie>> getNowPlaying({int page = 1});
}

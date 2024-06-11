import 'package:cinemapedia/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_data_source.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/movie_db/credits_response.dart';
import 'package:dio/dio.dart';

import '../../domain/entitites/actor.dart';

class ActorMovieDbDataSource extends ActorsDataSource {
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
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');
    //Checking if the id was invalid:
    if (response.statusCode != 200) {
      throw Exception('Movie with Id $movieId was not found');
    }

    final castResponse = CreditsResponse.fromJson(response.data);

    List<Actor> actors = castResponse.cast
        .map((cast) => ActorMapper.castToEntity(cast))
        .toList();

    return actors;
  }
}

import 'package:cinemapedia/domain/datasources/actors_data_source.dart';
import 'package:cinemapedia/domain/entitites/actor.dart';
import 'package:cinemapedia/domain/repositories/actors_repository.dart';

class ActorRepositoryImpl extends ActorsRepository {
  final ActorsDataSource datasource;

  ActorRepositoryImpl({required this.datasource});
  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    return datasource.getActorsByMovie(movieId);
  }
}

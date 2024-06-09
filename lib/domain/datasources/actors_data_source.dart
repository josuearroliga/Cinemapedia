import '../entitites/actor.dart';
import '../entitites/movie.dart';

abstract class ActorsDataSource {
  Future<List<Actor>> getActorsByMovie({String movieId});
}

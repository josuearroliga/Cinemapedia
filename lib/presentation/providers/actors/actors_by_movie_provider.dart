import 'package:cinemapedia/presentation/providers/actors/actor_repository_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entitites/actor.dart';

//Creating new provide for lis of movies by Id
final actorsByMovieProvider =
    StateNotifierProvider<ActorsByMovieMapNotifier, Map<String, List<Actor>>>(
        (ref) {
  final actorsRepository = ref.watch(actorRepositoryProvider);
  return ActorsByMovieMapNotifier(getActor: actorsRepository.getActorsByMovie);
});

typedef GetActorCallback = Future<List<Actor>> Function(String movieId);

class ActorsByMovieMapNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorCallback getActor;

  ActorsByMovieMapNotifier({required this.getActor}) : super({});

  Future<void> loadActor(String movieId) async {
    if (state[movieId] != null) return;

    final actor = await getActor(movieId);
    state = {...state, movieId: actor};
  }
}

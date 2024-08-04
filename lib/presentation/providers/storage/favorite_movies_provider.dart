import 'package:cinemapedia/domain/entitites/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/repositories/local_storage_repository.dart';
import 'local_storage_provider.dart';

//Creating the provider.
//This acts as a memory container.
final favoriteMoviesProvider =
    StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return StorageMoviesNotifier(localStorageRepository: localStorageRepository);
});

class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  //To know what is the page
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  StorageMoviesNotifier({required this.localStorageRepository}) : super({});

//
  Future<void> loadNextPage() async {
    final movies = await localStorageRepository.loadMovies(offset: page * 10);
    page++;

//We create a temp map tp store the movies that the for cicle will review.
    final tempMoviesMap = <int, Movie>{};
//We create a for cicle to go through all the movies we are receiving.
    for (final movie in movies) {
      tempMoviesMap[movie.id] = movie;
    }
    state = {...state, ...tempMoviesMap};
  }
}

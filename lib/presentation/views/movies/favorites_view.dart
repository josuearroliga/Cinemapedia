import 'package:cinemapedia/config/routers/app_routers.dart';
import 'package:cinemapedia/presentation/providers/storage/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//init - Solo priemras 10 movies

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLoading = false;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();

    loadNextPage();
  }

  void loadNextPage() async {
    if (isLastPage || isLoading) return;
    isLoading = true;

    //
    final movies =
        await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    //This is the easy way to get the values of a map, check on how to do this using a for loop at the bottom of this page.

    final favoriteMovies = ref.watch(favoriteMoviesProvider).values.toList();

    if (favoriteMovies.isEmpty) {
      final colors = Theme.of(context).colorScheme;

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.heart_broken,
              size: 90,
              color: Colors.redAccent,
            ),
            Text(
              'Aun no tiene favoritos, empieza agregando alguno.',
              style: TextStyle(fontSize: 25, color: colors.primary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
            FilledButton.tonal(
              onPressed: () => context.go('/home/0'),
              child: const Text('Empieza aqui'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: MovieMasonry(
        loadNextPage: loadNextPage,
        movies: favoriteMovies,
      ),
    );
  }
}


//USE FOR LOOP TO RUN THOUGH A MAP

  //  //If you are going to go theough a map to take out data and put it on a list, you need a new list, so you create it.
  //   final reviewedFavorites = <String>[];
  //   //Set up a counter so the FOR loop knows where to start.
  //   int counter = 0;
// //Running a for loop to go over the map we have and extract the data we want.
//     for (var entry in favoriteMovies.entries) {
//       //We only want the first 10 values
//       if (counter >= 10) {
//         break;
//       }
//       //Here we are adding to the new list the:
//       //Entry: Current Iteration Positioning of the For loop.
//       //Value: Which are all the value set that the map has.
//       //Title: in this case this is the only thing that I needed so I selected only that one.
//       reviewedFavorites.add(entry.value.title.toString());
//       counter++;
//     }
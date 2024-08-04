import 'package:cinemapedia/presentation/providers/storage/favorite_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//init - Solo priemras 10 movies

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  @override
  void initState() {
    super.initState();

    ref.read(favoriteMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    //This is the easy way to get the values of a map, check on how to do this using a for loop at the bottom of this page.

    final favoriteMovies = ref.watch(favoriteMoviesProvider).values.toList();

    return Scaffold(
        body: ListView.builder(
      itemCount: favoriteMovies.length,
      itemBuilder: (context, index) {
        //This is extra, just making it short.
        final movie = favoriteMovies[index];
        return ListTile(
          title: Text(movie.title),
        );
      },
    ));
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
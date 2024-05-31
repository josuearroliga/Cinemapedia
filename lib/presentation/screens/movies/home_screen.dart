import 'package:cinemapedia/constants/environment.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/providers/movies/slideshow_movies_provider.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:cinemapedia/presentation/widgets/movies/movies_slideshow.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_app_bar.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomeView();
  }
}

//Extracted class to be called
class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final slideShowMovies = ref.watch(slideShowMoviesProvider);

    return Scaffold(
      body: Column(
        children: [
          const CustomAppBar(),
          MoviesSlideshow(movies: slideShowMovies),
          MoviesHorizontalListview(
            movies: nowPlayingMovies,
            title: 'En cines',
            subTitle: 'Test',
            loadNextPage: () =>
                ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}

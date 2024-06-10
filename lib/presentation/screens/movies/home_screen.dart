import 'package:cinemapedia/presentation/providers/movies/initial_loading_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/providers/movies/slideshow_movies_provider.dart';
import 'package:cinemapedia/presentation/screens/screens_barrel.dart';
import 'package:cinemapedia/presentation/widgets/movies/movies_slideshow.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_app_bar.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:cinemapedia/presentation/widgets/shared/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
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
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoad = ref.watch(initialLoadingProvider);

    if (initialLoad) return const FullScreenLoader();

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final slideShowMovies = ref.watch(slideShowMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppBar(),
          ),
        ),

//*TODO: A bug was found in this sliver list, the renderflow parent inside flutter was not able to tell the size of each MoviesHorizontalView widgets because the expanded does not offer a constant height, I needed to change the expanded for a container with a fixed height for it to work inside that widget.

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  MoviesSlideshow(movies: slideShowMovies),
                  MoviesHorizontalListview(
                    movies: nowPlayingMovies,
                    title: 'En cines',
                    subTitle:
                        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    loadNextPage: () => ref
                        .read(nowPlayingMoviesProvider.notifier)
                        .loadNextPage(),
                  ),
                  MoviesHorizontalListview(
                    movies: popularMovies,
                    title: 'Populares Ahora',
                    //subTitle: 'Test',
                    loadNextPage: () =>
                        ref.read(popularMoviesProvider.notifier).loadNextPage(),
                  ),
                  MoviesHorizontalListview(
                    movies: upcomingMovies,
                    title: 'A Estrenarse Pronto',
                    //subTitle: ' Test 3 sub',
                    loadNextPage: () => ref
                        .read(upcomingMoviesProvider.notifier)
                        .loadNextPage(),
                  ),
                  MoviesHorizontalListview(
                    movies: topRatedMovies,
                    title: 'Mejores Calificadas',
                    //subTitle: ' Test 3 sub',
                    loadNextPage: () => ref
                        .read(topRatedMoviesProvider.notifier)
                        .loadNextPage(),
                  ),
                  const SizedBox(height: 15),
                ],
              );
            },
            childCount: 1,
          ),
        ),
        //const CustomBottomNavigation(),
      ],
    );
  }
}

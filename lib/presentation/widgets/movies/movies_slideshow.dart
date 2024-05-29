import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import '../../../domain/entitites/movie.dart';

class MoviesSlideshow extends StatelessWidget {
  final List<Movie> movies;

  const MoviesSlideshow({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      width: double.infinity,
      child: Swiper(
        itemCount: movies.length,
        itemBuilder: (context, index) => _Slide(
          movie: movies[index],
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

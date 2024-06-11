import 'package:flutter/material.dart';

import '../../delegates/search_movie_delegate.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.titleLarge;

    //
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              const SizedBox(width: 5),
              Text(
                'Cartelera Cinematografica',
                style: textStyle,
              ),
              const Spacer(),
              IconButton.filledTonal(
                onPressed: () {
                  showSearch(context: context, delegate: SearchMovieDelegate());
                },
                icon: const Icon(Icons.search),
              ), //
            ],
          ),
        ),
      ),
    );
  }
}

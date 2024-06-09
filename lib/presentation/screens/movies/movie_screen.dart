import 'package:flutter/material.dart';

class MovieScreen extends StatelessWidget {
  static const name = 'movie-screen';

  //Received the ID. It is required.
  //We just need the ID since is the only thing we will need with deeplinking to tell the app where to go when the user clicks on a link.
  final String movieID;

  const MovieScreen({super.key, required this.movieID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The movie ID is: $movieID'),
      ),
    );
  }
}

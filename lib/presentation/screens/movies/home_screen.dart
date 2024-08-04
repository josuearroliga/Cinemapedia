import 'package:cinemapedia/presentation/screens/views/favorites_view.dart';
import 'package:flutter/material.dart';

import '../../widgets/shared/custom_bottom_navigation.dart';
import '../views/home_screen_view.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  final int pageindex;

  const HomeScreen({super.key, required this.pageindex});

//This will be the list that will be used to determine the view to be used when receiving the page argument when being called from the router page.
  final viewRoutes = const <Widget>[HomeView(), SizedBox(), FavoritesView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageindex,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottomNavigation(receivedIndex: pageindex),
    );
  }
}

//Extracted class to be called
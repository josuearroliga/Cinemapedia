import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//Class to know to move the user form page, this class will be assigned to the onTap feature within the BottomNavigationBar widget.

void onItemTapped(BuildContext ctx, int index) {
  //
  switch (index) {
    case 0:
      ctx.go('/');
      break;
    case 1:
      ctx.go('/categories');
      break;
    case 2:
      ctx.go('/favorites');
      break;
  }
}

int getCurrentIndex(BuildContext context) {
  //
  final String location = GoRouterState.of(context).uri.toString();

  print(location);
  switch (location) {
    case '/':
      return 0;

    case '/categories':
      return 1;

    case '/favorites':
      return 2;

    default:
      return 0;
  }
}

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (value) => onItemTapped(context, value),
      currentIndex: getCurrentIndex(context),
      elevation: 0,
      selectedItemColor: Colors.red,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_max_outlined), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined), label: 'Categorias'),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline), label: 'Favoritos'),
      ],
    );
  }
}

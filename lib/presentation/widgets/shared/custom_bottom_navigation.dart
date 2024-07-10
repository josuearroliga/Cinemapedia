import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int receivedIndex;

  const CustomBottomNavigation({super.key, required this.receivedIndex});

  void onTapAction(BuildContext context, int index) {
    print(receivedIndex);
    switch (index) {
      case 0:
        context.go('/home/0');
        break;
      case 1:
        context.go('/home/1');
        break;
      case 2:
        context.go('/home/2');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (value) => onTapAction(context, value),
      currentIndex: receivedIndex,
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

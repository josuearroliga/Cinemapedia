import 'package:cinemapedia/presentation/screens/screens_barrel.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [
    GoRoute(
        path: '/home/:page',
        name: HomeScreen.name,
        builder: (context, state) {
//We get the page index from go router but we need to convert it to int to be able to use it.
          final pageIndex = state.pathParameters['page'] ?? '0';

          return HomeScreen(
            pageindex: int.parse(pageIndex),
          );
        },
        routes: [
          GoRoute(
            path: 'movie/:id',
            name: MovieScreen.name,
            builder: (context, state) {
              final movieId = state.pathParameters['id'] ?? 'no-id';
              return MovieScreen(movieId: movieId);
            },
          ),
        ]),
    GoRoute(path: '/', redirect: (_, __) => '/home/0'),
  ],
);

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/coffee/domain/entities/coffee.dart';
import '../../../features/coffee/presentation/blocs/favorites/favorites_bloc.dart';
import '../../../features/coffee/presentation/blocs/coffee/coffee_bloc.dart';
import '../../../features/coffee/presentation/pages/coffee_page.dart';
import '../../../features/coffee/presentation/pages/coffee_viewer_page.dart';
import '../../../features/coffee/presentation/pages/favorites_page.dart';
import '../di/injection.dart' as di;
import 'app_route_paths.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutePaths.root,
      builder: (context, state) => BlocProvider(
        create: (_) => di.sl<CoffeeBloc>(),
        child: const CoffeePage(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.favorites,
      builder: (context, state) => BlocProvider(
        create: (_) => di.sl<FavoritesBloc>(),
        child: const FavoritesPage(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.viewer,
      builder: (context, state) {
        final coffee = state.extra as Coffee;
        return CoffeeViewerPage(coffee: coffee);
      },
    ),
  ],
);

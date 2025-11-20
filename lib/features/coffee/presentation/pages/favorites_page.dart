import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_coffee_app/core/design/tokens/tokens.dart';
import 'package:very_good_coffee_app/core/design/widgets/widgets.dart';
import 'package:very_good_coffee_app/core/errors/failure_messages.dart';
import 'package:very_good_coffee_app/core/l10n/l10n.dart';
import 'package:very_good_coffee_app/core/routes/app_route_paths.dart';
import 'package:very_good_coffee_app/features/coffee/domain/entities/coffee.dart';
import 'package:very_good_coffee_app/features/coffee/presentation/blocs/favorites/favorites_bloc.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesBloc>().add(const FavoritesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.favoritesPageTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              switch (state.status) {
                case FavoritesStatus.loading:
                case FavoritesStatus.initial:
                  return const LoadingWidget();
                case FavoritesStatus.failure:
                  return Center(
                    child: FailureWidget(
                      message: getFailureMessage(
                        state.failure,
                        fallback: context.l10n.errorLoadingFavorites,
                        context: context,
                      ),
                    ),
                  );
                case FavoritesStatus.success:
                  if (state.coffees.isEmpty) {
                    return const _EmptyFavoritesView();
                  }
                  return _FavoritesGrid(coffees: state.coffees);
              }
            },
          ),
        ),
      ),
    );
  }
}

class _EmptyFavoritesView extends StatelessWidget {
  const _EmptyFavoritesView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.l10n.noFavoritesYet, textAlign: TextAlign.center),
    );
  }
}

class _FavoritesGrid extends StatelessWidget {
  const _FavoritesGrid({required this.coffees});

  final List<Coffee> coffees;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: coffees.length,
      itemBuilder: (context, index) {
        final coffee = coffees[index];
        return InkWell(
          onTap: () {
            context.push(AppRoutePaths.viewer, extra: coffee);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(BorderRadiusTokens.r12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
              ),
              child: CoffeeImage(coffee: coffee),
            ),
          ),
        );
      },
    );
  }
}

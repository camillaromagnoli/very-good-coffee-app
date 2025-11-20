import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/design/tokens/tokens.dart';
import '../../../../../core/design/widgets/widgets.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failure_messages.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/routes/app_route_paths.dart';
import '../../domain/entities/coffee.dart';
import '../blocs/coffee/coffee_bloc.dart';

class CoffeePage extends StatefulWidget {
  const CoffeePage({super.key});

  @override
  State<CoffeePage> createState() => _CoffeePageState();
}

class _CoffeePageState extends State<CoffeePage> {
  @override
  void initState() {
    super.initState();
    context.read<CoffeeBloc>().add(const CoffeeRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoffeeBloc, CoffeeState>(
      listenWhen: (previous, current) =>
          previous.saveStatus != current.saveStatus,
      listener: (context, state) {
        if (state.saveStatus == SaveStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.savedToFavorites)),
          );
        } else if (state.saveStatus == SaveStatus.failure &&
            state.saveFailure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                getFailureMessage(
                  state.saveFailure,
                  fallback: context.l10n.errorSavingCoffee,
                  context: context,
                ),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.coffeePageTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_outline),
              onPressed: () {
                context.push(AppRoutePaths.favorites);
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: BlocBuilder<CoffeeBloc, CoffeeState>(
                builder: (context, state) {
                  switch (state.status) {
                    case CoffeeStatus.loading:
                      return const LoadingWidget();
                    case CoffeeStatus.failure:
                      final isOffline = state.failure is NetworkException;
                      return FailureWidget(
                        message: getFailureMessage(
                          state.failure,
                          fallback: context.l10n.errorLoadingCoffee,
                          context: context,
                        ),
                        onRetry: isOffline
                            ? null
                            : () {
                                context.read<CoffeeBloc>().add(
                                  const CoffeeRequested(),
                                );
                              },
                        secondaryAction: isOffline
                            ? () {
                                context.push(AppRoutePaths.favorites);
                              }
                            : null,
                        secondaryActionLabel: isOffline
                            ? context.l10n.viewFavoritesButton
                            : null,
                      );
                    case CoffeeStatus.success:
                      if (state.coffee == null) {
                        return const _EmptyView();
                      }
                      return _CoffeeContent(
                        coffee: state.coffee!,
                        saveStatus: state.saveStatus,
                      );
                    case CoffeeStatus.initial:
                      return const LoadingWidget();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CoffeeContent extends StatelessWidget {
  const _CoffeeContent({required this.coffee, required this.saveStatus});

  final Coffee coffee;
  final SaveStatus saveStatus;

  @override
  Widget build(BuildContext context) {
    final isSaving = saveStatus == SaveStatus.saving;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () {
                  context.read<CoffeeBloc>().add(const CoffeeRequested());
                },
                icon: const Icon(Icons.refresh),
                label: Text(context.l10n.newCoffeeButton),
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isSaving
                    ? null
                    : () {
                        context.read<CoffeeBloc>().add(const CoffeeSaved());
                      },
                icon: isSaving
                    ? const SizedBox(
                        width: Spacing.md,
                        height: Spacing.md,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.favorite),
                label: Text(context.l10n.saveButton),
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.lg),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(BorderRadiusTokens.r16),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: CoffeeImage(coffee: coffee),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(context.l10n.noCoffeeYet));
  }
}

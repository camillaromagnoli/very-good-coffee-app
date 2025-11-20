import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee_app/core/design/widgets/widgets.dart';

import 'package:very_good_coffee_app/core/errors/exceptions.dart';
import 'package:very_good_coffee_app/features/coffee/domain/entities/coffee.dart';
import 'package:very_good_coffee_app/features/coffee/presentation/blocs/favorites/favorites_bloc.dart';
import 'package:very_good_coffee_app/features/coffee/presentation/pages/favorites_page.dart';
import '../../../../mocks/mocks.dart';
import '../../../../utils/test_helpers.dart';

void main() {
  late FavoritesBloc favoritesBloc;
  late MockGetFavoriteCoffees mockGetFavoriteCoffees;

  setUp(() {
    mockGetFavoriteCoffees = MockGetFavoriteCoffees();
    favoritesBloc = FavoritesBloc(getFavoriteCoffees: mockGetFavoriteCoffees);
  });

  tearDown(() {
    favoritesBloc.close();
  });

  group('FavoritesPage', () {
    testWidgets('should display loading indicator when state is loading', (
      WidgetTester tester,
    ) async {
      favoritesBloc.emit(
        const FavoritesState(
          status: FavoritesStatus.loading,
          coffees: [],
          failure: null,
        ),
      );

      await tester.pumpWidget(
        createTestWidget(
          child: BlocProvider.value(
            value: favoritesBloc,
            child: const FavoritesPage(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(LoadingWidget), findsOneWidget);
    });

    testWidgets('should display empty state when no favorites are saved', (
      WidgetTester tester,
    ) async {
      favoritesBloc.emit(
        const FavoritesState(
          status: FavoritesStatus.success,
          coffees: [],
          failure: null,
        ),
      );

      await tester.pumpWidget(
        createTestWidget(
          child: BlocProvider.value(
            value: favoritesBloc,
            child: const FavoritesPage(),
          ),
        ),
      );
      await tester.pump();

      expect(
        find.text('No favorites yet.\nSave coffees you like to see them here.'),
        findsOneWidget,
      );
    });

    testWidgets('should display grid when favorites are available', (
      WidgetTester tester,
    ) async {
      final tCoffees = [
        Coffee(
          id: '1',
          imageUrl: 'https://example.com/coffee1.jpg',
          imageBytes: Uint8List.fromList([1, 2, 3]),
        ),
        Coffee(
          id: '2',
          imageUrl: 'https://example.com/coffee2.jpg',
          imageBytes: Uint8List.fromList([4, 5, 6]),
        ),
      ];

      favoritesBloc.emit(
        FavoritesState(
          status: FavoritesStatus.success,
          coffees: tCoffees,
          failure: null,
        ),
      );

      await tester.pumpWidget(
        createTestWidget(
          child: BlocProvider.value(
            value: favoritesBloc,
            child: const FavoritesPage(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('should display error message when state is failure', (
      WidgetTester tester,
    ) async {
      favoritesBloc.emit(
        FavoritesState(
          status: FavoritesStatus.failure,
          coffees: const [],
          failure: Failure('Failed to load favorites'),
        ),
      );

      await tester.pumpWidget(
        createTestWidget(
          child: BlocProvider.value(
            value: favoritesBloc,
            child: const FavoritesPage(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Failed to load favorites'), findsOneWidget);
    });
  });
}

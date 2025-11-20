import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee_app/core/design/widgets/loading_widget.dart';

import 'package:very_good_coffee_app/core/errors/exceptions.dart';
import 'package:very_good_coffee_app/core/usecases/usecase.dart';
import 'package:very_good_coffee_app/features/coffee/domain/usecases/save_coffee.dart';
import 'package:very_good_coffee_app/features/coffee/presentation/blocs/favorites/favorites_bloc.dart';
import 'package:very_good_coffee_app/features/coffee/presentation/blocs/coffee/coffee_bloc.dart';
import 'package:very_good_coffee_app/features/coffee/presentation/pages/coffee_page.dart';
import 'package:very_good_coffee_app/features/coffee/presentation/pages/favorites_page.dart';
import '../../../../mocks/mocks.dart';
import '../../../../utils/test_helpers.dart' as test_helpers;

void main() {
  late CoffeeBloc coffeeBloc;
  late MockGetCoffee mockGetCoffee;
  late MockSaveCoffee mockSaveCoffee;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(SaveCoffeeParams(tCoffee));
  });

  setUp(() {
    mockGetCoffee = MockGetCoffee();
    mockSaveCoffee = MockSaveCoffee();

    coffeeBloc = CoffeeBloc(
      getCoffee: mockGetCoffee,
      saveCoffee: mockSaveCoffee,
    );
  });

  tearDown(() {
    coffeeBloc.close();
  });

  Widget createTestWidget() {
    return test_helpers.createTestWidget(
      child: BlocProvider.value(value: coffeeBloc, child: const CoffeePage()),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              BlocProvider.value(value: coffeeBloc, child: const CoffeePage()),
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) => BlocProvider.value(
            value: FavoritesBloc(getFavoriteCoffees: MockGetFavoriteCoffees()),
            child: const FavoritesPage(),
          ),
        ),
      ],
    );
  }

  group('CoffeePage', () {
    testWidgets('should display loading indicator when state is loading', (
      WidgetTester tester,
    ) async {
      when(
        () => mockGetCoffee(any()),
      ).thenAnswer((_) async => throw Exception());

      await tester.pumpWidget(createTestWidget());
      coffeeBloc.add(const CoffeeRequested());
      await tester.pump();

      expect(find.byType(LoadingWidget), findsOneWidget);
    });

    testWidgets(
      'should display error message and retry button when state is failure',
      (WidgetTester tester) async {
        coffeeBloc.emit(
          CoffeeState(
            status: CoffeeStatus.failure,
            coffee: null,
            failure: Failure('Failed to load coffee'),
            saveStatus: SaveStatus.initial,
            saveFailure: null,
          ),
        );

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(
          find.text('An unexpected error occurred. Please try again.'),
          findsOneWidget,
        );
        expect(find.byType(FilledButton), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      },
    );

    testWidgets(
      'should display offline message and View Favorites button when NetworkException occurs',
      (WidgetTester tester) async {
        coffeeBloc.emit(
          CoffeeState(
            status: CoffeeStatus.failure,
            coffee: null,
            failure: NetworkException('Failed to connect to the network'),
            saveStatus: SaveStatus.initial,
            saveFailure: null,
          ),
        );

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(
          find.text(
            "It seems like you're offline. You can still access your favorite coffee images.",
          ),
          findsOneWidget,
        );

        expect(find.text('View Favorites'), findsOneWidget);
        expect(find.text('Retry'), findsNothing);

        await tester.tap(find.text('View Favorites'));
        await tester.pumpAndSettle();

        expect(find.text('Favorites'), findsOneWidget);
      },
    );

    testWidgets(
      'should display coffee image and buttons when state is success',
      (WidgetTester tester) async {
        coffeeBloc.emit(
          CoffeeState(
            status: CoffeeStatus.success,
            coffee: tCoffee,
            failure: null,
            saveStatus: SaveStatus.initial,
            saveFailure: null,
          ),
        );

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.text('New Coffee'), findsOneWidget);
        expect(find.text('Save'), findsOneWidget);
      },
    );

    testWidgets(
      'should navigate to favorites page when favorites button is tapped',
      (WidgetTester tester) async {
        coffeeBloc.emit(
          CoffeeState(
            status: CoffeeStatus.success,
            coffee: tCoffee,
            failure: null,
            saveStatus: SaveStatus.initial,
            saveFailure: null,
          ),
        );

        await tester.pumpWidget(createTestWidget());
        await tester.pump();
        await tester.tap(find.byType(IconButton).first);
        await tester.pumpAndSettle();

        expect(find.text('Favorites'), findsOneWidget);
      },
    );

    testWidgets(
      'should trigger CoffeeRequested when New Coffee button is tapped',
      (WidgetTester tester) async {
        coffeeBloc.emit(
          CoffeeState(
            status: CoffeeStatus.success,
            coffee: tCoffee,
            failure: null,
            saveStatus: SaveStatus.initial,
            saveFailure: null,
          ),
        );

        when(() => mockGetCoffee(any())).thenAnswer((_) async => tCoffee);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();
        await tester.tap(find.text('New Coffee'));
        await tester.pump();

        expect(coffeeBloc.state.status, equals(CoffeeStatus.loading));
      },
    );

    testWidgets('should not show snackbar when save status does not change', (
      WidgetTester tester,
    ) async {
      coffeeBloc.emit(
        CoffeeState(
          status: CoffeeStatus.success,
          coffee: tCoffee,
          failure: null,
          saveStatus: SaveStatus.success,
          saveFailure: null,
        ),
      );

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      coffeeBloc.emit(
        CoffeeState(
          status: CoffeeStatus.success,
          coffee: tCoffee,
          failure: null,
          saveStatus: SaveStatus.success,
          saveFailure: null,
        ),
      );

      await tester.pump();

      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets(
      'should not show snackbar when save status is failure but saveFailure is null',
      (WidgetTester tester) async {
        coffeeBloc.emit(
          CoffeeState(
            status: CoffeeStatus.success,
            coffee: tCoffee,
            failure: null,
            saveStatus: SaveStatus.initial,
            saveFailure: null,
          ),
        );

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        coffeeBloc.emit(
          CoffeeState(
            status: CoffeeStatus.success,
            coffee: tCoffee,
            failure: null,
            saveStatus: SaveStatus.failure,
            saveFailure: null,
          ),
        );

        await tester.pump();

        expect(find.byType(SnackBar), findsNothing);
      },
    );
  });
}

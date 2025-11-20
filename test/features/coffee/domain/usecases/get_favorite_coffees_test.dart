import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:very_good_coffee_app/core/errors/exceptions.dart';
import 'package:very_good_coffee_app/core/usecases/usecase.dart';
import 'package:very_good_coffee_app/features/coffee/domain/entities/coffee.dart';
import 'package:very_good_coffee_app/features/coffee/domain/usecases/get_favorite_coffees.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late GetFavoriteCoffees usecase;
  late MockCoffeeRepository mockRepository;

  setUp(() {
    mockRepository = MockCoffeeRepository();
    usecase = GetFavoriteCoffees(mockRepository);
  });

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

  test('should get saved coffees from the repository', () async {
    when(
      () => mockRepository.getSavedCoffees(),
    ).thenAnswer((_) async => tCoffees);

    final result = await usecase(const NoParams());

    expect(result, equals(tCoffees));
    verify(() => mockRepository.getSavedCoffees()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should throw CacheException when repository fails', () async {
    when(
      () => mockRepository.getSavedCoffees(),
    ).thenThrow(CacheException('Test error'));

    final call = usecase;

    expect(() => call(const NoParams()), throwsA(isA<CacheException>()));
    verify(() => mockRepository.getSavedCoffees()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:very_good_coffee_app/core/errors/exceptions.dart';
import 'package:very_good_coffee_app/core/usecases/usecase.dart';
import 'package:very_good_coffee_app/features/coffee/domain/entities/coffee.dart';
import 'package:very_good_coffee_app/features/coffee/domain/usecases/get_coffee.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late GetCoffee usecase;
  late MockCoffeeRepository mockRepository;

  setUp(() {
    mockRepository = MockCoffeeRepository();
    usecase = GetCoffee(mockRepository);
  });

  final tCoffee = Coffee(
    id: '1',
    imageUrl: 'https://example.com/coffee.jpg',
    imageBytes: Uint8List.fromList([1, 2, 3]),
  );

  test('should get coffee from the repository', () async {
    when(
      () => mockRepository.getCoffee(),
    ).thenAnswer((_) async => tCoffee);

    final result = await usecase(const NoParams());

    expect(result, equals(tCoffee));
    verify(() => mockRepository.getCoffee()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should throw ServerException when repository fails', () async {
    when(
      () => mockRepository.getCoffee(),
    ).thenThrow(ServerException('Test error'));

    final call = usecase;

    expect(() => call(const NoParams()), throwsA(isA<ServerException>()));
    verify(() => mockRepository.getCoffee()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}

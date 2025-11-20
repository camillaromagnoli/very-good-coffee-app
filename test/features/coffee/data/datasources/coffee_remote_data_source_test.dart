import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:very_good_coffee_app/core/errors/exceptions.dart';
import 'package:very_good_coffee_app/features/coffee/data/datasources/coffee_remote_data_source.dart';
import 'package:very_good_coffee_app/features/coffee/data/models/coffee_model.dart';
import '../../../../mocks/mocks.dart';

void main() {
  late CoffeeRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = CoffeeRemoteDataSourceImpl(mockDio);
  });

  group('getCoffee', () {
    const tImageUrl = 'https://coffee.alexflipnote.dev/random.jpg';
    final tImageBytes = Uint8List.fromList([1, 2, 3, 4, 5]);

    test(
      'should return CoffeeModel when the call to remote source is successful',
      () async {
        when(
          () => mockDio.get<Map<String, dynamic>>(
              any(),
              options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            data: {'file': tImageUrl},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        when(
          () =>
              mockDio.get<List<int>>(tImageUrl, options: any(named: 'options')),
        ).thenAnswer(
          (_) async => Response<List<int>>(
            data: tImageBytes.toList(),
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        final result = await dataSource.getCoffee();

        expect(result, isA<CoffeeModel>());
        expect(result.imageUrl, equals(tImageUrl));
        expect(result.imageBytes, equals(tImageBytes));
        verify(
          () => mockDio.get<Map<String, dynamic>>(
              any(),
              options: any(named: 'options'),
          ),
        ).called(1);
        verify(
          () =>
              mockDio.get<List<int>>(tImageUrl, options: any(named: 'options')),
        ).called(1);
      },
    );

    test(
      'should throw NetworkException when the call to remote source is unsuccessful',
      () async {
        when(
          () => mockDio.get<Map<String, dynamic>>(
              any(),
              options: any(named: 'options'),
          ),
        ).thenThrow(
          DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
          ),
        );

        final call = dataSource.getCoffee;

        expect(() => call(), throwsA(isA<NetworkException>()));
      },
    );

    test('should throw ServerException when status code is not 200', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: null,
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final call = dataSource.getCoffee;

      expect(() => call(), throwsA(isA<ServerException>()));
    });

    test('should throw ServerException when imageUrl is null', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: {'file': null},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final call = dataSource.getCoffee;

      expect(() => call(), throwsA(isA<ServerException>()));
    });

    test(
      'should throw ServerException when image download status code is not 200',
      () async {
        when(
          () => mockDio.get<Map<String, dynamic>>(
              any(),
              options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            data: {'file': tImageUrl},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        when(
          () =>
              mockDio.get<List<int>>(tImageUrl, options: any(named: 'options')),
        ).thenAnswer(
          (_) async => Response<List<int>>(
            data: null,
            statusCode: 404,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        final call = dataSource.getCoffee;

        expect(
          () => call(),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              contains('Failed to download image'),
            ),
          ),
        );
      },
    );

    test(
      'should throw ServerException when image download data is null',
      () async {
        when(
          () => mockDio.get<Map<String, dynamic>>(
              any(),
              options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            data: {'file': tImageUrl},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        when(
          () =>
              mockDio.get<List<int>>(tImageUrl, options: any(named: 'options')),
        ).thenAnswer(
          (_) async => Response<List<int>>(
            data: null,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        final call = dataSource.getCoffee;

        expect(
          () => call(),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              contains('Failed to download image'),
            ),
          ),
        );
      },
    );
  });
}

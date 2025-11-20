import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:very_good_coffee_app/core/errors/exceptions.dart';
import 'package:very_good_coffee_app/core/utils/constants.dart';
import 'package:very_good_coffee_app/features/coffee/data/models/coffee_model.dart';

abstract class CoffeeRemoteDataSource {
  Future<CoffeeModel> getCoffee();
}

@lazySingleton
@Injectable(as: CoffeeRemoteDataSource)
class CoffeeRemoteDataSourceImpl implements CoffeeRemoteDataSource {
  CoffeeRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<CoffeeModel> getCoffee() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        AppConstants.coffeeApiUrl,
      );

      if (response.statusCode != 200 || response.data == null) {
        throw ServerException('Invalid response from server');
      }

      final imageUrl = response.data!['file'] as String?;
      if (imageUrl == null) {
        throw ServerException('Image URL not found in response');
      }

      final imageResponse = await _dio.get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (imageResponse.statusCode != 200 || imageResponse.data == null) {
        throw ServerException('Failed to download image');
      }

      final bytes = Uint8List.fromList(imageResponse.data!);

      return CoffeeModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imageUrl: imageUrl,
        imageBytes: bytes,
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }
}

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../utils/constants.dart';

@module
abstract class AppModule {
  @lazySingleton
  Dio get dio => Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  @preResolve
  @lazySingleton
  Future<Box<Map>> get favoritesBox async {
    final box = await Hive.openBox<Map>(AppConstants.favoritesBoxName);
    return box;
  }
}

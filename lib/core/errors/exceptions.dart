import 'package:dio/dio.dart';

class Failure implements Exception {
  final String? message;
  final String? details;

  Failure([this.message, this.details]);

  @override
  String toString() {
    if (details == null) return message ?? 'Unknown error';
    return '${message ?? "Unknown error"}: $details';
  }
}

class ServerException extends Failure {
  ServerException([super.message]);
}

class CacheException extends Failure {
  CacheException([super.message]);
}

class NetworkException extends Failure {
  NetworkException([super.message]);
}

Failure handleDioError(DioException e) {
  if (e.type == DioExceptionType.unknown ||
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.connectionError) {
    return NetworkException('Failed to connect to the network');
  } else if (e.response != null) {
    return ServerException(
      'Server returned an error: ${e.response?.statusCode}',
    );
  } else {
    return Failure('Unexpected error: ${e.message}');
  }
}

import 'package:dio/dio.dart';

sealed class Failure {
  final String message;

  Failure(this.message);
}

class ApiFailure extends Failure {
  ApiFailure(super.message);

  factory ApiFailure.fromDioException(DioException e) {
    return ApiFailure('Failed to fetch data from the API');
  }
}

class CacheFailure extends Failure {
  CacheFailure(super.message);
}

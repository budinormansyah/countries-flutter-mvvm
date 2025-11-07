import 'package:countries/core/error/failure.dart';
import 'package:countries/domain/entities/country.dart';
import 'package:countries/data/models/country_model.dart';
import 'package:countries/data/network/country_api_service.dart';
import 'package:countries/domain/repository/country_local_repository.dart';
import 'package:countries/domain/repository/country_remote_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class CountryRemoteRepositoryImpl implements CountryRemoteRepository {
  final CountryApiService _apiService;
  final CountryLocalRepository _localRepository;

  CountryRemoteRepositoryImpl(this._apiService, this._localRepository);

  @override
  Future<Either<Failure, List<Country>>> getCountries() async {
    try {
      final countryModels = await _apiService.getCountries();
      final domainCountries = countryModels
          .map((model) => model.toDomain())
          .toList();
      await _localRepository.saveCountries(domainCountries);
      return Right(domainCountries);
    } on DioException catch (e) {
      final localResult = await _localRepository.getCountries();
      return localResult.fold(
        (localFailure) {
          // If reading from cache also fails, return the original API failure.
          return Left(ApiFailure.fromDioException(e));
        },
        (cachedCountries) {
          // If cache has data, return it. Otherwise, return the API failure.
          return cachedCountries.isNotEmpty
              ? Right(cachedCountries)
              : Left(ApiFailure.fromDioException(e));
        },
      );
    }
  }
}

import 'package:countries/core/error/failure.dart';
import 'package:countries/domain/entities/country.dart';
import 'package:fpdart/fpdart.dart';

abstract class CountryLocalRepository {
  Future<Either<Failure, List<Country>>> getCountries();
  Future<void> saveCountries(List<Country> countries);
  Future<void> clearCache();
}

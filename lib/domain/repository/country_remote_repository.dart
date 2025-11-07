import 'package:countries/core/error/failure.dart';
import 'package:countries/domain/entities/country.dart';
import 'package:fpdart/fpdart.dart';

abstract class CountryRemoteRepository {
  Future<Either<Failure, List<Country>>> getCountries();
}

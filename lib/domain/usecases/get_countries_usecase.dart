import 'package:countries/core/error/failure.dart';
import 'package:countries/domain/entities/country.dart';
import 'package:countries/domain/repository/country_remote_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCountriesUseCase {
  final CountryRemoteRepository repository;

  GetCountriesUseCase(this.repository);

  Future<Either<Failure, List<Country>>> call() {
    return repository.getCountries();
  }
}

import 'package:countries/core/error/failure.dart';
import 'package:countries/domain/entities/country.dart';
import 'package:countries/domain/repository/country_local_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetLocalCountriesUseCase {
  final CountryLocalRepository _localRepository;

  GetLocalCountriesUseCase(this._localRepository);

  Future<Either<Failure, List<Country>>> call() async {
    return _localRepository.getCountries();
  }
}

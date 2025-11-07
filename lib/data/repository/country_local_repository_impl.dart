import 'package:countries/core/error/failure.dart';
import 'package:countries/data/database/database_service.dart';
import 'package:countries/data/models/country_model.dart';
import 'package:countries/domain/entities/country.dart' as domain;
import 'package:countries/domain/repository/country_local_repository.dart';
import 'package:fpdart/fpdart.dart';

class CountryLocalRepositoryImpl implements CountryLocalRepository {
  final DatabaseService _databaseService;
  static const String _countriesKey = 'countries_cache';

  CountryLocalRepositoryImpl(this._databaseService);

  @override
  Future<void> saveCountries(List<domain.Country> countries) async {
    final List<CountryModel> countryModels = countries
        .map(
          (country) => CountryModel(
            name: NameModel(
              common: country.name.common,
              official: country.name.official,
            ),
            flags: FlagsModel(png: country.flags.png, svg: country.flags.svg),
            capital: country.capital,
            idd: IddModel(
              root: country.idd.root,
              suffixes: country.idd.suffixes,
            ),
            currencies: country.currencies?.map(
              (key, value) => MapEntry(
                key,
                CurrencyModel(name: value.name, symbol: value.symbol),
              ),
            ),
            cca2: country.cca2,
            population: country.population,
            region: country.region,
            languages: country.languages,
            timezones: country.timezones,
          ),
        )
        .toList();
    final List<Map<String, dynamic>> countriesJson = countryModels
        .map((model) => model.toJson())
        .toList();
    await _databaseService.saveData(_countriesKey, countriesJson);
  }

  @override
  Future<Either<Failure, List<domain.Country>>> getCountries() async {
    try {
      final dynamic countriesData = _databaseService.readData(_countriesKey);
      if (countriesData is List) {
        final countries = countriesData.map((json) {
          final model = CountryModel.fromJson(json as Map<String, dynamic>);
          return model.toDomain();
        }).toList();
        return Right(countries);
      }
      return const Right([]);
    } catch (e) {
      return Left(CacheFailure('Failed to read countries from cache.'));
    }
  }

  @override
  Future<void> clearCache() async {
    await _databaseService.saveData(_countriesKey, null);
  }
}

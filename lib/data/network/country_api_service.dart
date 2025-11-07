import 'package:countries/data/models/country_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'country_api_service.g.dart';

@RestApi()
abstract class CountryApiService {
  factory CountryApiService(Dio dio, {String? baseUrl}) = _CountryApiService;

  @GET(
    '/v3.1/all?fields=name,flags,capital,idd,currencies,cca2,population,region,languages,timezones',
  )
  Future<List<CountryModel>> getCountries();
}

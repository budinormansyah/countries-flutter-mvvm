import 'package:countries/domain/entities/country.dart' as domain;
import 'package:json_annotation/json_annotation.dart';

part 'country_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CountryModel {
  @JsonKey(name: 'name')
  final NameModel name;

  @JsonKey(name: 'flags')
  final FlagsModel flags;

  final List<String>? capital;

  @JsonKey(name: 'idd')
  final IddModel idd;

  @JsonKey(name: 'currencies')
  final Map<String, CurrencyModel>? currencies;

  final String cca2;
  final int population;
  final String region;
  final Map<String, String>? languages;
  final List<String> timezones;

  const CountryModel({
    required this.name,
    required this.flags,
    this.capital,
    required this.idd,
    this.currencies,
    required this.cca2,
    required this.population,
    required this.region,
    this.languages,
    required this.timezones,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CountryModelToJson(this);
}

extension CountryModelToDomain on CountryModel {
  domain.Country toDomain() {
    return domain.Country(
      name: name.toDomain(),
      flags: flags.toDomain(),
      capital: capital,
      idd: idd.toDomain(),
      currencies: currencies?.map(
        (key, value) => MapEntry(key, value.toDomain()),
      ),
      cca2: cca2,
      population: population,
      region: region,
      languages: languages,
      timezones: timezones,
    );
  }
}

@JsonSerializable()
class NameModel {
  @JsonKey(name: 'common')
  final String common;

  @JsonKey(name: 'official')
  final String official;

  const NameModel({required this.common, required this.official});

  factory NameModel.fromJson(Map<String, dynamic> json) =>
      _$NameModelFromJson(json);

  Map<String, dynamic> toJson() => _$NameModelToJson(this);
}

extension NameModelToDomain on NameModel {
  domain.Name toDomain() => domain.Name(common: common, official: official);
}

@JsonSerializable()
class FlagsModel {
  @JsonKey(name: 'png')
  final String png;

  @JsonKey(name: 'svg')
  final String svg;

  const FlagsModel({required this.png, required this.svg});

  factory FlagsModel.fromJson(Map<String, dynamic> json) =>
      _$FlagsModelFromJson(json);

  Map<String, dynamic> toJson() => _$FlagsModelToJson(this);
}

extension FlagsModelToDomain on FlagsModel {
  domain.Flags toDomain() => domain.Flags(png: png, svg: svg);
}

@JsonSerializable()
class IddModel {
  @JsonKey(name: 'root')
  final String? root;

  @JsonKey(name: 'suffixes')
  final List<String>? suffixes;

  const IddModel({this.root, this.suffixes});

  factory IddModel.fromJson(Map<String, dynamic> json) =>
      _$IddModelFromJson(json);

  Map<String, dynamic> toJson() => _$IddModelToJson(this);
}

extension IddModelToDomain on IddModel {
  domain.Idd toDomain() => domain.Idd(root: root, suffixes: suffixes);
}

@JsonSerializable()
class CurrencyModel {
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'symbol')
  final String? symbol;

  const CurrencyModel({required this.name, this.symbol});

  factory CurrencyModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyModelToJson(this);
}

extension CurrencyModelToDomain on CurrencyModel {
  domain.Currency toDomain() => domain.Currency(name: name, symbol: symbol);
}

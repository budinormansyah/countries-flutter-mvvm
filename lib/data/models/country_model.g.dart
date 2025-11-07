// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryModel _$CountryModelFromJson(Map<String, dynamic> json) => CountryModel(
  name: NameModel.fromJson(json['name'] as Map<String, dynamic>),
  flags: FlagsModel.fromJson(json['flags'] as Map<String, dynamic>),
  capital: (json['capital'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  idd: IddModel.fromJson(json['idd'] as Map<String, dynamic>),
  currencies: (json['currencies'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, CurrencyModel.fromJson(e as Map<String, dynamic>)),
  ),
  cca2: json['cca2'] as String,
  population: (json['population'] as num).toInt(),
  region: json['region'] as String,
  languages: (json['languages'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  timezones: (json['timezones'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$CountryModelToJson(CountryModel instance) =>
    <String, dynamic>{
      'name': instance.name.toJson(),
      'flags': instance.flags.toJson(),
      'capital': instance.capital,
      'idd': instance.idd.toJson(),
      'currencies': instance.currencies?.map((k, e) => MapEntry(k, e.toJson())),
      'cca2': instance.cca2,
      'population': instance.population,
      'region': instance.region,
      'languages': instance.languages,
      'timezones': instance.timezones,
    };

NameModel _$NameModelFromJson(Map<String, dynamic> json) => NameModel(
  common: json['common'] as String,
  official: json['official'] as String,
);

Map<String, dynamic> _$NameModelToJson(NameModel instance) => <String, dynamic>{
  'common': instance.common,
  'official': instance.official,
};

FlagsModel _$FlagsModelFromJson(Map<String, dynamic> json) =>
    FlagsModel(png: json['png'] as String, svg: json['svg'] as String);

Map<String, dynamic> _$FlagsModelToJson(FlagsModel instance) =>
    <String, dynamic>{'png': instance.png, 'svg': instance.svg};

IddModel _$IddModelFromJson(Map<String, dynamic> json) => IddModel(
  root: json['root'] as String?,
  suffixes: (json['suffixes'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$IddModelToJson(IddModel instance) => <String, dynamic>{
  'root': instance.root,
  'suffixes': instance.suffixes,
};

CurrencyModel _$CurrencyModelFromJson(Map<String, dynamic> json) =>
    CurrencyModel(
      name: json['name'] as String,
      symbol: json['symbol'] as String?,
    );

Map<String, dynamic> _$CurrencyModelToJson(CurrencyModel instance) =>
    <String, dynamic>{'name': instance.name, 'symbol': instance.symbol};

import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final Name name;
  final Flags flags;
  final List<String>? capital;
  final Idd idd;
  final Map<String, Currency>? currencies;
  final String cca2;
  final int population;
  final String region;
  final Map<String, String>? languages;
  final List<String> timezones;

  const Country({
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

  @override
  List<Object?> get props => [
    name,
    flags,
    capital,
    idd,
    currencies,
    cca2,
    population,
    region,
    languages,
    timezones,
  ];
}

class Name extends Equatable {
  final String common;
  final String official;

  const Name({required this.common, required this.official});

  @override
  List<Object?> get props => [common, official];
}

class Flags extends Equatable {
  final String png;
  final String svg;

  const Flags({required this.png, required this.svg});

  @override
  List<Object?> get props => [png, svg];
}

class Idd extends Equatable {
  final String? root;
  final List<String>? suffixes;

  const Idd({this.root, this.suffixes});

  @override
  List<Object?> get props => [root, suffixes];
}

class Currency extends Equatable {
  final String name;
  final String? symbol;

  const Currency({required this.name, this.symbol});

  @override
  List<Object?> get props => [name, symbol];
}

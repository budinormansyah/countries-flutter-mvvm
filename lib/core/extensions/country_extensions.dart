import 'package:countries/domain/entities/country.dart';

extension CountryFormatting on Country {
  String get formattedCurrency {
    if (currencies == null || currencies!.isEmpty) {
      return 'N/A';
    }
    final currencyCode = currencies!.keys.first;
    final currencyDetail = currencies![currencyCode]!;
    final symbol = currencyDetail.symbol != null
        ? '${currencyDetail.symbol} '
        : '';
    return '$symbol${currencyDetail.name} ($currencyCode)';
  }

  String get formattedPhonePrefix {
    if (idd.root == null) return 'N/A';
    return idd.root! +
        (idd.suffixes?.isNotEmpty == true ? idd.suffixes!.first : 'N/A');
  }

  String get formattedLanguages {
    if (languages == null || languages!.isEmpty) return 'N/A';
    return languages!.values.join(', ');
  }
}

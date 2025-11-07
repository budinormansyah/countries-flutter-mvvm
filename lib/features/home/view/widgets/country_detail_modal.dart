import 'package:countries/core/extensions/country_extensions.dart';
import 'package:countries/core/theme/app_palette.dart';
import 'package:countries/core/widgets/cached_network_svg.dart';
import 'package:countries/domain/entities/country.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CountryDetailModal extends StatelessWidget {
  final Country country;
  const CountryDetailModal({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        constraints: const BoxConstraints(maxWidth: 650),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Modal Header ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkSvg(
                          url: country.flags.svg,
                          width: 60,
                          height: 45,
                          fit: BoxFit.contain,
                          placeholder: Container(color: Colors.grey[300]),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          country.name.common,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Divider(thickness: 3, color: AppPalette.primaryAccent),
                  const SizedBox(height: 15),
                  // --- Modal Details ---
                  _ModalDetailItem(
                    icon: '🆔',
                    title: 'Code',
                    value: country.cca2,
                  ),
                  _ModalDetailItem(
                    icon: '🏛️',
                    title: 'Capital',
                    value: (country.capital?.isEmpty ?? true)
                        ? 'N/A'
                        : country.capital!.join(', '),
                  ),
                  _ModalDetailItem(
                    icon: '👥',
                    title: 'Population',
                    value:
                        '${NumberFormat.decimalPattern('en_US').format(country.population)} people',
                  ),
                  _ModalDetailItem(
                    icon: '🌍',
                    title: 'Region',
                    value: country.region,
                  ),
                  _ModalDetailItem(
                    icon: '🗣️',
                    title: 'Languages',
                    value: country.formattedLanguages,
                  ),
                  _ModalDetailItem(
                    icon: '📞',
                    title: 'Phone Prefix',
                    value: country.formattedPhonePrefix,
                  ),
                  _ModalDetailItem(
                    icon: '💰',
                    title: 'Currency',
                    value: country.formattedCurrency,
                  ),
                  _ModalDetailItem(
                    icon: '⏱️',
                    title: 'Timezones',
                    value: country.timezones.join(', '),
                  ),
                ],
              ),
            ),
            // --- Close Button ---
            Positioned(
              top: -8,
              right: -8,
              child: InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(30),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppPalette.transparentColor,
                  child: Icon(
                    Icons.close,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModalDetailItem extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  const _ModalDetailItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

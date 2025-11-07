import 'package:countries/core/extensions/country_extensions.dart';
import 'package:countries/core/widgets/cached_network_svg.dart';
import 'package:countries/domain/entities/country.dart';
import 'package:flutter/material.dart';

class CountryCard extends StatelessWidget {
  final Country country;
  final VoidCallback onTap;

  const CountryCard({super.key, required this.country, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Theme.of(context).cardColor,
      shadowColor: Colors.amber.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Card Header ---
                Row(
                  children: [
                    SizedBox(
                      width: 45,
                      height: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: CachedNetworkSvg(
                          url: country.flags.svg,
                          fit: BoxFit.contain,
                          placeholder: Container(color: Colors.grey[300]),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        country.name.common,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          // color: AppPalette.primaryAccent,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '(${country.cca2})',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const Divider(height: 20),
                // --- Card Body ---
                _DetailItem(
                  icon: '🏠',
                  text: (country.capital?.isEmpty ?? true)
                      ? 'N/A'
                      : country.capital!.join(', '),
                ),
                const SizedBox(height: 1),
                _DetailItem(icon: '📞', text: country.formattedPhonePrefix),
                const SizedBox(height: 1),
                _DetailItem(icon: '💰', text: country.formattedCurrency),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String icon;
  final String text;

  const _DetailItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

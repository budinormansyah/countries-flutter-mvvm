import 'package:countries/core/widgets/not_found_indicator.dart';
import 'package:countries/core/theme/theme_controller.dart';
import 'package:countries/core/theme/app_palette.dart';
import 'package:countries/features/home/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:countries/features/home/view/widgets/country_card.dart';
import 'package:countries/features/home/view/widgets/country_detail_modal.dart';

class HomePage extends GetView<HomeViewModel> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final double aspectRatio = (orientation == Orientation.portrait)
        ? 1.2
        : 1.8;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // --- SEARCH BAR STICKY ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(
                      151,
                      151,
                      150,
                      1,
                    ), //Colors.amber.shade50,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Obx(
                () => TextField(
                  controller: controller.searchController,
                  onChanged: controller.searchCountries,
                  decoration: InputDecoration(
                    hintText: 'Search by Name, Capital, or Code...',
                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFC4D3DF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppPalette.primaryAccent,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),
                    suffixIcon: controller.searchQuery.value.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: controller.clearSearch,
                          )
                        : null,
                    prefixIcon: Obx(
                      () => IconButton(
                        icon: Icon(
                          ThemeController.to.isDarkMode.value
                              ? Icons.light_mode
                              : Icons.dark_mode,
                        ),
                        onPressed: () => ThemeController.to.switchTheme(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // --- Main Content ---
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.value != null) {
                  return Center(child: Text(controller.errorMessage.value!));
                }

                if (controller.filteredCountries.isEmpty &&
                    !controller.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const NotFoundIndicator(key: ValueKey('not_found')),
                        const Text(
                          'Data not found.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 350, // Similar to minmax(280px, 1fr)
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: aspectRatio,
                  ),
                  itemCount: controller.filteredCountries.length,
                  itemBuilder: (context, index) {
                    final country = controller.filteredCountries[index];
                    return CountryCard(
                      country: country,
                      onTap: () {
                        Get.generalDialog(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                                return CountryDetailModal(country: country);
                              },
                          transitionDuration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (context, animation, secondaryAnimation, child) {
                                final curvedAnimation = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                );

                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, -0.1),
                                    end: Offset.zero,
                                  ).animate(curvedAnimation),
                                  child: FadeTransition(
                                    opacity: curvedAnimation,
                                    child: child,
                                  ),
                                );
                              },
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

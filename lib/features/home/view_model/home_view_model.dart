import 'package:countries/domain/entities/country.dart';
import 'package:countries/domain/usecases/get_countries_usecase.dart';
import 'package:countries/domain/usecases/get_local_countries_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomeViewModel extends GetxController {
  final GetLocalCountriesUseCase _getLocalCountriesUseCase;
  final GetCountriesUseCase _getCountriesUseCase;

  HomeViewModel({
    required GetLocalCountriesUseCase getLocalCountriesUseCase,
    required GetCountriesUseCase getCountriesUseCase,
  }) : _getLocalCountriesUseCase = getLocalCountriesUseCase,
       _getCountriesUseCase = getCountriesUseCase;

  final RxBool isLoading = true.obs;
  final RxList<Country> countries = <Country>[].obs;
  final RxList<Country> filteredCountries = <Country>[].obs;
  final Rx<String?> errorMessage = Rx<String?>(null);

  final searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // 1. Load countries from local DB to show UI quickly.
    loadCountries();
    // 2. Fetch from API in the background (non-blocking).
    _fetchAndRefreshData();

    debounce(
      searchQuery,
      (query) => _performSearch(query),
      time: const Duration(milliseconds: 500),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Loads countries from the local database and updates the UI.
  /// This is the primary method for displaying data.
  Future<void> loadCountries() async {
    isLoading.value = true;
    errorMessage.value = null;

    countries.clear();
    filteredCountries.clear();

    final result = await _getLocalCountriesUseCase();

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (countryList) {
        countryList.sort((a, b) => a.name.common.compareTo(b.name.common));
        countries.assignAll(countryList);
        filteredCountries.assignAll(countryList);
        isLoading.value = false;
      },
    );
  }

  /// Fetches data from the API in the background. If the data is new,
  /// it saves it to the local DB and triggers a UI refresh.
  Future<void> _fetchAndRefreshData() async {
    final remoteResult = await _getCountriesUseCase();

    await remoteResult.fold(
      (failure) {
        // The user already sees the local data, so no need to show an error.
        debugPrint('Background fetch failed: ${failure.message}');
      },
      (remoteCountries) async {
        // Sort both lists to ensure consistent comparison
        remoteCountries.sort((a, b) => a.name.common.compareTo(b.name.common));
        final currentCountries = List<Country>.from(countries);
        currentCountries.sort((a, b) => a.name.common.compareTo(b.name.common));

        if (!listEquals(remoteCountries, currentCountries)) {
          debugPrint('Data is different. Updating local database and UI.');
          await loadCountries();
        } else {
          debugPrint('Data is the same. No update needed.');
        }
      },
    );
  }

  void searchCountries(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      filteredCountries.assignAll(countries);
    } else {
      final searchTerm = query.toLowerCase();
      final result = countries.where((country) {
        final commonName = country.name.common.toLowerCase();
        final officialName = country.name.official.toLowerCase();
        final capitalName = country.capital?.isNotEmpty == true
            ? country.capital![0].toLowerCase()
            : '';
        final code = country.cca2.toLowerCase();

        return commonName.contains(searchTerm) ||
            officialName.contains(searchTerm) ||
            capitalName.contains(searchTerm) ||
            code.contains(searchTerm);
      }).toList();
      filteredCountries.assignAll(result);
    }
  }
}

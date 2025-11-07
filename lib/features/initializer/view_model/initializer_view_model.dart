import 'package:countries/core/routes/routes.dart';
import 'package:countries/domain/usecases/get_countries_usecase.dart';
import 'package:countries/domain/usecases/get_local_countries_usecase.dart';
import 'package:countries/core/utils/logging_service.dart';
import 'package:get/get.dart';

class InitializerViewModel extends GetxController {
  final GetCountriesUseCase _getCountriesUseCase;
  final GetLocalCountriesUseCase _getLocalCountriesUseCase;
  final LoggingService _log;

  InitializerViewModel({
    required LoggingService log,
    required GetCountriesUseCase getCountriesUseCase,
    required GetLocalCountriesUseCase getLocalCountriesUseCase,
  }) : _getCountriesUseCase = getCountriesUseCase,
       _getLocalCountriesUseCase = getLocalCountriesUseCase,
       _log = log;

  final errorMessage = ''.obs;

  @override
  void onReady() {
    super.onReady();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    _log.logInfo('Fetching initial data...');
    final resultLocal = await _getLocalCountriesUseCase();

    resultLocal.fold(
      (localFailure) {
        _log.logInfo('Failed to load local countries. Fetching from remote..');
        _fetchFromRemote();
      },
      (localCountries) {
        if (localCountries.isNotEmpty) {
          _log.logInfo('Local countries loaded successfully.');
          gotoHomePage();
        } else {
          _fetchFromRemote();
        }
      },
    );
  }

  void gotoHomePage() {
    Get.offAllNamed(PageTo.home);
  }

  Future<void> _fetchFromRemote() async {
    _log.logInfo('Fetching countries from remote...');
    final resultRemote = await _getCountriesUseCase();
    resultRemote.fold(
      (remoteFailure) {
        errorMessage.value = remoteFailure.message;
      },
      (remoteCountries) {
        gotoHomePage();
      },
    );
  }
}

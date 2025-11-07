import 'package:countries/data/network/country_api_service.dart';
import 'package:countries/data/repository/country_local_repository_impl.dart';
import 'package:countries/data/repository/country_remote_repository_impl.dart';
import 'package:countries/domain/repository/country_local_repository.dart';
import 'package:countries/domain/repository/country_remote_repository.dart';
import 'package:countries/domain/usecases/get_countries_usecase.dart';
import 'package:countries/domain/usecases/get_local_countries_usecase.dart';
import 'package:countries/features/initializer/view_model/initializer_view_model.dart';
import 'package:get/get.dart';

class InitializerBinding extends Bindings {
  @override
  void dependencies() {
    // Data Layer Dependencies
    Get.lazyPut<CountryLocalRepository>(
      () => CountryLocalRepositoryImpl(Get.find()),
    );
    Get.lazyPut<CountryRemoteRepository>(
      () => CountryRemoteRepositoryImpl(
        Get.find<CountryApiService>(),
        Get.find<CountryLocalRepository>(),
      ),
    );

    // Domain Layer Dependencies (Use Case)
    Get.lazyPut(() => GetCountriesUseCase(Get.find()));
    Get.lazyPut(() => GetLocalCountriesUseCase(Get.find()));

    // Presentation Layer Dependencies (ViewModel)
    Get.lazyPut(
      () => InitializerViewModel(
        log: Get.find(),
        getCountriesUseCase: Get.find(),
        getLocalCountriesUseCase: Get.find(),
      ),
    );
  }
}

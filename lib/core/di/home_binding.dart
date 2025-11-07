import 'package:countries/data/repository/country_local_repository_impl.dart';
import 'package:countries/domain/repository/country_local_repository.dart';
import 'package:countries/domain/usecases/get_countries_usecase.dart';
import 'package:countries/features/home/view_model/home_view_model.dart';
import 'package:get/get.dart';
import 'package:countries/domain/usecases/get_local_countries_usecase.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Data Layer Dependencies
    Get.lazyPut<CountryLocalRepository>(
      () => CountryLocalRepositoryImpl(Get.find()),
    );

    // Domain Layer Dependencies (Use Case)
    Get.lazyPut(() => GetCountriesUseCase(Get.find()));
    Get.lazyPut(() => GetLocalCountriesUseCase(Get.find()));

    // Presentation Layer Dependencies (ViewModel)
    Get.lazyPut(
      () => HomeViewModel(
        getLocalCountriesUseCase: Get.find<GetLocalCountriesUseCase>(),
        getCountriesUseCase: Get.find<GetCountriesUseCase>(),
      ),
      fenix: true,
    );
  }
}

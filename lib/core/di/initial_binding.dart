import 'package:countries/core/constants/server_constant.dart';
import 'package:countries/core/theme/theme_controller.dart';
import 'package:countries/core/utils/logging_service.dart';
import 'package:countries/data/database/database_service.dart';
import 'package:countries/data/network/country_api_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.baseUrl = ServerConstant.baseUrl;
    Get.put<Dio>(dio, permanent: true);

    // Core Services
    Get.put<ThemeController>(ThemeController(), permanent: true);
    Get.put<LoggingService>(LoggingService(), permanent: true);
    Get.put<DatabaseService>(DatabaseService(), permanent: true);
    Get.put<CountryApiService>(
      CountryApiService(Get.find<Dio>()),
      permanent: true,
    );

    Get.find<LoggingService>().logDebug(
      '==> All main dependencies initialized',
    );
  }
}

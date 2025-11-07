import 'dart:async';

import 'package:countries/core/di/initial_binding.dart';
import 'package:countries/core/theme/app_theme.dart';
import 'package:countries/core/theme/theme_controller.dart';
import 'package:countries/core/routes/routes.dart';
import 'package:countries/core/utils/logging_service.dart';
import 'package:countries/core/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await GetStorage.init();

      // --- Edge-to-Edge Setup ---
      // This enables the app to draw behind the system bars.
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      // This makes the system bars transparent.
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          statusBarColor: Colors.transparent,
        ),
      );
      // --- End of Edge-to-Edge Setup ---

      InitialBinding().dependencies();

      addFontLicenseRegistry();
      CacheManager.logLevel = CacheManagerLogLevel.verbose;

      runApp(const MyApp());
    },
    (error, stack) {
      LoggingService().logError('Zoned Error', error: error, stackTrace: stack);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ThemeController>(
      builder: (controller) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'KontriPleg',
          theme: AppTheme.lightThemeMode,
          darkTheme: AppTheme.darkThemeMode,
          themeMode: controller.theme,
          initialRoute: PageTo.initializer,
          getPages: BaseRoute.pages(),
        );
      },
    );
  }
}
